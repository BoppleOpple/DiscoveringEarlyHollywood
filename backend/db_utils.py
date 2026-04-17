"""A collection of helpers for sending and recieving data to/from the PostgreSQL database."""

import psycopg2
import psycopg2.sql as sql
from psycopg2.extensions import connection, cursor
from flask import current_app, g
from .datatypes import Document, Query, Flag


def get_db_connection() -> psycopg2.extensions.connection:
    """Creates a new ``psycopg2.extensions.connection`` or returns the current one

    Returns
    -------
    db_connection : :obj:`psycopg2.extensions.connection`
        The active ``psycopg2`` connection
    """
    if "db_connection" not in g:
        g.db_connection = psycopg2.connect(
            host=current_app.config["SQL_HOST"],
            port=current_app.config["SQL_PORT"],
            dbname=current_app.config["SQL_DBNAME"],
            user=current_app.config["SQL_USER"],
            password=current_app.config["SQL_PASSWORD"],
        )

    return g.db_connection


def relation_from_id_to_all_values(
    idColumn: str, valueColumn: str, relation: str, values: list
) -> sql.SQL:
    """Generates SQL for a table containing rows from ``columnName`` relating to each of ``values``

    Parameters
    ----------
    idColumn : str
        The name of the column that is being filtered (i.e. the ``id`` column when finding all
        ``id``s with some ``value``)

    valueColumn : str
        The name of the column that the ``idColumn`` is filtered by (i.e. the ``value`` column when
        finding all ``id``s with some ``value``)

    relation : str
        The name of the relation containing both ``idColumn`` and ``valueColumn``

    values : list
        The list of ``value``s that each ``id`` must relate to to appear in the resulting relation

    Returns
    -------
    tableSQL: psycopg2.sql.SQL
        The SQL query for a relation containing only those ``id``s which are related to each
        ``value``

    Examples
    --------

    >>> # +----------------------+
    >>> # |      has_genre       |
    >>> # +-------------+--------|
    >>> # | document_id | genre  |
    >>> # +-------------+--------+
    >>> # | s0000l11111 | comedy |
    >>> # | s0000l11111 | drama  |
    >>> # | s2222l33333 | drama  |
    >>> # +-------------+--------+


    >>> # To find all documents with both genres "comedy" and "drama":
    >>> relation_from_id_to_all_values("document_id", "genre", "has_genre", ["comedy", "drama"])
        psycopg2.sql.SQL("SELECT document_id \
FROM has_genre \
WHERE genre = 'comedy' OR genre = 'drama' \
GROUP BY genre \
HAVING COUNT(distinct document_id) >= 2")
    """

    tableSQL: sql.SQL = sql.SQL(
        "SELECT {column_name} \
        FROM {relation} \
        WHERE {value_conditions} \
        GROUP BY {column_name} \
        HAVING COUNT(distinct {value_column_name}) >= {num_actors}"
    ).format(
        column_name=sql.Identifier(idColumn),
        value_column_name=sql.Identifier(valueColumn),
        relation=sql.Identifier(relation),
        # OR since we are matching all rows containing any value.
        # those ids that contain more than 1 value will have more than 1 row in the resulting table
        # (before the HAVING clause)
        value_conditions=sql.SQL(" OR ").join(
            [
                sql.SQL("{} = {}").format(
                    sql.Identifier(valueColumn), sql.Literal(value)
                )
                for value in set(values)
            ]
        ),
        num_actors=sql.Literal(len(values)),
    )

    return tableSQL


