import datetime
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

    def test_add_actor(self):
        q = Query(actors=["Walter Goggins"])
        q.addActor("Brad Pitt")
        assert q.actors == ["Walter Goggins", "Brad Pitt"]

    def test_set_tags(self):
        q = Query()
        q.setTags(["New", "Old"])
        assert q.tags == ["New", "Old"]

    def test_add_tags(self):
        q = Query(tags=["New"])
        q.addTag("Old")
        assert q.tags == ["New", "Old"]

    def test_set_genres(self):
        q = Query()
        q.setGenres(["comedy", "drama"])
        assert q.genres == ["comedy", "drama"]

    def test_add_genre(self):
        q = Query(genres=["Horror"])
        q.addGenre("Thriller")
        assert q.genres == ["Horror", "Thriller"]

    def test_set_document_type(self):
        q = Query()
        q.setDocumentType("TestType")
        assert q.documentType == "TestType"

    def test_set_studio(self):
        q = Query()
        q.setStudio("Universal")
        assert q.studio == "Universal"

    def test_constructor_with_keywords(self):
        q = Query(keywords=["silent", "film"])
        assert q.keywords == ["silent", "film"]


class TestDocument:
    def test_id(self):
        doc = Document(
            None,
            id="s0000l11111",
        )

        print("id should propogate from constructor")
        assert doc.metadata.id == "s0000l11111"
        assert doc.id == "s0000l11111"

        print("id should propogate from setter")
        doc.id = "s2222l33333"
        assert doc.metadata.id == "s2222l33333"
        assert doc.id == "s2222l33333"

    def test_studio(self):
        doc = Document(
            None,
            studio="MGM",
        )

        print("studio should propogate from constructor")
        assert doc.metadata.studio == "MGM"
        assert doc.studio == "MGM"

        print("studio should propogate from setter")
        doc.studio = "Ghibli"
        assert doc.metadata.studio == "Ghibli"
        assert doc.studio == "Ghibli"

    def test_title(self):
        doc = Document(
            None,
            title="Arsenic and Old Lace",
        )

        print("title should propogate from constructor")
        assert doc.metadata.title == "Arsenic and Old Lace"
        assert doc.title == "Arsenic and Old Lace"

        print("title should propogate from setter")
        doc.title = "Nosferatu"
        assert doc.metadata.title == "Nosferatu"
        assert doc.title == "Nosferatu"

    def test_copyrightYear(self):
        doc = Document(
            None,
            copyrightYear=1901,
        )

        print("copyrightYear should propogate from constructor")
        assert doc.metadata.copyrightYear == 1901
        assert doc.copyrightYear == 1901

        print("copyrightYear should propogate from setter")
        doc.copyrightYear = 1898
        assert doc.metadata.copyrightYear == 1898
        assert doc.copyrightYear == 1898

    def test_reelCount(self):
        doc = Document(
            None,
            reelCount=3,
        )

        print("reelCount should propogate from constructor")
        assert doc.metadata.reelCount == 3
        assert doc.reelCount == 3

        print("reelCount should propogate from setter")
        doc.reelCount = 1
        assert doc.metadata.reelCount == 1
        assert doc.reelCount == 1

    def test_uploadedTime(self):
        doc = Document(
            None,
            uploadedTime=datetime.datetime.fromisoformat("2025-12-22T14:51:11"),
        )

        print("uploadedTime should propogate from constructor")
        assert doc.metadata.uploadedTime == datetime.datetime.fromisoformat(
            "2025-12-22T14:51:11"
        )
        assert doc.uploadedTime == datetime.datetime.fromisoformat(
            "2025-12-22T14:51:11"
        )

        print("uploadedTime should propogate from setter")
        doc.uploadedTime = datetime.datetime.fromisoformat("2026-02-20T08:00:00")
        assert doc.metadata.uploadedTime == datetime.datetime.fromisoformat(
            "2026-02-20T08:00:00"
        )
        assert doc.uploadedTime == datetime.datetime.fromisoformat(
            "2026-02-20T08:00:00"
        )

    def test_uploadedBy(self):
        doc = Document(
            None,
            uploadedBy="John_Doe",
        )

        print("uploadedBy should propogate from constructor")
        assert doc.metadata.uploadedBy == "John_Doe"
        assert doc.uploadedBy == "John_Doe"

        print("uploadedBy should propogate from setter")
        doc.uploadedBy = "The_Grinch"
        assert doc.metadata.uploadedBy == "The_Grinch"
        assert doc.uploadedBy == "The_Grinch"

    def test_actors(self):
        doc = Document(
            None,
            actors=["Charlie Chaplin"],
        )

        print("actors should propogate from constructor")
        assert doc.metadata.actors == ["Charlie Chaplin"]
        assert doc.actors == ["Charlie Chaplin"]

        print("actors should propogate from setter")
        doc.actors = ["Walter Goggins", "Brad Pitt"]
        assert doc.metadata.actors == ["Walter Goggins", "Brad Pitt"]
        assert doc.actors == ["Walter Goggins", "Brad Pitt"]

    def test_tags(self):
        doc = Document(
            None,
            tags=["influential"],
        )

        print("tags should propogate from constructor")
        assert doc.metadata.tags == ["influential"]
        assert doc.tags == ["influential"]

        print("tags should propogate from setter")
        doc.tags = ["serial"]
        assert doc.metadata.tags == ["serial"]
        assert doc.tags == ["serial"]

    def test_genres(self):
        doc = Document(
            None,
            genres=["drama"],
        )

        print("genres should propogate from constructor")
        assert doc.metadata.genres == ["drama"]
        assert doc.genres == ["drama"]

        print("genres should propogate from setter")
        doc.genres = ["comedy", "commentary"]
        assert doc.metadata.genres == ["comedy", "commentary"]
        assert doc.genres == ["comedy", "commentary"]

    def test_content(self):
        doc = Document(
            None,
            transcripts=[(0, "page 1"), (1, "page 2")],
        )

        print(
            "content should concatenate the text of the transcript, seperated by newlines"
        )
        assert doc.content == "page 1\npage 2"


class TestFlag:
    def test_flag_creation(self):
        flag = Flag(
            reporterName="user1",
            errorLocation="page 3",
            errorDescription="Missing text",
        )
        assert flag.reporterName == "user1"
        assert flag.errorLocation == "page 3"
        assert flag.errorDescription == "Missing text"
