import datetime
from typing import Any, Self, Union

# removing this for now, i think this should be handled by the db anyway
# class User:
#     name: str = None


class Flag:
    reporterName: str = None


class Metadata:
    id: str = None
    studio: str = None
    title: str = None

    copyrightYear: int = None
    reelCount: int = None

    uploadedTime: datetime.datetime = None

    uploadedBy: str = None


class Document:
    iamges: Any = None
    transcripts: list[str] = []
    flags: Union[list[Flag], None] = None

    metadata: Metadata = None

    def getId(self) -> str:
        return self.metadata.id if self.metadata else None


class Query:
    viewedDocuments: list[str] = []
    actors: list[str] = []
    tags: list[str] = []
    genres: list[str] = []
    keywords: list[str] = []

    documentType: str = None
    studio: str = None

    copyrightYearRange: tuple[int, int] = (None, None)
    durationRange: tuple[int, int] = (None, None)

    def setCopyrightRange(self, start: int, end: int) -> Self:
        self.copyrightYearRange = (start, end)
        return self

    def setDurationRange(self, start: int, end: int) -> Self:
        self.durationRange = (start, end)
        return self

    def setActors(self, actors: list[str]) -> Self:
        self.actors = actors if actors else []
        return self

    def addActor(self, actor: str) -> Self:
        self.actors.append(actor)
        return self

    def setTags(self, tags: list[str]) -> Self:
        self.tags = tags if tags else []
        return self

    def addTag(self, tag: str) -> Self:
        self.tags.append(tag)
        return self

    def setGenres(self, genres: list[str]) -> Self:
        self.genres = genres if genres else []
        return self

    def addGenre(self, genre: str) -> Self:
        self.genres.append(genre)
        return self

    def setKeywords(self, keywords: list[str]) -> Self:
        self.keywords = keywords if keywords else []
        return self

    def addKeyword(self, keyword: str) -> Self:
        self.keywords.append(keyword)
        return self

    def setDocumentType(self, documentType: str) -> Self:
        self.documentType = documentType
        return self

    def setStudio(self, studio: str) -> Self:
        self.studio = studio
        return self
