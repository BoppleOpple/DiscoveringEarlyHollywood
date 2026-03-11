from backend.blueprints.document.document import _valid_id


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
