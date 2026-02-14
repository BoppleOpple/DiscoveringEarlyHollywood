"""A collection of helpers for sending and recieving data to/from the PostgreSQL database."""

from pathlib import Path
import psycopg2.sql as sql
from psycopg2.extensions import connection, cursor
from datatypes import Document, Query, Flag


def column_relates_to_values(
    columnName: str, valueColumnName: str, relation: str, values: list
) -> sql.SQL:
    tableSQL: sql.SQL = sql.SQL(
        "SELECT {column_name} \
        FROM {relation} \
        WHERE {value_conditions} \
        GROUP BY {column_name} \
        HAVING COUNT(distinct {value_column_name}) >= {num_actors}"
    ).format(
        column_name=sql.Identifier(columnName),
        value_column_name=sql.Identifier(valueColumnName),
        relation=sql.Identifier(relation),
        value_conditions=sql.SQL(" OR ").join(
            [
                sql.SQL("{} = {}").format(
                    sql.Identifier(valueColumnName), sql.Literal(value)
                )
                for value in values
            ]
        ),
        num_actors=sql.Literal(len(values)),
    )

    return tableSQL


def get_base_query(
    query: Query,
    replacements: dict,
    prefix: sql.SQL = sql.SQL("SELECT id, copyright_year, studio, title"),
    suffix: sql.SQL = sql.SQL(";"),
) -> sql.SQL:

    sqlLines: list[sql.SQL] = []

    sqlLines.append(prefix)
    sqlLines.append(sql.SQL("FROM documents"))
    sqlLines.append(sql.SQL("WHERE TRUE"))

    if "title_query" in replacements and replacements["title_query"]:
        sqlLines.append(
            sql.SQL(
                "AND (%(title_query)s IS NULL OR to_tsvector(title) @@ to_tsquery(%(title_query)s))"
            )
        )

    if "min_year" in replacements and replacements["min_year"]:
        sqlLines.append(sql.SQL("AND copyright_year >= %(min_year)s"))

    if "max_year" in replacements and replacements["max_year"]:
        sqlLines.append(sql.SQL("AND copyright_year <= %(max_year)s"))

    if "studio" in replacements and replacements["studio"]:
        sqlLines.append(sql.SQL("AND studio = %(studio)s"))

    if "query_time" in replacements and replacements["query_time"]:
        sqlLines.append(sql.SQL("AND uploaded_time <= %(query_time)s"))

    if query.actors:
        sqlLines.append(
            sql.SQL("AND id in ( {} )").format(
                column_relates_to_values(
                    "document_id", "actor_name", "has_actor", query.actors
                )
            )
        )

    if query.tags:
        sqlLines.append(
            sql.SQL("AND id in ( {} )").format(
                column_relates_to_values("document_id", "tag", "has_tag", query.tags)
            )
        )

    if query.genres:
        sqlLines.append(
            sql.SQL("AND id in ( {} )").format(
                column_relates_to_values(
                    "document_id", "genre", "has_genre", query.genres
                )
            )
        )

    sqlLines.append(suffix)

    SQLQuery: sql.SQL = sql.SQL("\n").join(sqlLines)

    return SQLQuery


# TODO convert query params to a `query` object
def search_results(
    conn: connection, query: Query, page: int, resultsPerPage: int = 50
) -> list[Document]:
    """Return a page of search results.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    page : int
        The index of the page of results to return
    query : :obj:`Query`
        A ``Query`` object specifying the search parameters
    resultsPerPage : int, default = 50
        The number of results displayed on each page

    Returns
    -------
    results : list[Document]
        A list of ``Document``s

    See Also
    --------
    formatDocument : The function used to format returned ``Document``s
    """
    if not conn:
        # TODO make this exception more specific
        raise Exception("No SQL connection found")

    titleQuery = " ".join(query.keywords) if query.keywords else None

    replacements: dict = {
        "title_query": titleQuery,
        "min_year": query.copyrightYearRange[0],
        "max_year": query.copyrightYearRange[1],
        "studio": query.studio,
        "query_time": query.queryTime,
        "num_results": resultsPerPage,
        "offset": (page - 1) * resultsPerPage,
    }

    SQLQuery: sql.SQL = get_base_query(
        query,
        replacements,
        suffix=sql.SQL("LIMIT %(num_results)s \n OFFSET %(offset)s;"),
    ).as_string(conn)

    print(SQLQuery)

    documents: list = []
    cur: cursor = None
    with conn.cursor() as cur:
        # gather only the attributes needed for the results page

        cur.execute(SQLQuery, replacements)

        documents: list[Document] = [
            Document(
                None,  # TODO
                id=documentQuery[0],
                studio=documentQuery[2],
                title=documentQuery[3],
                copyrightYear=documentQuery[1],
            )
            for documentQuery in cur.fetchall()
        ]

        for document in documents:
            cur.execute(
                "SELECT actor_name \
                FROM has_actor \
                WHERE document_id=%s;",
                [document.getId()],
            )

            actorQuery = cur.fetchall()

            document.metadata.actors = [result[0] for result in actorQuery]

            cur.execute(
                "SELECT page_number, content \
                FROM transcripts \
                WHERE document_id=%s \
                ORDER BY page_number;",
                [document.getId()],
            )

            document.transcripts = cur.fetchall()

    conn.commit()

    return documents


