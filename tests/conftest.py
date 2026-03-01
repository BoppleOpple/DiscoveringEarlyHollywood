import os
from flask import Flask
from unittest.mock import MagicMock, patch

from dotenv import load_dotenv
import pytest

# Mock DB connection
try:
    _mock_connect = patch("psycopg2.connect", return_value=MagicMock())
    _mock_connect.start()
except ModuleNotFoundError:
    pass


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
        FLASK_SECRET=os.environ["FLASK_SECRET"],
        UPLOAD_FOLDER="uploads",
        SQL_HOST=os.environ["SQL_HOST"],
        SQL_PORT=os.environ["SQL_PORT"],
        SQL_DBNAME=os.environ["SQL_DBNAME"],
        SQL_USER=os.environ["SQL_USER"],
        SQL_PASSWORD=os.environ["SQL_PASSWORD"],
        DOCUMENT_DIR=os.environ["DOCUMENT_DIR"],
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