def execute_document_query(
    cursor: cursor,
    query: Query,
    prefix: sql.SQL = sql.SQL(
        "SELECT id, copyright_year, studio, title, document_type"
    ),
    suffix: sql.SQL = sql.SQL(";"),
    rankPages: bool = False,
):
    """Create a SQL query from a ``Query`` object.

    Parameters
    ----------
    cursor : :obj:`psycopg2.extensions.cursor`
        The cursor upon which the query will be executed

    query : :obj:`Query`
        A ``Query`` object containing all relevant information for the SQL query

    prefix : :obj:`psycopg2.sql.SQL`, default = SQL("SELECT id, copyright_year, studio, title")
        Optional SQL to be inserted before the "FROM" clause

    suffix : :obj:`psycopg2.sql.SQL`, default = SQL(";")
        Optional SQL to be inserted after the "WHERE" clause(s)

    rankPages : bool, default = False
        Whether results should be ordered by relevance
    """
    # manual SQL composition since binding variables in `execute()`
    # does not allow for a variable number of variables
    sqlLines: list[sql.SQL] = []

    sqlLines.append(prefix)
    sqlLines.append(
        sql.SQL("FROM documents INNER JOIN text_search_view ON id = document_id")
    )
    sqlLines.append(sql.SQL("WHERE TRUE"))

    # handle filtering by title
    titleQuery = " ".join(query.keywords) if query.keywords else None
    if titleQuery:
        sqlLines.append(
            sql.SQL("AND text_vector @@ websearch_to_tsquery({title})").format(
                title=sql.Literal(titleQuery)
            )
        )

    # handle filtering by minimum year
    if query.copyright_year_range[0] is not None:
        sqlLines.append(
            sql.SQL("AND copyright_year >= {}").format(
                sql.Literal(query.copyright_year_range[0])
            )
        )

    # handle filtering by maximum year
    if query.copyright_year_range[1] is not None:
        sqlLines.append(
            sql.SQL("AND copyright_year <= {}").format(
                sql.Literal(query.copyright_year_range[1])
            )
        )

    # handle filtering by minimum reel count
    if query.reel_range[0] is not None:
        sqlLines.append(
            sql.SQL("AND reel_count >= {}").format(sql.Literal(query.reel_range[0]))
        )

    # handle filtering by maximum reel count
    if query.reel_range[1] is not None:
        sqlLines.append(
            sql.SQL("AND reel_count <= {}").format(sql.Literal(query.reel_range[1]))
        )

    # handle filtering by studio/copyright holder
    if query.studio:
        sqlLines.append(sql.SQL("AND studio = {}").format(sql.Literal(query.studio)))

    # handle filtering by document upload time
    if query.query_time:
        sqlLines.append(
            sql.SQL("AND uploaded_time <= {}").format(sql.Literal(query.query_time))
        )

    # handle filtering by actors (list of required actors)
    if query.actors:
        sqlLines.append(
            sql.SQL("AND id in ( {} )").format(
                relation_from_id_to_all_values(
                    "document_id", "actor_name", "has_character", query.actors
                )
            )
        )

    # handle filtering by genres (list of required genres)
    if query.genres:
        sqlLines.append(
            sql.SQL("AND id in ( {} )").format(
                relation_from_id_to_all_values(
                    "document_id", "genre", "has_genre", query.genres
                )
            )
        )

    if rankPages and titleQuery:
        # sqlLines.append(
        #     sql.SQL("GROUP BY id")
        # )

        sqlLines.append(
            sql.SQL(
                "ORDER BY ts_rank_cd( \
                    text_search_view.text_vector, \
                    websearch_to_tsquery({title}) \
                ) DESC"
            ).format(title=sql.Literal(titleQuery))
        )

    sqlLines.append(suffix)

    # finally compose the query
    SQLQuery: sql.SQL = sql.SQL("\n").join(sqlLines)
    # print(SQLQuery.as_string(cursor.connection))

    # execute the query, with replacement variables already in-place
    cursor.execute(SQLQuery)