# TODO combine with `search_results` instead of performing 2 queries
def get_num_results(conn: connection, query: Query):
    """Fetch the number of results for a given query.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    query : :obj:`Query`
        A ``Query`` object specifying the search parameters

    Returns
    -------
    count : int
        The number of relevant results
    """
    if not conn:
        raise Exception("No SQL connection found")

    titleQuery = " ".join(query.keywords) if query.keywords else None

    replacements: dict = {
        "title_query": titleQuery,
        "min_year": query.copyrightYearRange[0],
        "max_year": query.copyrightYearRange[1],
        "studio": query.studio,
        "query_time": query.queryTime,
    }

    SQLQuery: sql.SQL = get_base_query(
        query,
        replacements,
        prefix=sql.SQL("SELECT COUNT(*)"),
    ).as_string(conn)

    cur: cursor
    with conn.cursor() as cur:
        cur.execute(SQLQuery, replacements)

        count = cur.fetchone()[0]

    conn.commit()

    return count


def get_flagged(conn: connection) -> list[Document]:
    """Return a page of flagged documents. (minimal working version)

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with

    Returns
    -------
    results : list[Document]
        A list of ``Document``s

    """
    if not conn:
        raise Exception("No SQL connection found")

    sql_query = """
        SELECT
            d.id,
            d.copyright_year,
            d.studio,
            d.title
        FROM documents d
        JOIN flagged_by f
          ON f.document_id = d.id
    """

    documents: list[Document] = []

    with conn.cursor() as cur:
        cur.execute(sql_query)

        for row in cur.fetchall():
            documents.append(
                Document(
                    documentDir=Path,
                    id=row[0],
                    copyrightYear=row[1],
                    studio=row[2],
                    title=row[3],
                )
            )

    return documents


def get_document(conn: connection, doc_id: str) -> dict:
    """Fetch *all* data pertaining to a document.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    doc_id : str
        The id of the desired document

    Returns
    -------
    document : Docment
        A ``Docment`` with the specified ``doc_id``, or None
    """
    if not conn:
        raise Exception("No SQL connection found")

    document: tuple = None
    transcripts: list = []
    actors: list = []
    cur: cursor = None
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title, reel_count, uploaded_by, uploaded_time \
            FROM documents \
            WHERE id=%s;",
            [doc_id.lower()],
        )

        document = cur.fetchone()

        cur.execute(
            "SELECT page_number, content \
            FROM transcripts \
            WHERE document_id=%s \
            ORDER BY page_number;",
            [doc_id.lower()],
        )

        transcripts = cur.fetchall()

        cur.execute(
            "SELECT actor_name \
            FROM has_actor \
            WHERE document_id=%s;",
            [doc_id.lower()],
        )

        actors = cur.fetchall()

        cur.execute(
            "SELECT genre \
            FROM has_genre \
            WHERE document_id=%s;",
            [doc_id.lower()],
        )

        genres = cur.fetchall()

        cur.execute(
            "SELECT tag \
            FROM has_tag \
            WHERE document_id=%s;",
            [doc_id.lower()],
        )

        tags = cur.fetchall()

        cur.execute(
            "SELECT user_name, error_location, error_description \
            FROM flagged_by \
            WHERE document_id=%s;",
            [doc_id.lower()],
        )

        flags = [
            Flag(
                reporterName=flagData[0],
                errorLocation=flagData[1],
                errorDescription=flagData[2],
            )
            for flagData in cur.fetchall()
        ]

    conn.commit()

    if not document:
        return None

    return Document(
        None,  # TODO
        id=document[0],
        studio=document[2],
        title=document[3],
        documentType=None,  # TODO
        copyrightYear=document[1],
        reelCount=document[4],
        uploadedTime=document[6],
        uploadedBy=document[5],
        actors=[result[0] for result in actors],
        tags=tags,
        genres=genres,
        transcripts=transcripts,
        flags=flags,
    )


if __name__ == "__main__":
    pass
