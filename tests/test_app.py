from backend.app import valid_id


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


# class TestIndex():
#     def test_default_index_page(self, client):
#         page = client.get("/")
#         print(page)
#         assert 0
