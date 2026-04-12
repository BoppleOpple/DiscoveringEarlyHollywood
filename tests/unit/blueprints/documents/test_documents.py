from flask import testing

from backend.blueprints.document.document import _valid_id, _bool_string

from pytest_mock import MockerFixture, MockType
import pytest


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
