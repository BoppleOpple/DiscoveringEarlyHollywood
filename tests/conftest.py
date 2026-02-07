import os
from unittest.mock import MagicMock, patch

import pytest

# Mock DB connection 
try:
    _mock_connect = patch("psycopg2.connect", return_value=MagicMock())
    _mock_connect.start()
except ModuleNotFoundError:
    pass

os.environ.setdefault("FLASK_SECRET", "test-secret-key-for-pytest")


@pytest.fixture
def app():
    from backend.app import app as flask_app

    flask_app.config["TESTING"] = True
    return flask_app


@pytest.fixture
def client(app):
    return app.test_client()
