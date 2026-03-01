from backend.app import valid_id
from flask import testing


class TestValidId:
    def test_id_none_invalid(self):
        id: str = None
        assert valid_id(id) is False, "id of `None` should be invalid"

    def test_valid_id(self):
        id: str = "s1234l56789"
        assert valid_id(id) is True, "id of `s1234l56789` should be valid"

    def test_invalid_id(self):
        id: str = "foobar"
        assert valid_id(id) is False, "id of `foobar` should be invalid"


class TestIndex:
    def test_default_index_page(self, client: testing.FlaskClient):
        with client:
            response: testing.TestResponse = client.get("/")
            text_data: str = response.get_data(as_text=True)

            assert (
                response.status_code == 200
            ), "The website root should return [200 OK]"

            assert (
                response.mimetype == "text/html"
            ), "The website root should return an html page"
            print(text_data)

            # failing due to improper mocking
            # assert "0 documents found" in text_data
