from flask import testing
from unittest.mock import ANY, patch
from backend.blueprints.document.document import _valid_id
from backend.datatypes import Document, Flag


class TestValidId:
    def test_id_none_invalid(self):
        id: str = None
        assert _valid_id(id) is False, "id of `None` shall be invalid"

    def test_valid_id(self):
        id: str = "s1234l56789"
        assert _valid_id(id) is True, "id of `s1234l56789` shall be valid"

    def test_invalid_id(self):
        id: str = "foobar"
        assert _valid_id(id) is False, "id of `foobar` shall be invalid"


class TestDownloadPDF:
    def test_invalid_id_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        assert response.status_code == 404

    def test_missing_file_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "s1234l56789"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        assert response.status_code == 404

    def test_existing_file_sends_file(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "s1229l00001"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        with open(
            "./test_data/documents/s1229l00001/s1229l00001.pdf", "rb"
        ) as document:
            assert response.get_data() == document.read()


class TestDownloadCSV:
    def test_invalid_id_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.csv")

        # Assert
        assert response.status_code == 404

    def test_missing_file_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "s1234l56789"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.csv")

        # Assert
        assert response.status_code == 404

    def test_existing_file_sends_utf8_file(
        self, client: testing.FlaskClient, mock_psycopg2
    ):
        # Arrange
        doc_id: str = "s1229l00001"
        csv_data: str = "foobar"
        expected_bytes: bytes = csv_data.encode("utf-8")
        mock_document: Document = Document(None, id=doc_id, title="Document 1")

        with (
            patch("backend.db_utils.get_document", return_value=mock_document),
            patch("backend.db_utils.get_documents_as_csv", return_value=csv_data),
        ):
            # Act
            with client:
                response: testing.TestResponse = client.get(f"/document/{doc_id}.csv")

        # Assert
        assert response.get_data() == expected_bytes


class TestFlagDocument:
    def test_document_detail_renders_flag_form(self, client: testing.FlaskClient):
        mock_document: Document = Document(
            None,
            id="s1111m11111",
            title="Document 1",
            studio="studio_1",
            copyrightYear=1111,
            transcripts=[(0, "Transcript text")],
        )
        with patch("backend.db_utils.get_document", return_value=mock_document):
            response: testing.TestResponse = client.get("/document/s1111m11111")
            text_data: str = response.get_data(as_text=True)

        assert response.status_code == 200
        assert 'name="error_location"' in text_data
        assert 'name="error_description"' in text_data

    def test_flag_document_requires_login(self, client: testing.FlaskClient):
        mock_document: Document = Document(None, id="s1111m11111", title="Document 1")
        with patch("backend.db_utils.get_document", return_value=mock_document):
            response: testing.TestResponse = client.post(
                "/document/flag/s1111m11111",
                data={
                    "error_location": "Page 3",
                    "error_description": "Transcript line is missing.",
                },
                follow_redirects=True,
            )

        text_data: str = response.get_data(as_text=True)
        assert response.status_code == 200
        assert "Log in to flag documents for review." in text_data

    def test_flag_document_saves_flag(self, client: testing.FlaskClient):
        mock_document: Document = Document(None, id="s1111m11111", title="Document 1")
        with (
            patch("backend.db_utils.get_document", return_value=mock_document),
            patch("backend.db_utils.log_flag") as mock_log_flag,
        ):
            with client.session_transaction() as session:
                session["user"] = "tester"

            response: testing.TestResponse = client.post(
                "/document/flag/s1111m11111",
                data={
                    "error_location": "Page 3",
                    "error_description": "Transcript line is missing.",
                    "return_to": "/?search=test",
                    "search_id": "12",
                },
            )

        assert response.status_code == 302
        assert "/document/s1111m11111" in response.headers["Location"]
        mock_log_flag.assert_called_once_with(
            ANY,
            user_name="tester",
            document_id="s1111m11111",
            error_location="Page 3",
            error_description="Transcript line is missing.",
        )

    def test_flagged_documents_page_renders_flags(self, client: testing.FlaskClient):
        mock_document: Document = Document(
            None,
            id="s1111m11111",
            title="Document 1",
            studio="studio_1",
            copyrightYear=1111,
            flags=[
                Flag(
                    reporterName="Jane Doe",
                    errorLocation="Page 3",
                    errorDescription="Transcript line is missing.",
                )
            ],
        )
        with patch("backend.db_utils.get_flagged", return_value=[mock_document]):
            response: testing.TestResponse = client.get("/flagged")
            text_data: str = response.get_data(as_text=True)

        assert response.status_code == 200
        assert "Jane Doe" in text_data
        assert "Page 3" in text_data
        assert "Transcript line is missing." in text_data
