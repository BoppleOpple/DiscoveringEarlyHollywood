import re

from flask import testing
from unittest.mock import patch

from backend.datatypes import Document, Query


class TestIndex:
    def test_default_index_page(self, client: testing.FlaskClient, mock_psycopg2):
        # Arrange

        # return 2 documents
        mock_results: list[Document] = [
            Document(
                None,
                id="s1111m11111",
                studio="studio_1",
                title="Document 1",
                copyrightYear=1111,
            ),
            Document(
                None,
                id="s2222m22222",
                studio="studio_2",
                title="Document 2",
                copyrightYear=2222,
            ),
        ]

        with (
            patch("backend.db_utils.get_num_results", return_value=2),
            patch(
                "backend.db_utils.search_results", return_value=mock_results
            ) as mock_search_results,
            patch("backend.db_utils.get_headlines"),
        ):
            # Act
            with client:
                response: testing.TestResponse = client.get("/")
                text_data: str = response.get_data(as_text=True)
                visible_text_data: str = re.sub(
                    r"<!--.*?-->",
                    "",
                    text_data,
                    flags=re.DOTALL,
                )

                search_args: tuple = mock_search_results.call_args[0]

        # Assert
        # route assertions
        assert response.status_code == 200, "The website root shall return [200 OK]"

        assert (
            response.mimetype == "text/html"
        ), "The website root shall return an html page"

        # query assertions
        assert (
            mock_psycopg2["connection"] in search_args
        ), "db_utils.search_results shall be called with the global connection object"

        assert any(
            type(arg) is Query for arg in search_args
        ), "db_utils.search_results shall be called with a `Query` object"

        # content assertions
        assert (
            "2 documents found" in text_data
        ), "The website shall display the number of documents found"

        assert (
            "Document 1" in text_data and "Document 2" in text_data
        ), "The website shall display the document titles"

        assert (
            "1111" in text_data and "2222" in text_data
        ), "The website shall display the document copyright years"

        assert (
            "s1111m11111.jpg" in text_data and "s2222m22222.jpg" in text_data
        ), "The website shall display the document thumbnails"

        assert (
            "Documents Manager" not in visible_text_data
        ), "The website shall not show a Documents Manager nav link"

        assert (
            'name="genre"' not in visible_text_data
        ), "The website shall not show a genre search control"