def search_results(
    conn: connection, query: Query, page: int = 1, resultsPerPage: int = 50
) -> list[Document]:
    """Return a page of search results.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    page : int, default = 1
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

    documents: list = []

    try:
        cur: cursor = None
        with conn.cursor() as cur:
            # gather only the attributes needed for the results page

            execute_document_query(
                cur,
                query,
                suffix=sql.Composed(
                    [
                        sql.SQL("LIMIT "),
                        sql.Literal(resultsPerPage),
                        sql.SQL("\nOFFSET "),
                        sql.Literal(resultsPerPage * (page - 1)),
                        sql.SQL(";"),
                    ]
                ),
                rankPages=True,
            )

            documents: list[Document] = [
                Document(
                    id=documentQuery[0],
                    studio=documentQuery[2],
                    title=documentQuery[3],
                    copyright_year=documentQuery[1],
                    document_type=documentQuery[4],
                )
                for documentQuery in cur.fetchall()
            ]

            for document in documents:
                cur.execute(
                    "SELECT actor_name \
                    FROM has_character \
                    WHERE document_id=%s;",
                    [document.id],
                )

                actorQuery = cur.fetchall()

                document.actors = [result[0] for result in actorQuery]

                cur.execute(
                    "SELECT page_number, content \
                    FROM transcripts \
                    WHERE document_id=%s \
                    ORDER BY page_number;",
                    [document.id],
                )

                document.transcripts = cur.fetchall()

        conn.commit()
    except (
        psycopg2.errors.ObjectNotInPrerequisiteState,
        psycopg2.errors.InFailedSqlTransaction,
    ) as e:
        print(e)

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
    count: int = 0
    if not conn:
        raise Exception("No SQL connection found")

    try:
        cur: cursor = None
        with conn.cursor() as cur:
            execute_document_query(
                cur,
                query,
                prefix=sql.SQL("SELECT COUNT(*)"),
            )

            result: tuple = cur.fetchone()

        # set `count` to the number of results if any exist, otherwise 0
        if result:
            count = result[0]

        conn.commit()
    except psycopg2.errors.ObjectNotInPrerequisiteState as e:
        print(e)

    return count


# TODO combine with `search_results` instead of performing 2 queries
def get_search_result_ids(conn: connection, query: Query) -> list[str]:
    """Fetch the ids of every document matching a given query.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    query : :obj:`Query`
        A ``Query`` object specifying the search parameters

    Returns
    -------
    ids : list[str]
        The ids of relevant documents
    """
    ids: list[str] = []
    if not conn:
        raise Exception("No SQL connection found")

    try:
        cur: cursor = None
        with conn.cursor() as cur:
            execute_document_query(
                cur,
                query,
                prefix=sql.SQL("SELECT id"),
            )

            result: tuple = cur.fetchall()

        # set `count` to the number of results if any exist, otherwise 0
        if result:
            ids = [row[0] for row in result]

        conn.commit()
    except psycopg2.errors.ObjectNotInPrerequisiteState as e:
        print(e)

    return ids


def get_headlines(
    conn: connection, documents: list[Document], query: Query, max_length: int = 400
) -> dict[str, str]:
    """Create a SQL query from a ``Query`` object.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with

    documents : list[Document]
        The documents to search

    query : :obj:`Query`
        A ``Query`` object containing all relevant information for the SQL query

    max_length : int
        The maximum length of the snippet

    Returns
    -------
    headline : str
        the portion of the document relevant to
    """
    if not documents:
        return dict()

    titleQuery = " ".join(query.keywords) if query.keywords else None

    if titleQuery:
        with conn.cursor() as cur:
            # most of the work is handled by `ts_headline`:
            # https://www.postgresql.org/docs/current/textsearch-controls.html
            cur.execute(
                "SELECT document_id, ts_headline( \
                    content, \
                    websearch_to_tsquery(%s), \
                    'MaxFragments=3, MaxWords=40, MinWords=20, FragmentDelimiter=...<br><br>...' \
                ) \
                FROM text_content_view \
                WHERE document_id IN %s;",
                (titleQuery, tuple(doc.id for doc in documents)),
            )

            return dict(cur.fetchall())
    else:
        return dict(
            (
                (
                    doc.id,
                    (
                        (
                            doc.transcripts[0][1][:max_length]
                            + (
                                "..."
                                if doc.transcripts
                                and len(doc.transcripts[0][1]) > max_length
                                else ""
                            )
                        )
                        if doc.transcripts
                        else ""
                    ),
                )
                for doc in documents
            )
        )


def get_flagged(conn: connection) -> list[Document]:
    """Return flagged documents with their attached flags.

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

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT DISTINCT document_id
            FROM flagged_by
            ORDER BY document_id;
            """
        )
        doc_ids: list[str] = [row[0] for row in cur.fetchall()]

    conn.commit()

    return get_documents(conn, doc_ids) if doc_ids else []


def _clean_csv_value(value: str) -> str:
    if value:
        return f"\"{value.strip().replace("\"", "\"\"").replace("\n", " ")}\""
    else:
        return ""


def _csv(values: list[str] | None) -> str | None:
    if not values:
        return None
    return ",".join(v.strip() for v in values if v is not None) or None


def _search_label(
    search_text: str | None,
    start_year: int | None,
    end_year: int | None,
    min_reels: int | None,
    max_reels: int | None,
    studio: str | None,
    genres: str | None,
) -> str:
    """Build label for a logged search from database row."""
    if search_text and search_text.strip():
        return search_text.strip()

    parts: list[str] = []
    if start_year is not None or end_year is not None:
        parts.append(f"Years: {start_year or '?'}-{end_year or '?'}")
    if min_reels is not None or max_reels is not None:
        parts.append(f"Reels: {min_reels or '?'}-{max_reels or '?'}")
    if studio:
        parts.append(f"Studio: {studio}")
    if genres:
        parts.append(f"Genres: {genres}")

    return ", ".join(parts) if parts else "All documents"


def log_search(
    conn: connection,
    *,
    user_name: str,
    start_year: int | None,
    end_year: int | None,
    min_reels: int | None,
    max_reels: int | None,
    studio: str | None,
    actors: list[str] | None,
    genres: list[str] | None,
    tags: list[str] | None,
    search_text: str | None,
) -> int:
    """Insert one row into ``search_history`` and return its ``id``."""
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO search_history (
                user_name,
                "time",
                start_year,
                end_year,
                min_reels,
                max_reels,
                studio,
                actors,
                genres,
                tags,
                search_text
            ) VALUES (%s, NOW(), %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id;
            """,
            [
                user_name,
                start_year,
                end_year,
                min_reels,
                max_reels,
                studio,
                _csv(actors),
                _csv(genres),
                _csv(tags),
                search_text.strip() if search_text and search_text.strip() else None,
            ],
        )
        search_id: int = cur.fetchone()[0]
    conn.commit()
    return search_id


