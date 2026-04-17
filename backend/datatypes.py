"""A collection of classes and types for storing document, query, and user data"""

import datetime
from typing import Any, Self, Union


class Flag:
    """Struct for flags"""

    reporterName: str = None
    errorLocation: str = None
    errorDescription: str = None

    def __init__(
        self,
        reporterName: str = None,
        errorLocation: str = None,
        errorDescription: str = None,
    ):
        self.reporterName = reporterName
        self.errorLocation = errorLocation
        self.errorDescription = errorDescription


class Metadata:
    """
    Class containing in-memory document metadata

    Parameters
    ----------
    id: str, default = None
        The id of the related document

    studio: str, default = None
        The studio of the related document

    title: str, default = None
        The title of the related document

    document_type: str, default = None
        The type of the document (i.e. "script", "synopsis", etc.)

    copyright_year: int, default = None
        The copyright year of the related document

    reel_count: int, default = None
        The number of reels for the related document

    uploaded_time: datetime.datetime, default = None
        The time the related document was uploaded to the database

    uploaded_by: str, default = None
        The uploader of the related document

    actors: list[str], default = []
        The list of actors associated with this document

    locations: list[str], default = []
        The list of locations (settings) associated with this document

    genres: list[str], default = []
        The list of genres associated with this document

    Attributes
    ----------
    id: str
        The id of the related document

    studio: str
        The studio of the related document

    title: str
        The title of the related document

    document_type: str, default = None
        The type of the document (i.e. "script", "synopsis", etc.)

    copyright_year: int
        The copyright year of the related document

    reel_count: int
        The number of reels for the related document

    uploaded_time: datetime.datetime
        The time the related document was uploaded to the database

    uploaded_by: str
        The uploader of the related document

    actors: list[str], default = []
        The list of actors associated with this document

    locations: list[str], default = []
        The list of locations (settings) associated with this document

    genres: list[str], default = []
        The list of genres associated with this document
    """

    id: str = None
    studio: str = None
    title: str = None
    document_type: str = None

    copyright_year: int = None
    reel_count: int = None

    uploaded_time: datetime.datetime = None

    uploaded_by: str = None

    actors: list[str] = []
    locations: list[str] = []
    genres: list[str] = []

    def __init__(
        self,
        id: str = None,
        studio: str = None,
        title: str = None,
        document_type: str = None,
        copyright_year: int = None,
        reel_count: int = None,
        uploaded_time: datetime.datetime = None,
        uploaded_by: str = None,
        actors: list[str] = [],
        locations: list[str] = [],
        genres: list[str] = [],
    ):
        self.id = id
        self.studio = studio
        self.title = title
        self.document_type = document_type
        self.copyright_year = copyright_year
        self.reel_count = reel_count
        self.uploaded_time = uploaded_time
        self.uploaded_by = uploaded_by
        self.actors = actors
        self.locations = locations
        self.genres = genres


