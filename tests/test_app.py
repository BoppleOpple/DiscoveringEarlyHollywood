from flask import testing
from unittest.mock import patch

from backend.app import valid_id
from backend.datatypes import Document, Query


class TestValidId:
    def test_id_none_invalid(self):
        id: str = None
        assert valid_id(id) is False, "id of `None` shall be invalid"

    def test_valid_id(self):
        id: str = "s1234l56789"
        assert valid_id(id) is True, "id of `s1234l56789` shall be valid"

    def test_invalid_id(self):
        id: str = "foobar"
        assert valid_id(id) is False, "id of `foobar` shall be invalid"


class TestIndex:
    def test_default_index_page(self, client: testing.FlaskClient, mock_psycopg2):
        # return 2 documents
        with patch("backend.db_utils.get_num_results", return_value=2):
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
            with patch(
                "backend.db_utils.search_results", return_value=mock_results
            ) as search_mock:
                with client:
                    response: testing.TestResponse = client.get("/")
                    text_data: str = response.get_data(as_text=True)

                    search_args: tuple = search_mock.call_args[0]
                    # query: Query = tuple(
                    #     filter(lambda arg: type(arg) is Query, search_args)
                    # )[0]

                    # route assertions
                    assert (
                        response.status_code == 200
                    ), "The website root shall return [200 OK]"

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
                        "s1111m11111.jpg" in text_data
                        and "s2222m22222.jpg" in text_data
                    ), "The website shall display the document thumbnails"
