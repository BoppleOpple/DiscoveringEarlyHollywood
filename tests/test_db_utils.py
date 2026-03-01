# relation_from_id_to_all_values SQL generation

import psycopg2.sql as sql

from backend.db_utils import relation_from_id_to_all_values, execute_document_query
from backend.datatypes import Query
from unittest.mock import MagicMock


class TestRelationFromIdToAllValues:
    def test_returns_sql_object(self):
        result = relation_from_id_to_all_values(
            idColumn="document_id",
            valueColumn="genre",
            relation="has_genre",
            values=["comedy", "drama"],
        )
        assert result is not None
        assert isinstance(result, sql.Composed)

    def test_handles_single_value(self):
        result = relation_from_id_to_all_values(
            idColumn="document_id",
            valueColumn="actor_name",
            relation="has_actor",
            values=["Charlie Chaplin"],
        )
        assert result is not None
        assert isinstance(result, sql.Composed)

    def test_deduplicates_values(self):
        result = relation_from_id_to_all_values(
            idColumn="document_id",
            valueColumn="genre",
            relation="has_genre",
            values=["comedy", "comedy", "drama"],
        )
        assert result is not None


class TestExecuteDocumentQuery:
    def test_validInputs_executesValidQuery(self):
        # Arrange
        inputQuery = Query()
        inputQuery.setStudio("Universal")
        mockCursor = MagicMock()

        # Act
        Result: sql.SQL = execute_document_query(
            mockCursor, query=inputQuery, testing=True
        )

        # Assert
        assert "SELECT id, copyright_year, studio, title" in str(Result)
