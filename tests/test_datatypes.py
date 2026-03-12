import datetime
import pytest
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

    @pytest.mark.parametrize(
        "idPrintMessage, id",
        [
            ("id should propogate from constructor", "s0000l11111"),
            ("id should propogate from setter", "s2222l33333"),
        ],
    )
    def test_id(self, idPrintMessage, id):
        doc = Document(
            None,
            id=id,
        )

        print(idPrintMessage)
        assert doc.metadata.id == id
        assert doc.id == id

    @pytest.mark.parametrize(
        "studioPrintMessage, studio",
        [
            ("studio should propogate from constructor", "MGM"),
            ("studio should propogate from setter", "Ghibli"),
        ],
    )
    def test_studio(self, studioPrintMessage, studio):
        doc = Document(
            None,
            studio=studio,
        )

        print(studioPrintMessage)
        assert doc.metadata.studio == studio
        assert doc.studio == studio

    @pytest.mark.parametrize(
        "titlePrintMessage, title",
        [
            ("title should propogate from constructor", "Arsenic and Old Lace"),
            ("title should propogate from setter", "Nosferatu"),
        ],
    )
    def test_title(self, titlePrintMessage, title):
        doc = Document(None, title=title)

        print(titlePrintMessage)
        assert doc.metadata.title == title
        assert doc.title == title

    @pytest.mark.parametrize(
        "copyrightYearPrintMessage, copyrightYear",
        [
            ("copyrightYear should propogate from constructor", 1901),
            ("copyrightYear should propogate from setter", 1898),
        ],
    )
    def test_copyrightYear(self, copyrightYearPrintMessage, copyrightYear):
        doc = Document(None, copyrightYear=copyrightYear)

        print(copyrightYearPrintMessage)
        assert doc.metadata.copyrightYear == copyrightYear
        assert doc.copyrightYear == copyrightYear

    @pytest.mark.parametrize(
        "reelCountPrintMessage, reelCount",
        [
            ("reelCount should propogate from constructor", 3),
            ("reelCount should propogate from setter", 1),
        ],
    )
    def test_reelCount(self, reelCountPrintMessage, reelCount):
        doc = Document(
            None,
            reelCount=reelCount,
        )

        print(reelCountPrintMessage)
        assert doc.metadata.reelCount == reelCount
        assert doc.reelCount == reelCount

    @pytest.mark.parametrize(
        "uploadedTimePrintMessage, uploadedTime",
        [
            (
                "uploadedTime should propogate from constructor",
                datetime.datetime.fromisoformat("2025-12-22T14:51:11"),
            ),
            (
                "uploadedTime should propogate from setter",
                datetime.datetime.fromisoformat("2025-12-22T14:51:11"),
            ),
        ],
    )
    def test_uploadedTime(self, uploadedTimePrintMessage, uploadedTime):
        doc = Document(
            None,
            uploadedTime=datetime.datetime.fromisoformat("2025-12-22T14:51:11"),
        )

        print(uploadedTimePrintMessage)
        assert doc.metadata.uploadedTime == uploadedTime
        assert doc.uploadedTime == uploadedTime

    @pytest.mark.parametrize(
        "uploadedByPrintMessage, uploadedBy",
        [
            ("uploadedBy should propogate from constructor", "John_Doe"),
            ("uploadedBy should propogate from setter", "The_Grinch"),
        ],
    )
    def test_uploadedBy(self, uploadedByPrintMessage, uploadedBy):
        doc = Document(
            None,
            uploadedBy=uploadedBy,
        )

        print(uploadedByPrintMessage)
        assert doc.metadata.uploadedBy == uploadedBy
        assert doc.uploadedBy == uploadedBy

    @pytest.mark.parametrize(
        "actorsPrintMessage, actors",
        [
            ("actors should propogate from constructor", ["Charlie Chaplin"]),
            ("actors should propogate from setter", ["Walter Goggins", "Brad Pitt"]),
        ],
    )
    def test_actors(self, actorsPrintMessage, actors):
        doc = Document(
            None,
            actors=actors,
        )

        print(actorsPrintMessage)
        assert doc.metadata.actors == actors
        assert doc.actors == actors

    @pytest.mark.parametrize(
        "tagsPrintMessage, tags",
        [
            ("tags should propogate from constructor", ["influential"]),
            ("tags should propogate from setter", ["serial"]),
        ],
    )
    def test_tags(self, tagsPrintMessage, tags):
        doc = Document(
            None,
            tags=tags,
        )

        print(tagsPrintMessage)
        assert doc.metadata.tags == tags
        assert doc.tags == tags

    @pytest.mark.parametrize(
        "genresPrintMessage, genres",
        [
            ("genres should propogate from constructor", ["drama"]),
            ("genres should propogate from setter", ["comedy", "commentary"]),
        ],
    )
    def test_genres(self, genresPrintMessage, genres):
        doc = Document(
            None,
            genres=genres,
        )

        print(genresPrintMessage)
        assert doc.metadata.genres == genres
        assert doc.genres == genres

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
