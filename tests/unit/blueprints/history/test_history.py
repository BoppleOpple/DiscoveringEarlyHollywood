from flask import testing
from unittest.mock import patch


class TestReplaySearch:
    def test_replay_search_ignores_genre_filter(self, client: testing.FlaskClient):
        with patch(
            "backend.db_utils.get_search_history_entry",
            return_value={
                "id": 7,
                "search_text": "comedy",
                "start_year": 1914,
                "end_year": 1918,
                "genres": "drama",
            },
        ):
            with client.session_transaction() as session:
                session["user"] = "tester"

            response: testing.TestResponse = client.get("/history/history/replay/7")

        assert response.status_code == 302
        location: str = response.headers["Location"]
        assert "replay_search_id=7" in location
        assert "search=comedy" in location
        assert "year_min=1914" in location
        assert "year_max=1918" in location
        assert "genre=" not in location
