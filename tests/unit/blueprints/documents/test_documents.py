from flask import testing

from backend.blueprints.document.document import _valid_id

from pytest_mock import MockerFixture, MockType


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
    def test_invalid_id_gives_404(
        self, mocker: MockerFixture, client: testing.FlaskClient
    ):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        assert response.status_code == 404

    def test_missing_file_gives_404(
        self, mocker: MockerFixture, client: testing.FlaskClient
    ):
        # Arrange
        doc_id: str = "s1234l56789"

        mock_exists: MockType = mocker.patch("pathlib.Path.exists")
        mock_exists.return_value = False

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

        # Assert
        assert response.status_code == 404

    # def test_existing_file_sends_file(self, mocker: MockerFixture, client: testing.FlaskClient):
    #     # Arrange
    #     doc_id: str = "s1234l56789"

    #     mock_exists: MockType = mocker.patch("pathlib.Path.exists")
    #     mock_exists.return_value = True

    #     mock_send_file: MockType = mocker.patch("flask.send_file")
    #     mock_send_file.return_value = None

    #     mock_open: MockType = mocker.patch("builtins.open")
    #     mock_open.return_value = BytesIO()

    #     # Act
    #     with client:
    #         response: testing.TestResponse = client.get(f"/document/{doc_id}.pdf")

    #     # Assert
    #     print(response.get_data())
    #     assert response.content_type
    #     assert False


class TestDownloadCSV:
    def test_invalid_id_gives_404(
        self, mocker: MockerFixture, client: testing.FlaskClient
    ):
        # Arrange
        doc_id: str = "invalid string"

        # Act
        with client:
            response: testing.TestResponse = client.get(f"/document/{doc_id}.csv")

        # Assert
        assert response.status_code == 404