class Document:
    """
    Class containing in-memory document data

    Parameters
    ----------
    id: str, default = None
        The id of the related document

    studio: str, default = None
        The studio of the related document

    title: str, default = None
        The title of the related document

    copyright_year: int, default = None
        The copyright year of the related document

    reel_count: int, default = None
        The number of reels for the related document

    uploaded_time: datetime.datetime, default = None
        The time the related document was uploaded to the database

    uploaded_by: str, default = None
        The uploader of the related document

    actors: list[str], default = []
        The list of actors associated with this document

    locations: list[str], default = []
        The list of locations (settings) associated with this document

    genres: list[str], default = []
        The list of genres associated with this document

    transcripts: list[tuple[int, str]], default = []
        A list of the text of each page, in order

    flags: Union[list[Flag], None], default = None
        A list of all flags on this document, or `None` if they have not yet been fetched

    Attributes
    ----------
    images: list[Any]
        Not yet implemented

    transcripts: list[tuple[int, str]]
        A list of the text of each page, in order

    flags: Union[list[Flag], None]
        A list of all flags on this document, or `None` if they have not yet been fetched

    metadata: Metadata
        A `Metadata` object containing all additional data associated with this document
    """

    images: list[Any] = None
    transcripts: list[tuple[int, str]] = []
    flags: Union[list[Flag], None] = None

    metadata: Metadata = Metadata()

    def __init__(
        self,
        id: str = None,
        studio: str = None,
        title: str = None,
        document_type: str = None,
        copyright_year: int = None,
        reel_count: int = None,
        uploaded_time: datetime.datetime = None,
        uploaded_by: str = None,
        actors: list[str] = [],
        locations: list[str] = [],
        genres: list[str] = [],
        transcripts: list[tuple[int, str]] = [],
        flags: list[Flag] = [],
    ):
        self.metadata = Metadata(
            id,
            studio,
            title,
            document_type,
            copyright_year,
            reel_count,
            uploaded_time,
            uploaded_by,
            actors,
            locations,
            genres,
        )
        # TODO load images automatically
        self.images = None

        self.transcripts = transcripts if transcripts else []
        self.flags = flags if flags else []

    @property
    def id(self) -> str:
        return self.metadata.id if self.metadata else None

    @id.setter
    def id(self, value: str):
        self.metadata.id = value

    @property
    def studio(self) -> str:
        return self.metadata.studio if self.metadata else None

    @studio.setter
    def studio(self, value: str):
        self.metadata.studio = value

    @property
    def title(self) -> str:
        return self.metadata.title if self.metadata else None

    @title.setter
    def title(self, value: str):
        self.metadata.title = value

    @property
    def document_type(self) -> str:
        return self.metadata.document_type if self.metadata else None

    @document_type.setter
    def document_type(self, value: str):
        self.metadata.document_type = value

    @property
    def copyright_year(self) -> str:
        return self.metadata.copyright_year if self.metadata else None

    @copyright_year.setter
    def copyright_year(self, value: str):
        self.metadata.copyright_year = value

    @property
    def reel_count(self) -> str:
        return self.metadata.reel_count if self.metadata else None

    @reel_count.setter
    def reel_count(self, value: str):
        self.metadata.reel_count = value

    @property
    def uploaded_time(self) -> str:
        return self.metadata.uploaded_time if self.metadata else None

    @uploaded_time.setter
    def uploaded_time(self, value: str):
        self.metadata.uploaded_time = value

    @property
    def uploaded_by(self) -> str:
        return self.metadata.uploaded_by if self.metadata else None

    @uploaded_by.setter
    def uploaded_by(self, value: str):
        self.metadata.uploaded_by = value

    @property
    def actors(self) -> list[str]:
        return self.metadata.actors if self.metadata else None

    @actors.setter
    def actors(self, value: list[str]):
        self.metadata.actors = value

    @property
    def locations(self) -> list[str]:
        return self.metadata.locations if self.metadata else None

    @locations.setter
    def locations(self, value: list[str]):
        self.metadata.locations = value

    @property
    def genres(self) -> list[str]:
        return self.metadata.genres if self.metadata else None

    @genres.setter
    def genres(self, value: list[str]):
        self.metadata.genres = value

    @property
    def content(self):
        return "\n".join(tup[1] for tup in self.transcripts)


