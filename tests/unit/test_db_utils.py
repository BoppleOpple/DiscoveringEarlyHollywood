# relation_from_id_to_all_values SQL generation

import psycopg2.sql as sql

from backend.db_utils import relation_from_id_to_all_values, execute_document_query
from backend.datatypes import Query
from unittest.mock import MagicMock


class TestRelationFromIdToAllValues:
    def test_returns_sql_object(self):
        # Arrange
        inputIdColumn = "document_id"
        inputValueColumn = "genre"
        inputRelation = "has_genre"
        inputValues = ["comedy", "drama"]

        # Act
        result = relation_from_id_to_all_values(
            inputIdColumn, inputValueColumn, inputRelation, inputValues
        )

        # Assert
        assert result is not None
        assert isinstance(result, sql.Composed)

    def test_handles_single_value(self):
        # Arrange
        inputIdColumn = "document_id"
        inputValueColumn = "actor_name"
        inputRelation = "has_actor"
        inputValues = ["Charlie Chaplin"]

        # Act
        result = relation_from_id_to_all_values(
            inputIdColumn, inputValueColumn, inputRelation, inputValues
        )

        # Assert
        assert result is not None
        assert isinstance(result, sql.Composed)

    def test_deduplicates_values(self):
        # Arrange
        inputIdColumn = "document_id"
        inputValueColumn = "genre"
        inputRelation = "has_genre"
        inputValues = ["comedy", "comedy", "drama"]

        # Act
        result = relation_from_id_to_all_values(
            inputIdColumn, inputValueColumn, inputRelation, inputValues
        )

        # Assert
        assert result is not None


class TestExecuteDocumentQuery:
    def test_defaultInputs_executesDefaultQuery(self):
        # Arrange
        inputQuery = Query()
        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        assert "SELECT id, copyright_year, studio, title" in str(executedQuery)

    def test_copyright_year_rangeQuery_executesCopyrightYearRangeQuery(self):
        # Arrange
        inputQuery = Query(copyright_year_range=(2024, 2026))
        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        expectedSegments = [
            "SELECT id, copyright_year, studio, title",
            "AND copyright_year >=",
            "2024",
            "AND copyright_year <=",
            "2026",
        ]

        for segment in expectedSegments:
            assert segment in str(executedQuery)

    def test_studioInputQuery_executesStudioInputQuery(self):
        # Arrange
        inputQuery = Query(studio="Universal")
        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        expectedSegments = [
            "SELECT id, copyright_year, studio, title",
            "AND studio =",
            "Universal",
        ]

        for segment in expectedSegments:
            assert segment in str(executedQuery)

    def test_actorsInputQuery_executesActorsInputQuery(self):
        # Arrange
        inputQuery = Query(actors=["Walter Goggins", "Ella Purnell"])

        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        expectedSegments = [
            "SELECT id, copyright_year, studio, title",
            "actor_name",
            "Walter Goggins",
            "Ella Purnell",
        ]

        for segment in expectedSegments:
            assert segment in str(executedQuery)

    def test_genresInputQuery_executesGenresInputQuery(self):
        # Arrange
        inputQuery = Query(genres=["Horror", "Comedy"])

        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        expectedSegments = [
            "SELECT id, copyright_year, studio, title",
            "AND id in ",
            "Horror",
            "Comedy",
        ]

        for segment in expectedSegments:
            assert segment in str(executedQuery)

    def test_allInputsQuery_executesAllInputsQuery(self):
        # Arrange
        inputQuery = Query(
            copyright_year_range=(2024, 2026),
            studio="Universal",
            actors=["Walter Goggins", "Ella Purnell"],
            genres=["Horror", "Comedy"],
        )

        mockCursor = MagicMock()

        # Act
        execute_document_query(mockCursor, query=inputQuery)
        executedQuery: sql.SQL = mockCursor.execute.call_args[0][0]

        # Assert
        expectedSegments = [
            "SELECT id, copyright_year, studio, title",
            "AND copyright_year >=",
            "2024",
            "AND copyright_year <=",
            "2026",
            "AND studio =",
            "Universal",
            "AND id in ",
            "Walter Goggins",
            "Ella Purnell",
            "Horror",
            "Comedy",
        ]

        for segment in expectedSegments:
            assert segment in str(executedQuery)
