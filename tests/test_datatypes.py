
from backend.datatypes import Document, Flag, Query


class TestQuery:
    def test_set_keywords(self):
        q = Query()
        q.setKeywords(["comedy", "drama"])
        assert q.keywords == ["comedy", "drama"]

    def test_add_keyword(self):
        q = Query()
        q.setKeywords(["comedy"])
        q.addKeyword("drama")
        assert q.keywords == ["comedy", "drama"]

    def test_set_copyright_year_range(self):
        q = Query()
        q.setCopyrightYearRange(1915, 1925)
        assert q.copyrightYearRange == (1915, 1925)

    def test_set_duration_range(self):
        q = Query()
        q.setDurationRange(5, 10)
        assert q.durationRange == (5, 10)

    def test_set_actors(self):
        q = Query()
        q.setActors(["Charlie Chaplin", "Buster Keaton"])
        assert q.actors == ["Charlie Chaplin", "Buster Keaton"]

    def test_set_genres(self):
        q = Query()
        q.setGenres(["comedy", "drama"])
        assert q.genres == ["comedy", "drama"]

    def test_set_studio(self):
        q = Query()
        q.setStudio("Universal")
        assert q.studio == "Universal"

    def test_constructor_with_keywords(self):
        q = Query(keywords=["silent", "film"])
        assert q.keywords == ["silent", "film"]


class TestDocument:
    def test_get_id(self):
        doc = Document(
            None,
            id="s0000l11111",
            title="Test Film",
            studio="MGM",
            copyrightYear=1920,
        )
        assert doc.getId() == "s0000l11111"

    def test_metadata_populated(self):
        doc = Document(
            None,
            id="s0000l11111",
            title="Test Film",
            studio="MGM",
            copyrightYear=1920,
        )
        assert doc.metadata.id == "s0000l11111"
        assert doc.metadata.title == "Test Film"
        assert doc.metadata.studio == "MGM"
        assert doc.metadata.copyrightYear == 1920


class TestFlag:
    def test_flag_creation(self):
        flag = Flag(
            reporterName="user1",
            errorLoaction="page 3",
            errorDescription="Missing text",
        )
        assert flag.reporterName == "user1"
        assert flag.errorLoaction == "page 3"
        assert flag.errorDescription == "Missing text"
