"""A collection of helpers for sending and recieving data to/from the PostgreSQL database."""

from psycopg2.extensions import connection, cursor
from datatypes import Document


def formatDocument(
    documentQuery: tuple,
    transcriptQuery: list[tuple] = None,
    actorQuery: list[tuple] = None,
) -> Document:
    """Format the results of several SQL queries as a ``Document`` object.

    Parameters
    ----------
    documentQuery : tuple
        A ``tuple`` with the following elements:

        - ``[0]``: Document ID
        - ``[1]``: Copyright year
        - ``[2]``: Copyright holder
        - ``[3]``: Document title

    transcriptQuery : list[tuple]
        A ``list`` of ``tuple``s with the following elements:

        - ``[0]``: Page number
        - ``[1]``: Transcript of page

    actorQuery : list[tuple]
        A ``list`` of ``tuple``s with the following elements:

        - ``[0]``: Actor name

    Returns
    -------
    formattedDocument : Document
        A ``Document`` object with all information from the queries
    """
    return Document(
        None,
        id=documentQuery[0],
        studio=documentQuery[2],
        title=documentQuery[3],
        documentType=None,
        copyrightYear=documentQuery[1],
        reelCount=None,
        uploadedTime=None,
        actors=[result[0] for result in actorQuery],
        tags=[],
        genres=[],
        transcripts=transcriptQuery,
        flags=[],
    )


# TODO convert query params to a `query` object
def search_results(
    conn: connection,
    page: int,
    resultsPerPage: int = 50,
    titleQuery: str = None,
    minYear: int = None,
    maxYear: int = None,
) -> list[Document]:
    """Return a page of search results.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    page : int
        The index of the page of results to return
    resultsPerPage : int, default = 50
        The number of results displayed on each page
    titleQuery : str, default = None
        Text that must be included in returned documents
    minYear : int, default = None
        The minimum year of returned documents
    maxYear : int, default = None
        The minimum year of returned documents

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

    if not titleQuery:
        titleQuery = None

    documents: list = []
    actors: list = []
    cur: cursor = None
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title \
            FROM documents \
            WHERE (%(title_query)s IS NULL OR to_tsvector(title) @@ to_tsquery(%(title_query)s)) \
            AND (%(min_year)s IS NULL OR copyright_year >= %(min_year)s) \
            AND (%(max_year)s IS NULL OR copyright_year <= %(max_year)s) \
            LIMIT %(num_results)s \
            OFFSET %(offset)s;",
            {
                "title_query": titleQuery,
                "min_year": minYear,
                "max_year": maxYear,
                "num_results": resultsPerPage,
                "offset": (page - 1) * resultsPerPage,
            },
        )

        documents = cur.fetchall()

        for document in documents:
            cur.execute(
                "SELECT actor_name \
                FROM has_actor \
                WHERE document_id=%s;",
                [document[0]],
            )
            actors.append(cur.fetchall())

    conn.commit()

    return list(map(formatDocument, documents, [None for doc in documents], actors))


def get_num_results(
    conn: connection,
    titleQuery: str = None,
    minYear: int = None,
    maxYear: int = None,
):
    """Fetch the number of results for a given query.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    titleQuery : str, default = None
        Text that must be included in returned documents
    minYear : int, default = None
        The minimum year of returned documents
    maxYear : int, default = None
        The minimum year of returned documents

    Returns
    -------
    count : int
        The number of relevant results
    """
    if not conn:
        raise Exception("No SQL connection found")

    if not titleQuery:
        titleQuery = None

    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT COUNT(*) \
            FROM documents \
            WHERE (%(title_query)s IS NULL OR to_tsvector(title) @@ to_tsquery(%(title_query)s)) \
            AND (%(min_year)s IS NULL OR copyright_year >= %(min_year)s) \
            AND (%(max_year)s IS NULL OR copyright_year <= %(max_year)s);",
            {
                "title_query": titleQuery,
                "min_year": minYear,
                "max_year": maxYear,
            },
        )

        count = cur.fetchone()[0]

    conn.commit()

    return count


def get_document(conn: connection, doc_id: str) -> dict:
    """Fetch all data pertaining to a document.

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

    See Also
    --------
    formatDocument : The function used to format the returned ``Document``
    """
    if not conn:
        raise Exception("No SQL connection found")

    document: tuple = None
    transcripts: list = []
    actors: list = []
    cur: cursor = None
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title \
            FROM documents \
            WHERE id=%s;",
            [doc_id.lower()],
        )

        document = cur.fetchone()

        cur.execute(
            "SELECT page_number, content \
            FROM transcripts \
            WHERE document_id=%s;",
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

    conn.commit()

    if not document:
        return None

    return formatDocument(document, transcriptQuery=transcripts, actorQuery=actors)


if __name__ == "__main__":
    pass
