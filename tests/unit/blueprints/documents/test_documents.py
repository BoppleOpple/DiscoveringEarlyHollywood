import PIL
import pytest
from datetime import datetime
from flask import testing, request, url_for
from io import BytesIO
from pathlib import Path
from pytest_mock import MockerFixture, MockType

from backend.blueprints.document.document import _valid_id, _bool_string
from backend.datatypes import Document, Flag


@pytest.fixture
def example_document() -> Document:
    return Document(
        None,
        id="s1234l56789",
        studio="MGM",
        title="A great movie",
        documentType="synopsis",
        copyrightYear=1920,
        reelCount=4,
        uploadedTime=datetime.now(),
        uploadedBy="admin_user",
        actors=["Kayla Morris", "Greg Morris"],
        tags=["foo", "bar"],
        genres=["drama", "horror"],
        transcripts=[(1, "S1234L56789"), (2, "document body"), (3, "copyright page")],
        flags=[
            Flag(
                reporterName="userX",
                errorLocation="title",
                errorDescription="the title is incorrect.",
            )
        ],
    )


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


class TestBoolString:

    @pytest.mark.parametrize("string", [None, "False", "false", "arbitrary string"])
    def test_false_string(self, string: str | None):
        # Arrange
        expected_output: bool = False

        # Act
        result: bool = _bool_string(string)

        # Assert
        assert result == expected_output

    @pytest.mark.parametrize("string", ["True", "true"])
    def test_true_string(self, string: str):
        # Arrange
        expected_output: bool = True

        # Act
        result: bool = _bool_string(string)

        # Assert
        assert result == expected_output


class TestDocumentDetail:
    def test_invalid_id_returns_to_index(
        self, client: testing.FlaskClient, mock_psycopg2
    ):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            client.get(f"/document/{doc_id}", follow_redirects=True)
            final_path: str = request.path
            expected_path: str = url_for("index")

        # Assert
        assert final_path == expected_path

    def test_invalid_id_flashes_error(self, client: testing.FlaskClient, mock_psycopg2):
        # Arrange
        doc_id: str = "invalid string"
        expected_message: str = "Document not found"

        # Act
        with client:
            client.get(f"/document/{doc_id}")

            with client.session_transaction() as session:
                flashes: dict = dict(session["_flashes"])

        # Assert
        assert "error" in flashes, 'An "error" flash should be raised'
        assert (
            flashes["error"] == expected_message
        ), f'The error should be "{expected_message}"'

    def test_valid_id_displays_pages(
        self,
        mocker: MockerFixture,
        client: testing.FlaskClient,
        mock_psycopg2: dict,
        example_document: Document,
    ):
        # Arrange
        doc_id: str = example_document.id

        mocker.patch("backend.db_utils.get_document", return_value=example_document)

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}")
            page_urls: list[str] = [
                url_for(
                    "document.thumbnail",
                    doc_id=doc_id,
                    page=len(example_document.transcripts),
                )
            ]

        # Assert
        for url in page_urls:
            assert url in response.text

    def test_invalid_return_url_not_displayed(
        self,
        mocker: MockerFixture,
        client: testing.FlaskClient,
        mock_psycopg2: dict,
        example_document: Document,
    ):
        # Arrange
        doc_id: str = example_document.id
        return_url: str = "http://google.com"

        mocker.patch("backend.db_utils.get_document", return_value=example_document)

        # Act
        with client:
            # init http session, allowing `url_for`
            client.get(f"/document/{doc_id}")
            document_url: str = url_for(
                "document.document_detail", doc_id=doc_id, return_to=return_url
            )

            response: testing.TestResponse = client.get(document_url)

        # Assert
        assert return_url not in response.text

    def test_valid_return_url_displayed(
        self,
        mocker: MockerFixture,
        client: testing.FlaskClient,
        mock_psycopg2: dict,
        example_document: Document,
    ):
        # Arrange
        doc_id: str = example_document.id

        mocker.patch("backend.db_utils.get_document", return_value=example_document)

        # Act
        with client:
            # init http session, allowing `url_for`
            client.get(f"/document/{doc_id}")
            return_url: str = url_for("index")
            document_url: str = url_for(
                "document.document_detail", doc_id=doc_id, return_to=return_url
            )

            response: testing.TestResponse = client.get(document_url)

        # Assert
        assert return_url in response.text

    def test_document_added_to_history_with_search_id(
        self,
        mocker: MockerFixture,
        client: testing.FlaskClient,
        mock_psycopg2: dict,
        example_document: Document,
    ):
        # Arrange
        doc_id: str = example_document.id
        user_name: str = "example_user"
        search_id: int = 42
        document_url: str = f"/document/{doc_id}?search_id={search_id}"

        mocker.patch("backend.db_utils.get_document", return_value=example_document)
        mock_log_view: MockType = mocker.patch("backend.db_utils.log_view")

        mocker.patch(
            "backend.db_utils.get_search_history_entry", return_value={"id": search_id}
        )

        # Act
        with client:
            with client.session_transaction() as session:
                session["user"] = user_name

            client.get(document_url)

        # Assert
        assert mock_log_view.call_args.kwargs["user_name"] == user_name
        assert mock_log_view.call_args.kwargs["document_id"] == doc_id
        assert mock_log_view.call_args.kwargs["search_id"] == search_id

    def test_document_added_to_history_without_search_id(
        self,
        mocker: MockerFixture,
        client: testing.FlaskClient,
        mock_psycopg2: dict,
        example_document: Document,
    ):
        # Arrange
        doc_id: str = example_document.id
        user_name: str = "example_user"
        document_url: str = f"/document/{doc_id}"

        mocker.patch("backend.db_utils.get_document", return_value=example_document)
        mock_log_view: MockType = mocker.patch("backend.db_utils.log_view")

        # Act
        with client:
            with client.session_transaction() as session:
                session["user"] = user_name

            client.get(document_url)

        # Assert
        assert mock_log_view.call_args.kwargs["user_name"] == user_name
        assert mock_log_view.call_args.kwargs["document_id"] == doc_id
        assert mock_log_view.call_args.kwargs["search_id"] is None


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
        expected_file: Path = Path("./test_data/documents/s1229l00001/s1229l00001.pdf")

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        with open(expected_file, "rb") as document:
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
        self, mocker: MockerFixture, client: testing.FlaskClient, mock_psycopg2
    ):
        # Arrange
        doc_id: str = "s1229l00001"
        csv_data: str = "foobar"
        expected_bytes: bytes = csv_data.encode("utf-8")

        mock_get_documents_as_csv: MockType = mocker.patch(
            "backend.db_utils.get_documents_as_csv"
        )
        mock_get_documents_as_csv.return_value = csv_data

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.csv")

        # Assert
        assert response.get_data() == expected_bytes


