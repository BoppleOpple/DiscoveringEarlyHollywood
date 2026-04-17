import datetime
from backend.datatypes import Document, Flag, Query


class TestQuery:
    def test_set_keywords(self):
        # Arrange
        expectedQuery = Query(keywords=["comedy", "drama"])
        resultQuery = Query()

        # Act
        resultQuery.set_keywords(["comedy", "drama"])

        # Assert
        assert resultQuery.keywords == expectedQuery.keywords

    def test_add_keyword(self):
        # Arrange
        expectedQuery = Query(keywords=["drama"])
        resultQuery = Query()

        # Act
        resultQuery.add_keyword("drama")

        # Assert
        assert resultQuery.keywords == expectedQuery.keywords

    def test_set_copyright_year_range(self):
        # Arrange
        expectedQuery = Query(copyright_year_range=(1915, 1925))
        resultQuery = Query()

        # Act
        resultQuery.set_copyright_year_range(1915, 1925)

        # Assert
        assert resultQuery.copyright_year_range == expectedQuery.copyright_year_range

    def test_set_duration_range(self):
        # Arrange
        expectedQuery = Query(duration_range=(5, 10))
        resultQuery = Query()

        # Act
        resultQuery.set_duration_range(5, 10)

        # Assert
        assert resultQuery.duration_range == expectedQuery.duration_range

    def test_set_actors(self):
        # Arrange
        expectedQuery = Query(actors=["Charlie Chaplin", "Buster Keaton"])
        resultQuery = Query()

        # Act
        resultQuery.set_actors(["Charlie Chaplin", "Buster Keaton"])

        # Assert
        assert resultQuery.actors == expectedQuery.actors

    def test_add_actor(self):
        # Arrange
        expectedQuery = Query(actors=["Walter Goggins"])
        resultQuery = Query()

        # Act
        resultQuery.add_actor("Walter Goggins")

        # Assert
        assert resultQuery.actors == expectedQuery.actors

    def test_set_genres(self):
        # Arrange
        expectedQuery = Query(genres=["comedy", "drama"])
        resultQuery = Query()

        # Act
        resultQuery.set_genres(["comedy", "drama"])

        # Assert
        assert resultQuery.genres == expectedQuery.genres

    def test_add_genre(self):
        # Arrange
        expectedQuery = Query(genres=["Thriller"])
        resultQuery = Query()

        # Act
        resultQuery.add_genre("Thriller")

        # Assert
        assert resultQuery.genres == expectedQuery.genres

    def test_set_document_type(self):
        # Arrange
        expectedQuery = Query(document_type="TestType")
        resultQuery = Query()

        # Act
        resultQuery.set_document_type("TestType")

        # Assert
        assert resultQuery.document_type == expectedQuery.document_type

    def test_set_studio(self):
        # Arrange
        expectedQuery = Query(studio="Universal")
        resultQuery = Query()

        # Act
        resultQuery.set_studio("Universal")

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
        doc = Document(title=constructorTitle)

        # Act
        doc.title = expectedTitle

        # Assert
        assert doc.metadata.title == expectedTitle
        assert doc.title == expectedTitle

    def test_document_type(self):
        # Arrange
        constructorDocumentType = "script"
        expectedDocumentType = "synopsis"
        doc = Document(document_type=constructorDocumentType)

        # Act
        doc.document_type = expectedDocumentType

        # Assert
        assert doc.metadata.document_type == expectedDocumentType
        assert doc.document_type == expectedDocumentType

    def test_copyright_year(self):
        # Arrange
        constructorYear = 1901
        expectedYear = 1898
        doc = Document(copyright_year=constructorYear)

        # Act
        doc.copyright_year = expectedYear

        # Assert
        assert doc.metadata.copyright_year == expectedYear
        assert doc.copyright_year == expectedYear

    def test_reel_count(self):
        # Arrange
        constructorReelCount = 3
        expectedReelCount = 1
        doc = Document(
            reel_count=constructorReelCount,
        )

        # Act
        doc.reel_count = expectedReelCount

        # Assert
        assert doc.metadata.reel_count == expectedReelCount
        assert doc.reel_count == expectedReelCount

    def test_uploaded_time(self):
        # Arrange
        constructorUploadedTime = datetime.datetime.fromisoformat("2025-12-22T14:51:11")
        expectedUploadedTime = datetime.datetime.fromisoformat("2025-12-22T14:51:11")
        doc = Document(
            uploaded_time=constructorUploadedTime,
        )

        # Act
        doc.uploaded_time = expectedUploadedTime

        # Assert
        assert doc.metadata.uploaded_time == expectedUploadedTime
        assert doc.uploaded_time == expectedUploadedTime

    def test_uploaded_by(self):
        # Arrange
        constructorUploadedBy = "John_Doe"
        expectedUploadedBy = "The_Grinch"
        doc = Document(
            uploaded_by=constructorUploadedBy,
        )

        # Act
        doc.uploaded_by = expectedUploadedBy

        # Assert
        assert doc.metadata.uploaded_by == expectedUploadedBy
        assert doc.uploaded_by == expectedUploadedBy

    def test_actors(self):
        # Arrange
        constructorActors = ["Charlie Chaplin"]
        expectedActors = ["Walter Goggins", "Brad Pitt"]
        doc = Document(
            actors=constructorActors,
        )

        # Act
        doc.actors = expectedActors

        # Assert
        assert doc.metadata.actors == expectedActors
        assert doc.actors == expectedActors

    def test_locations(self):
        # Arrange
        constructorLocations = [
            {"name": "courtyard", "description": "where the film begins"}
        ]
        expectedLocations = [{"name": "crypt", "description": "where the film ends"}]
        doc = Document(
            locations=constructorLocations,
        )

        # Act
        doc.locations = expectedLocations

        # Assert
        assert doc.metadata.locations == expectedLocations
        assert doc.locations == expectedLocations

    def test_genres(self):
        # Arrange
        constructorGenres = ["drama"]
        expectedGenres = ["comedy", "commentary"]
        doc = Document(
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
            transcripts=inputContent,
        )

        print(
            "content should concatenate the text of the transcript, separated by newlines"
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
