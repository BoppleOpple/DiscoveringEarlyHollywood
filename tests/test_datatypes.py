import datetime
import pytest
from backend.datatypes import Document, Flag, Query


class TestQuery:
    def test_set_keywords(self):
        # Arrange
        expectedQuery = Query(keywords=["comedy", "drama"])
        resultQuery = Query()

        # Act
        resultQuery.setKeywords(["comedy", "drama"])

        # Assert
        assert resultQuery.keywords == expectedQuery.keywords

    def test_add_keyword(self):
        # Arrange
        expectedQuery = Query(keywords=["drama"])
        resultQuery = Query()

        # Act
        resultQuery.addKeyword("drama")

        # Assert
        assert resultQuery.keywords == expectedQuery.keywords

    def test_set_copyright_year_range(self):
        # Arrange
        expectedQuery = Query(copyrightYearRange=(1915, 1925))
        resultQuery = Query()

        # Act
        resultQuery.setCopyrightYearRange(1915, 1925)

        # Assert
        assert resultQuery.copyrightYearRange == expectedQuery.copyrightYearRange

    def test_set_duration_range(self):
        # Arrange
        expectedQuery = Query(durationRange=(5, 10))
        resultQuery = Query()

        # Act
        resultQuery.setDurationRange(5, 10)

        # Assert
        assert resultQuery.durationRange == expectedQuery.durationRange

    def test_set_actors(self):
        # Arrange
        expectedQuery = Query(actors=["Charlie Chaplin", "Buster Keaton"])
        resultQuery = Query()

        # Act
        resultQuery.setActors(["Charlie Chaplin", "Buster Keaton"])

        # Assert
        assert resultQuery.actors == expectedQuery.actors

    def test_add_actor(self):
        # Arrange
        expectedQuery = Query(actors=["Walter Goggins"])
        resultQuery = Query()

        # Act
        resultQuery.addActor("Walter Goggins")

        # Assert
        assert resultQuery.actors == expectedQuery.actors

    def test_set_tags(self):
        # Arrange
        expectedQuery = Query(tags=["New", "Old"])
        resultQuery = Query()

        # Act
        resultQuery.setTags(["New", "Old"])

        # Assert
        assert resultQuery.tags == expectedQuery.tags

    def test_add_tags(self):
        # Arrange
        expectedQuery = Query(tags=["Old"])
        resultQuery = Query()

        # Act
        resultQuery.addTag("Old")

        # Assert
        assert resultQuery.tags == expectedQuery.tags

    def test_set_genres(self):
        # Arrange
        expectedQuery = Query(genres=["comedy", "drama"])
        resultQuery = Query()

        # Act
        resultQuery.setGenres(["comedy", "drama"])

        # Assert
        assert resultQuery.genres == expectedQuery.genres

    def test_add_genre(self):
        # Arrange
        expectedQuery = Query(genres=["Thriller"])
        resultQuery = Query()

        # Act
        resultQuery.addGenre("Thriller")

        # Assert
        assert resultQuery.genres == expectedQuery.genres

    def test_set_document_type(self):
        # Arrange
        expectedQuery = Query(documentType="TestType")
        resultQuery = Query()

        # Act
        resultQuery.setDocumentType("TestType")

        # Assert
        assert resultQuery.documentType == expectedQuery.documentType

    def test_set_studio(self):
        # Arrange
        expectedQuery = Query(studio="Universal")
        resultQuery = Query()

        # Act
        resultQuery.setStudio("Universal")

        # Assert
        assert resultQuery.studio == expectedQuery.studio

    def test_constructor_with_keywords(self):
        # Arrange
        expectedQuery = Query(keywords=["silent", "film"])

        # Act
        resultQuery = Query(keywords=["silent", "film"])

        # Assert
        assert resultQuery.keywords == expectedQuery.keywords