class Query:
    """
    Class containing all data required to make a query

    Parameters
    ----------
    actors: list[str], default = []
        The list of actors that must be present in matched documents

    genres: list[str], default = []
        The list of genres that must be present in matched documents

    keywords: list[str], default = []
        The list of keywords that must be present in matched documents

    document_type: str, default = None
        The type that matched documents must be (`None` for no filter)

    studio: str, default = None
        The studio that matched documents must be from (`None` for no filter)

    copyright_year_range: tuple[int, int], default = (None, None)
        The range of acceptable copyright years

    duration_range: tuple[int, int], default = (None, None)
        The range of acceptable durations (in reels)

    Attributes
    ----------
    viewed_documents: list[str]
        The `id`s of all documents that have been viewed in this query

    actors: list[str]
        The list of actors that must be present in matched documents

    genres: list[str]
        The list of genres that must be present in matched documents

    keywords: list[str]
        The list of keywords that must be present in matched documents

    document_type: str
        The type that matched documents must be (`None` for no filter)

    studio: str
        The studio that matched documents must be from (`None` for no filter)

    copyright_year_range: tuple[int, int]
        The range of acceptable copyright years

    duration_range: tuple[int, int]
        The range of acceptable durations (in reels)

    query_time: datetime.datetime
        The time the query was created (used to filter the database and keep
        queries consistent as documents are added)

    Methods
    -------
    set_copyright_year_range(start: int, end: int)
        Sets the year range of the query

    set_duration_range(start: int, end: int)
        Sets the duration range of the query

    set_actors(actors: list[str])
        Sets the actors that must be present in the query

    add_actor(actor: str)
        Adds an actor that must be present to the query

    set_genres(genres: list[str])
        Sets the genres that must be present in the query

    add_genre(genre: str)
        Adds an genre that must be present to the query

    set_keywords(keywords: list[str])
        Sets the keywords that must be present in the query

    add_keyword(keyword: str)
        Adds an keyword that must be present to the query

    set_document_type(document_type: str)
        Sets the document type of the query

    set_studio(studio: str)
        Sets the studio that the copyrighted film must be from
    """

    viewed_documents: list[str] = []
    actors: list[str] = []
    genres: list[str] = []
    keywords: list[str] = []

    document_type: str = None
    studio: str = None

    copyright_year_range: tuple[int, int] = (None, None)
    duration_range: tuple[int, int] = (None, None)

    query_time: datetime.datetime = None

    def __init__(
        self,
        actors: list[str] = [],
        genres: list[str] = [],
        keywords: list[str] = [],
        document_type: str = None,
        studio: str = None,
        copyright_year_range: tuple[int, int] = (None, None),
        duration_range: tuple[int, int] = (None, None),
    ):
        self.set_actors(actors)
        self.set_genres(genres)
        self.set_keywords(keywords)
        self.set_document_type(document_type)
        self.set_studio(studio)
        self.set_copyright_year_range(copyright_year_range[0], copyright_year_range[1])
        self.set_duration_range(duration_range[0], duration_range[1])

        self.viewed_documents = []
        self.query_time = datetime.datetime.now()

    def set_copyright_year_range(self, start: int, end: int) -> Self:
        """Sets the year range of the query"""
        self.copyright_year_range = (start, end)
        return self

    def set_duration_range(self, start: int, end: int) -> Self:
        """Sets the duration range of the query"""
        self.duration_range = (start, end)
        return self

    def set_actors(self, actors: list[str]) -> Self:
        """Sets the actors that must be present in the query"""
        self.actors = actors if actors else []
        return self

    def add_actor(self, actor: str) -> Self:
        """Adds an actor that must be present to the query"""
        self.actors.append(actor)
        return self

    def set_genres(self, genres: list[str]) -> Self:
        """Sets the genres that must be present in the query"""
        self.genres = genres if genres else []
        return self

    def add_genre(self, genre: str) -> Self:
        """Adds an genre that must be present to the query"""
        self.genres.append(genre)
        return self

    def set_keywords(self, keywords: list[str]) -> Self:
        """Sets the keywords that must be present in the query"""
        self.keywords = keywords if keywords else []
        return self

    def add_keyword(self, keyword: str) -> Self:
        """Adds an keyword that must be present to the query"""
        self.keywords.append(keyword)
        return self

    def set_document_type(self, document_type: str) -> Self:
        """Sets the document type of the query"""
        self.document_type = document_type
        return self

    def set_studio(self, studio: str) -> Self:
        """Sets the studio that the copyrighted film must be from"""
        self.studio = studio
        return self
