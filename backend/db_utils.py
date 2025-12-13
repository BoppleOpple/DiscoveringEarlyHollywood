from psycopg2.extensions import connection, cursor
from functools import partial


def formatDocument(query_result: tuple, transcripts: list = None, actors: list = None) -> dict:
    return {
        "id": query_result[0],
        "title": query_result[3],
        "year": query_result[1],
        "type": None,
        "actors": actors,
        "studio": query_result[2],
        "content": transcripts,
    }


def search_results(conn: connection, page: int, results_per_page: int = 50):
    if not conn:
        raise Exception("No SQL connection found")

    documents: list = []
    actors: list = []
    cur: cursor = None
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title \
            FROM documents \
            LIMIT %s \
            OFFSET %s;",
            [results_per_page, (page - 1) * results_per_page],
        )

        documents = cur.fetchall()

        for document in documents:
            cur.execute(
                "SELECT actor_name \
                FROM has_actor \
                WHERE document_id=%s;",
                [document[0]],
            )
            actors.append([result[0] for result in cur.fetchall()])

    conn.commit()

    return list(map(
        formatDocument,
        documents,
        [None for doc in documents],
        actors
    ))


def get_num_results(conn: connection):
    if not conn:
        raise Exception("No SQL connection found")

    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT COUNT(*) \
            FROM documents"
        )

        count = cur.fetchone()[0]

    conn.commit()

    return count


def get_document(conn: connection, doc_id: str) -> dict:

    if not conn:
        raise Exception("No SQL connection found")

    documents: list = []
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

    return formatDocument(document, transcripts=transcripts, actors=actors)


if __name__ == "__main__":
    pass
