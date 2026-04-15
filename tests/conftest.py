import os
import pytest
import re
from dotenv import load_dotenv
from flask import Flask, Response as TestResponse
from pytest_mock import MockerFixture, MockType
from typing import Callable


# Mock DB connection
@pytest.fixture()
def mock_psycopg2(mocker: MockerFixture):
    # mock `cursor` object
    mock_cursor = mocker.MagicMock()
    mock_cursor.fetchone = mocker.Mock(return_value=None)
    mock_cursor.fetchall = mocker.Mock(return_value=[])

    # mock `connection` object
    mock_connection = mocker.MagicMock()

    mock_cursor_generator = mocker.MagicMock()
    mock_cursor_generator.__enter__ = mocker.Mock(return_value=mock_cursor)
    mock_connection.cursor = mocker.Mock(return_value=mock_cursor_generator)

    # mock `connect` function
    mock_connect: MockType = mocker.patch(
        "psycopg2.connect", return_value=mock_connection
    )

    return {
        "connect": mock_connect,
        "connection": mock_connection,
        "cursor": mock_cursor,
    }


# Helper for getting a filename from a TestClient respones
@pytest.fixture()
def get_filename() -> Callable[[TestResponse], str]:
    def _get_filename(response: TestResponse) -> str:
        content_header: str = response.headers.get("Content-Disposition")

        filename_match: re.Match = re.search(
            r"filename=(.*?)(?:;|\n|\Z)", content_header
        )
        response_filename: str = filename_match.group(1)

        return response_filename

    return _get_filename


@pytest.fixture(autouse=True)
def env_vars():
    # Manage environment variables
    load_dotenv()

    # Override environment variables here
    os.environ["FLASK_SECRET"] = "test-secret-key-for-pytest"
    os.environ["SQL_DBNAME"] = (
        os.environ["SQL_TEST_DBNAME"] if "SQL_TEST_DBNAME" in os.environ else "testdb"
    )


@pytest.fixture
def app():
    from backend.app import create_app

    app: Flask = create_app(
        FLASK_SECRET="test-secret-key-for-pytest",
        UPLOAD_FOLDER="uploads",
        SQL_HOST="0.0.0.0",
        SQL_PORT="1234",
        SQL_DBNAME="testdb",
        SQL_USER="DB_User",
        SQL_PASSWORD="Password_Foo_Bar",
        DOCUMENT_DIR="./test_data/documents",
        POPPLER_PATH=(
            os.environ["POPPLER_PATH"] if "POPPLER_PATH" in os.environ else None
        ),
        RESULTS_PER_PAGE=20,
    )

    app.config["TESTING"] = True

    return app


@pytest.fixture
def client(app):
    return app.test_client()
