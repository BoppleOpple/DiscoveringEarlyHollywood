"""A collection of classes and types for storing document, query, and user data"""

import datetime
from typing import Any, Self, Union

# removing this for now, i think this should be handled by the db anyway
# class User:
#     name: str = None


class Flag:
    reporterName: str = None
    errorLoaction: str = None
    errorDescription: str = None


class Metadata:
    id: str = None
    studio: str = None
    title: str = None

    copyrightYear: int = None
    reelCount: int = None

    uploadedTime: datetime.datetime = None

    uploadedBy: str = None


class Document:
    """
    Class containing in-memory document data

    Attributes
    ----------
    iamges: list[Any]
        Not yet implemented

    transcripts: list[str]
        A list of the text of each page, in order

    flags: Union[list[Flag], None]
        A list of all flags on this document, or `None` if they have not yet been fetched

    metadata: Metadata
        A `Metadata` object containing all additional data associated with this document

    Methods
    -------
    getId()
        A helper for getting the `id` of this document
    """

    iamges: list[Any] = None
    transcripts: list[str] = []
    flags: Union[list[Flag], None] = None

    metadata: Metadata = Metadata()

    def getId(self) -> str:
        """
        A helper for getting the `id` of this document

        Returns
        -------
        id: Union[str, None]
            The `id` of the document if available, otherwise None
        """
        return self.metadata.id if self.metadata else None


class Query:
    """
    Class containing all data required to make a query

    Parameters
    ----------
    actors: list[str], default = []
        The list of actors that must be present in matched documents

    tags: list[str], default = []
        The list of tags that must be present in matched documents

    genres: list[str], default = []
        The list of genres that must be present in matched documents

    keywords: list[str], default = []
        The list of keywords that must be present in matched documents

    documentType: str, default = None
        The type that matched documents must be (`None` for no filter)

    studio: str, default = None
        The studio that matched documents must be from (`None` for no filter)

    copyrightYearRange: tuple[int, int], default = (None, None)
        The range of acceptable copyright years

    durationRange: tuple[int, int], default = (None, None)
        The range of acceptable durations (in reels)

    Attributes
    ----------
    viewedDocuments: list[str]
        The `id`s of all documents that have been viewed in this query

    actors: list[str]
        The list of actors that must be present in matched documents

    tags: list[str]
        The list of tags that must be present in matched documents

    genres: list[str]
        The list of genres that must be present in matched documents

    keywords: list[str]
        The list of keywords that must be present in matched documents

    documentType: str
        The type that matched documents must be (`None` for no filter)

    studio: str
        The studio that matched documents must be from (`None` for no filter)

    copyrightYearRange: tuple[int, int]
        The range of acceptable copyright years

    durationRange: tuple[int, int]
        The range of acceptable durations (in reels)

    queryTime: datetime.datetime
        The time the query was created (used to filter the database and keep
        queries consistent as documents are added)

    Methods
    -------
    setCopyrightRange(start: int, end: int)
        Sets the year range of the query

    setDurationRange(start: int, end: int)
        Sets the duration range of the query

    setActors(actors: list[str])
        Sets the actors that must be present in the query

    addActor(actor: str)
        Adds an actor that must be present to the query

    setTags(tags: list[str])
        Sets the tags that must be present in the query

    addTag(tag: str)
        Adds an tag that must be present to the query

    setGenres(genres: list[str])
        Sets the genres that must be present in the query

    addGenre(genre: str)
        Adds an genre that must be present to the query

    setKeywords(keywords: list[str])
        Sets the keywords that must be present in the query

    addKeyword(keyword: str)
        Adds an keyword that must be present to the query

    setDocumentType(documentType: str)
        Sets the document type of the query

    setStudio(studio: str)
        Sets the studio that the copyrighted film must be from
    """

    viewedDocuments: list[str] = []
    actors: list[str] = []
    tags: list[str] = []
    genres: list[str] = []
    keywords: list[str] = []

    documentType: str = None
    studio: str = None

    copyrightYearRange: tuple[int, int] = (None, None)
    durationRange: tuple[int, int] = (None, None)

    queryTime: datetime.datetime = None

    def __init__(
        self,
        actors: list[str] = [],
        tags: list[str] = [],
        genres: list[str] = [],
        keywords: list[str] = [],
        documentType: str = None,
        studio: str = None,
        copyrightYearRange: tuple[int, int] = (None, None),
        durationRange: tuple[int, int] = (None, None),
    ):
        self.setActors(actors)
        self.setTags(tags)
        self.setGenres(genres)
        self.setKeywords(keywords)
        self.setDocumentType(documentType)
        self.setStudio(studio)
        self.setCopyrightYearRange(copyrightYearRange)
        self.setDurationRange(durationRange)

        self.viewedDocuments = []
        self.queryTime = datetime.datetime.now()

    def setCopyrightRange(self, start: int, end: int) -> Self:
        """Sets the year range of the query"""
        self.copyrightYearRange = (start, end)
        return self

    def setDurationRange(self, start: int, end: int) -> Self:
        """Sets the duration range of the query"""
        self.durationRange = (start, end)
        return self

    def setActors(self, actors: list[str]) -> Self:
        """Sets the actors that must be present in the query"""
        self.actors = actors if actors else []
        return self

    def addActor(self, actor: str) -> Self:
        """Adds an actor that must be present to the query"""
        self.actors.append(actor)
        return self

    def setTags(self, tags: list[str]) -> Self:
        """Sets the tags that must be present in the query"""
        self.tags = tags if tags else []
        return self

    def addTag(self, tag: str) -> Self:
        """Adds an tag that must be present to the query"""
        self.tags.append(tag)
        return self

    def setGenres(self, genres: list[str]) -> Self:
        """Sets the genres that must be present in the query"""
        self.genres = genres if genres else []
        return self

    def addGenre(self, genre: str) -> Self:
        """Adds an genre that must be present to the query"""
        self.genres.append(genre)
        return self

    def setKeywords(self, keywords: list[str]) -> Self:
        """Sets the keywords that must be present in the query"""
        self.keywords = keywords if keywords else []
        return self

    def addKeyword(self, keyword: str) -> Self:
        """Adds an keyword that must be present to the query"""
        self.keywords.append(keyword)
        return self

    def setDocumentType(self, documentType: str) -> Self:
        """Sets the document type of the query"""
        self.documentType = documentType
        return self

    def setStudio(self, studio: str) -> Self:
        """Sets the studio that the copyrighted film must be from"""
        self.studio = studio
        return self