class TestThumbnail:
    def test_invalid_id_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.jpg")

        # Assert
        assert response.status_code == 404

    def test_missing_file_gives_404(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "s1234l56789"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.jpg")

        # Assert
        assert response.status_code == 404

    def test_existing_file_sends_valid_jpeg_file(self, client: testing.FlaskClient):
        # Arrange
        doc_id: str = "s1229l00001"
        page: int = 1
        scale: float = 1
        expected_mimetype: str = "image/jpg"
        expected_format: str = "JPEG"

        # Act
        with client:
            response: testing.TestResponse = client.get(
                f"/document/{doc_id}.jpg?page={page}&scale={scale}"
            )
        image_buffer: BytesIO = BytesIO(response.get_data())
        image: PIL.ImageFile.ImageFile = PIL.Image.open(image_buffer)

        # Assert
        assert response.content_type == expected_mimetype
        assert image is not None
        assert image.format == expected_format

    @pytest.mark.parametrize(
        "page,expected_filename",
        [(1, "s1229l00001_page_1.jpg"), (2, "s1229l00001_page_2.jpg")],
    )
    def test_existing_file_sends_correct_filename(
        self,
        client: testing.FlaskClient,
        get_filename,
        page: int,
        expected_filename: str,
    ):
        # Arrange
        doc_id: str = "s1229l00001"
        scale: float = 1

        # Act
        with client:
            response: testing.TestResponse = client.get(
                f"/document/{doc_id}.jpg?page={page}&scale={scale}"
            )

        response_filename: str = get_filename(response)

        # Assert
        assert response_filename == expected_filename

    @pytest.mark.parametrize("page", [-1, 0, 1000])
    def test_out_of_bounds_page_gives_404(self, client: testing.FlaskClient, page: int):
        # Arrange
        doc_id: str = "s1229l00001"
        scale: float = 1

        # Act
        with client:
            response: testing.TestResponse = client.get(
                f"/document/{doc_id}.jpg?page={page}&scale={scale}"
            )

        # Assert
        assert response.status_code == 404