class TestDocument:

    @pytest.mark.parametrize(
        "idPrintMessage, id",
        [
            ("id should propogate from constructor", "s0000l11111"),
            ("id should propogate from setter", "s2222l33333"),
        ],
    )
    def test_id(self, idPrintMessage, id):
        # Arrange
        expectedId = id

        # Act
        doc = Document(
            None,
            id=id,
        )

        print(idPrintMessage)

        # Assert
        assert doc.metadata.id == expectedId
        assert doc.id == expectedId

    @pytest.mark.parametrize(
        "studioPrintMessage, studio",
        [
            ("studio should propogate from constructor", "MGM"),
            ("studio should propogate from setter", "Ghibli"),
        ],
    )
    def test_studio(self, studioPrintMessage, studio):
        # Arrange
        expectedStudio = studio

        # Act
        doc = Document(
            None,
            studio=studio,
        )

        print(studioPrintMessage)

        # Assert
        assert doc.metadata.studio == expectedStudio
        assert doc.studio == expectedStudio

    @pytest.mark.parametrize(
        "titlePrintMessage, title",
        [
            ("title should propogate from constructor", "Arsenic and Old Lace"),
            ("title should propogate from setter", "Nosferatu"),
        ],
    )
    def test_title(self, titlePrintMessage, title):
        # Arrange
        expectedTitle = title

        # Act
        doc = Document(None, title=title)

        print(titlePrintMessage)

        # Assert
        assert doc.metadata.title == expectedTitle
        assert doc.title == expectedTitle

    @pytest.mark.parametrize(
        "copyrightYearPrintMessage, copyrightYear",
        [
            ("copyrightYear should propogate from constructor", 1901),
            ("copyrightYear should propogate from setter", 1898),
        ],
    )
    def test_copyrightYear(self, copyrightYearPrintMessage, copyrightYear):
        # Arrange
        expectedYear = copyrightYear

        # Act
        doc = Document(None, copyrightYear=copyrightYear)

        print(copyrightYearPrintMessage)

        # Assert
        assert doc.metadata.copyrightYear == expectedYear
        assert doc.copyrightYear == expectedYear

    @pytest.mark.parametrize(
        "reelCountPrintMessage, reelCount",
        [
            ("reelCount should propogate from constructor", 3),
            ("reelCount should propogate from setter", 1),
        ],
    )
    def test_reelCount(self, reelCountPrintMessage, reelCount):
        # Arrange
        expectedReelCount = reelCount

        # Act
        doc = Document(
            None,
            reelCount=reelCount,
        )

        print(reelCountPrintMessage)

        # Assert
        assert doc.metadata.reelCount == expectedReelCount
        assert doc.reelCount == expectedReelCount

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
        # Arrange
        expectedUploadedTime = uploadedTime

        # Act
        doc = Document(
            None,
            uploadedTime=uploadedTime,
        )

        print(uploadedTimePrintMessage)

        # Assert
        assert doc.metadata.uploadedTime == expectedUploadedTime
        assert doc.uploadedTime == expectedUploadedTime

    @pytest.mark.parametrize(
        "uploadedByPrintMessage, uploadedBy",
        [
            ("uploadedBy should propogate from constructor", "John_Doe"),
            ("uploadedBy should propogate from setter", "The_Grinch"),
        ],
    )
    def test_uploadedBy(self, uploadedByPrintMessage, uploadedBy):
        # Arrange
        expectedUploadedBy = uploadedBy

        # Act
        doc = Document(
            None,
            uploadedBy=uploadedBy,
        )

        print(uploadedByPrintMessage)

        # Assert
        assert doc.metadata.uploadedBy == expectedUploadedBy
        assert doc.uploadedBy == expectedUploadedBy

    @pytest.mark.parametrize(
        "actorsPrintMessage, actors",
        [
            ("actors should propogate from constructor", ["Charlie Chaplin"]),
            ("actors should propogate from setter", ["Walter Goggins", "Brad Pitt"]),
        ],
    )
    def test_actors(self, actorsPrintMessage, actors):
        # Arrange
        expectedActors = actors

        # Act
        doc = Document(
            None,
            actors=actors,
        )

        print(actorsPrintMessage)

        # Assert
        assert doc.metadata.actors == expectedActors
        assert doc.actors == expectedActors

    @pytest.mark.parametrize(
        "tagsPrintMessage, tags",
        [
            ("tags should propogate from constructor", ["influential"]),
            ("tags should propogate from setter", ["serial"]),
        ],
    )
    def test_tags(self, tagsPrintMessage, tags):
        # Arrange
        expectedTags = tags

        # Act
        doc = Document(
            None,
            tags=tags,
        )

        print(tagsPrintMessage)

        # Assert
        assert doc.metadata.tags == expectedTags
        assert doc.tags == expectedTags

    @pytest.mark.parametrize(
        "genresPrintMessage, genres",
        [
            ("genres should propogate from constructor", ["drama"]),
            ("genres should propogate from setter", ["comedy", "commentary"]),
        ],
    )
    def test_genres(self, genresPrintMessage, genres):
        # Arrange
        expectedGenres = genres

        # Act
        doc = Document(
            None,
            genres=genres,
        )

        print(genresPrintMessage)

        # Assert
        assert doc.metadata.genres == expectedGenres
        assert doc.genres == expectedGenres

    def test_content(self):
        # Arrange
        expectedContent = "page 1\npage 2"
        inputContent = [(0, "page 1"), (1, "page 2")]

        # Act
        doc = Document(
            None,
            transcripts=inputContent,
        )

        print(
            "content should concatenate the text of the transcript, seperated by newlines"
        )

        # Assert
        assert doc.content == expectedContent


class TestFlag:
    def test_flag_creation(self):
        # Arrange
        expectedReporterName = "user1"
        expectedErrorLocation = "page 3"
        expectedErrorDescription = "Missing text"

        inputReporterName = "user1"
        inputErrorLocation = "page 3"
        inputErrorDescription = "Missing text"

        # Act
        flag = Flag(
            reporterName=inputReporterName,
            errorLocation=inputErrorLocation,
            errorDescription=inputErrorDescription,
        )

        # Assert
        assert flag.reporterName == expectedReporterName
        assert flag.errorLocation == expectedErrorLocation
        assert flag.errorDescription == expectedErrorDescription
