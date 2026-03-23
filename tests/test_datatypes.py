import datetime
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

    def test_id(self):
        # Arrange
        constructorId = "s0000l11111"
        expectedId = "s2222l33333"
        doc = Document(
            None,
            id=constructorId,
        )

        # Act
        doc.id = expectedId

        # Assert
        assert doc.metadata.id == expectedId
        assert doc.id == expectedId

    def test_studio(self):
        # Arrange
        constructorStudio = "MGM"
        expectedStudio = "Ghibli"
        doc = Document(
            None,
            studio=constructorStudio,
        )

        # Act
        doc.studio = expectedStudio

        # Assert
        assert doc.metadata.studio == expectedStudio
        assert doc.studio == expectedStudio

    def test_title(self):
        # Arrange
        constructorTitle = "Arsenic and Old Lace"
        expectedTitle = "Nosferatu"
        doc = Document(None, title=constructorTitle)

        # Act
        doc.title = expectedTitle

        # Assert
        assert doc.metadata.title == expectedTitle
        assert doc.title == expectedTitle

    def test_copyrightYear(self):
        # Arrange
        constructorYear = 1901
        expectedYear = 1898
        doc = Document(None, copyrightYear=constructorYear)

        # Act
        doc.copyrightYear = expectedYear

        # Assert
        assert doc.metadata.copyrightYear == expectedYear
        assert doc.copyrightYear == expectedYear

    def test_reelCount(self):
        # Arrange
        constructorReelCount = 3
        expectedReelCount = 1
        doc = Document(
            None,
            reelCount=constructorReelCount,
        )

        # Act
        doc.reelCount = expectedReelCount

        # Assert
        assert doc.metadata.reelCount == expectedReelCount
        assert doc.reelCount == expectedReelCount

    def test_uploadedTime(self):
        # Arrange
        constructorUploadedTime = datetime.datetime.fromisoformat("2025-12-22T14:51:11")
        expectedUploadedTime = datetime.datetime.fromisoformat("2025-12-22T14:51:11")
        doc = Document(
            None,
            uploadedTime=constructorUploadedTime,
        )

        # Act
        doc.uploadedTime = expectedUploadedTime

        # Assert
        assert doc.metadata.uploadedTime == expectedUploadedTime
        assert doc.uploadedTime == expectedUploadedTime

    def test_uploadedBy(self):
        # Arrange
        constructorUploadedBy = "John_Doe"
        expectedUploadedBy = "The_Grinch"
        doc = Document(
            None,
            uploadedBy=constructorUploadedBy,
        )

        # Act
        doc.uploadedBy = expectedUploadedBy

        # Assert
        assert doc.metadata.uploadedBy == expectedUploadedBy
        assert doc.uploadedBy == expectedUploadedBy

    def test_actors(self):
        # Arrange
        constructorActors = ["Charlie Chaplin"]
        expectedActors = ["Walter Goggins", "Brad Pitt"]
        doc = Document(
            None,
            actors=constructorActors,
        )

        # Act
        doc.actors = expectedActors

        # Assert
        assert doc.metadata.actors == expectedActors
        assert doc.actors == expectedActors

    def test_tags(self):
        # Arrange
        constructorTags = ["influential"]
        expectedTags = ["serial"]
        doc = Document(
            None,
            tags=constructorTags,
        )

        # Act
        doc.tags = expectedTags

        # Assert
        assert doc.metadata.tags == expectedTags
        assert doc.tags == expectedTags

    def test_genres(self):
        # Arrange
        constructorGenres = ["drama"]
        expectedGenres = ["comedy", "commentary"]
        doc = Document(
            None,
            genres=constructorGenres,
        )

        # Act
        doc.genres = expectedGenres

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