def log_view(
    conn: connection,
    *,
    user_name: str,
    document_id: str,
    search_id: int | None = None,
):
    """Insert one row into ``view_history``."""
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO view_history
                (user_name, document_id, viewed_at, search_id)
            VALUES
                (%s, %s, NOW(), %s);
            """,
            [user_name, document_id, search_id],
        )
    conn.commit()


def log_flag(
    conn: connection,
    *,
    user_name: str,
    document_id: str,
    error_location: str,
    error_description: str,
):
    """Insert one flag for a document."""
    if not conn:
        raise Exception("No SQL connection found")

    normalized_location = error_location.strip()
    normalized_description = error_description.strip()

    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO error_locations (location)
            VALUES (%s)
            ON CONFLICT (location) DO NOTHING;
            """,
            [normalized_location],
        )
        cur.execute(
            """
            INSERT INTO flagged_by
                (id, document_id, user_name, error_location, error_description)
            VALUES
                (gen_random_uuid(), %s, %s, %s, %s);
            """,
            [
                document_id.lower(),
                user_name,
                normalized_location,
                normalized_description,
            ],
        )

    conn.commit()


def get_search_history(conn: connection, user_name: str, limit: int = 50) -> list[dict]:
    """Return search history rows formatted for ``view_history.html``."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT
                id,
                "time",
                search_text,
                start_year,
                end_year,
                min_reels,
                max_reels,
                studio,
                genres
            FROM search_history
            WHERE user_name=%s
            ORDER BY "time" DESC
            LIMIT %s;
            """,
            [user_name, limit],
        )

        rows = cur.fetchall()

    conn.commit()

    return [
        {
            "id": row[0],
            "query": _search_label(
                search_text=row[2],
                start_year=row[3],
                end_year=row[4],
                min_reels=row[5],
                max_reels=row[6],
                studio=row[7],
                genres=row[8],
            ),
            "date": row[1].strftime("%b %d, %Y %I:%M %p"),
            "search_text": row[2],
            "start_year": row[3],
            "end_year": row[4],
            "min_reels": row[5],
            "max_reels": row[6],
            "studio": row[7],
            "genres": row[8],
        }
        for row in rows
    ]


