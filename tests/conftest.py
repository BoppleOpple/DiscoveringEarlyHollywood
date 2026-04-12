import os
from flask import Flask
from unittest.mock import Mock, MagicMock, patch

from dotenv import load_dotenv
import pytest


# Mock DB connection
@pytest.fixture()
def mock_psycopg2():
    # mock `cursor` object
    mock_cursor = MagicMock()
    mock_cursor.fetchone = Mock(return_value=None)
    mock_cursor.fetchall = Mock(return_value=[])

    # mock `connection` object
    mock_connection = MagicMock()

    mock_cursor_generator = MagicMock()
    mock_cursor_generator.__enter__ = Mock(return_value=mock_cursor)
    mock_connection.cursor = Mock(return_value=mock_cursor_generator)

    # mock `connect` function
    mock_connect = patch("psycopg2.connect", return_value=mock_connection).start()

    return {
        "connect": mock_connect,
        "connection": mock_connection,
        "cursor": mock_cursor,
    }


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
        POPPLER_PATH=("./poppler/bin"),
        RESULTS_PER_PAGE=20,
    )

    app.config["TESTING"] = True

    return app


@pytest.fixture
def client(app):
    return app.test_client()