def get_search_history_entry(
    conn: connection, user_name: str, search_id: int
) -> dict | None:
    """Fetch one saved search for a user by id."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT
                id,
                "time",
                search_text,
                start_year,
                end_year,
                min_reels,
                max_reels,
                studio,
                actors,
                genres,
                tags
            FROM search_history
            WHERE id=%s AND user_name=%s;
            """,
            [search_id, user_name],
        )
        row = cur.fetchone()

    conn.commit()

    if not row:
        return None

    return {
        "id": row[0],
        "time": row[1],
        "search_text": row[2],
        "start_year": row[3],
        "end_year": row[4],
        "min_reels": row[5],
        "max_reels": row[6],
        "studio": row[7],
        "actors": row[8],
        "genres": row[9],
        "tags": row[10],
    }


def clear_search_history(conn: connection, user_name: str):
    """Delete all search history rows associated with a given user."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            "DELETE FROM search_history WHERE user_name=%s;",
            [user_name],
        )

    conn.commit()


def get_view_history(conn: connection, user_name: str, limit: int = 200) -> list[dict]:
    """Return viewed documents with optional search attribution."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT
                vh.document_id,
                d.title,
                d.copyright_year,
                d.studio,
                vh.viewed_at,
                vh.search_id,
                sh.search_text
            FROM view_history vh
            JOIN documents d
              ON d.id = vh.document_id
            LEFT JOIN search_history sh
              ON sh.id = vh.search_id
            WHERE vh.user_name = %s
            ORDER BY vh.viewed_at DESC
            LIMIT %s;
            """,
            [user_name, limit],
        )

        rows = cur.fetchall()

    conn.commit()

    history: list[dict] = []
    for row in rows:
        search_text = row[6]
        studio = row[3]
        description = (
            f'From search: "{search_text}"'
            if search_text and search_text.strip()
            else (f"Studio: {studio}" if studio else "No additional details")
        )

        history.append(
            {
                "id": row[0],
                "title": row[1],
                "year": row[2],
                "description": description,
                "document_type": "Document",
                "viewedDate": row[4].strftime("%b %d, %Y %I:%M %p"),
                "viewedAt": row[4],
                "searchText": search_text,
            }
        )

    return history


def get_viewed_document_ids(conn: connection, user_name: str) -> set[str]:
    """Return distinct document ids viewed by a user."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT DISTINCT document_id
            FROM view_history
            WHERE user_name=%s;
            """,
            [user_name],
        )
        rows = cur.fetchall()

    conn.commit()
    return {row[0] for row in rows}


def clear_view_history(conn: connection, user_name: str):
    """Delete all view history rows associated with a given user."""
    if not conn:
        raise Exception("No SQL connection found")

    with conn.cursor() as cur:
        cur.execute(
            "DELETE FROM view_history WHERE user_name=%s;",
            [user_name],
        )

    conn.commit()


def get_documents(conn: connection, doc_ids: list[str]) -> str:
    """Fetch *all* data pertaining to multiple documents.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with

    doc_ids : list[str]
        The id of the desired document

    Returns
    -------
    docs : list[Document]
        A list of ``Document``s with information from the specified ``doc_ids``
    """

    document_data: list[tuple] = None
    transcript_data: list[tuple] = None
    actor_data: list[tuple] = None
    genre_data: list[tuple] = None
    location_data: list[tuple] = None
    flag_data: list[tuple] = None
    cur: cursor = None

    cleaned_ids: tuple = tuple(id.lower() for id in doc_ids)

    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title, reel_count, uploaded_by, uploaded_time \
            FROM documents \
            WHERE id IN %s;",
            [cleaned_ids],
        )

        document_data = cur.fetchall()

        cur.execute(
            "SELECT document_id, page_number, content \
            FROM transcripts \
            WHERE document_id IN %s \
            ORDER BY page_number;",
            [cleaned_ids],
        )

        transcript_data = cur.fetchall()

        cur.execute(
            "SELECT document_id, actor_name, character_name, character_description \
            FROM has_character \
            WHERE document_id IN %s;",
            [cleaned_ids],
        )

        actor_data = cur.fetchall()

        cur.execute(
            "SELECT document_id, genre \
            FROM has_genre \
            WHERE document_id IN %s;",
            [cleaned_ids],
        )

        genre_data = cur.fetchall()

        cur.execute(
            "SELECT document_id, location, description \
            FROM has_location \
            WHERE document_id IN %s;",
            [cleaned_ids],
        )

        location_data = cur.fetchall()

        cur.execute(
            "SELECT document_id, user_name, error_location, error_description \
            FROM flagged_by \
            WHERE document_id IN %s;",
            [cleaned_ids],
        )

        flag_data = cur.fetchall()

    conn.commit()

    documents: dict[str, Document] = {}

    # create document objects
    for document_row in document_data:
        id: str = document_row[0]
        copyright_year: int = (
            int(document_row[1]) if document_row[1] is not None else None
        )
        studio: str = document_row[2]
        title: str = document_row[3]
        reel_count: int = int(document_row[4]) if document_row[4] is not None else None
        uploaded_by: str = document_row[5]
        uploaded_time: str = document_row[6]

        documents[id] = Document(
            id=id,
            studio=studio,
            title=title,
            document_type=None,  # TODO
            copyright_year=copyright_year,
            reel_count=reel_count,
            uploaded_time=uploaded_time,
            uploaded_by=uploaded_by,
            transcripts=[],
            actors=[],
            genres=[],
            locations=[],
        )

    # include transcript data
    for transcript_row in transcript_data:
        id: str = transcript_row[0]
        page_number: int = (
            int(transcript_row[1]) if transcript_row[1] is not None else None
        )
        content: str = transcript_row[2]

        documents[id].transcripts.append((page_number, content))

    # include actor data
    for actor_row in actor_data:
        id: str = actor_row[0]
        name: str = actor_row[1]

        documents[id].actors.append(name)

    # include genre data
    for genre_row in genre_data:
        id: str = genre_row[0]
        genre: str = genre_row[1]

        documents[id].genres.append(genre)

    # include location data
    for location_row in location_data:
        id: str = location_row[0]
        name: str = location_row[1]
        description: str = location_row[2]

        documents[id].locations.append({"name": name, "description": description})

    # include flag data
    for flag_row in flag_data:
        id: str = flag_row[0]
        reporter_name: str = flag_row[1]
        error_location: str = flag_row[2]
        error_description: str = flag_row[3]

        documents[id].flags.append(
            Flag(
                reporterName=reporter_name,
                errorLocation=error_location,
                errorDescription=error_description,
            )
        )

    return list(documents.values())


def get_document(conn: connection, doc_id: str) -> Document:
    """Fetch *all* data pertaining to a document.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    doc_id : str
        The id of the desired document

    Returns
    -------
    documents[0] : Docment
        A ``Docment`` with the specified ``doc_id``, or None
    """
    if not conn:
        raise Exception("No SQL connection found")

    documents: list[Document] = get_documents(conn, [doc_id])
    if not documents:
        return None

    return documents[0]


def get_documents_as_csv(conn: connection, doc_ids: list[str]) -> str:
    """Fetch *all* data pertaining to a document.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with

    doc_ids : list[str]
        The id of the desired document

    Returns
    -------
    csv_body : str
        A ``str`` with information from the specified ``doc_ids``, formatted as a csv
    """

    documents: list[Document] = get_documents(conn, doc_ids)

    csv_body: str = (
        _csv(
            [
                "id",
                "copyright_year",
                "studio",
                "title",
                "reel_count",
                "uploaded_by",
                "uploaded_time",
                "transcript",
                "actors",
                "genres",
                "locations",
            ]
        )
        + "\n"
    )

    for doc in documents:
        csv_body += (
            _csv(
                [
                    _clean_csv_value(doc.id),
                    _clean_csv_value(str(doc.copyright_year)),
                    _clean_csv_value(doc.studio),
                    _clean_csv_value(doc.title),
                    _clean_csv_value(str(doc.reel_count)),
                    _clean_csv_value(doc.uploaded_by),
                    _clean_csv_value(str(doc.uploaded_time)),
                    _clean_csv_value(doc.content),
                    _clean_csv_value(
                        ";".join([actor for actor in doc.actors if actor])
                    ),
                    _clean_csv_value(";".join(doc.genres)),
                    _clean_csv_value(
                        ";".join(
                            [
                                location["name"]
                                for location in doc.locations
                                if location["name"]
                            ]
                        )
                    ),
                ]
            )
            + "\n"
        )

    return csv_body


if __name__ == "__main__":
    pass
