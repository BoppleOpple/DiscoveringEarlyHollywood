from psycopg2.extensions import connection, cursor


def formatDocument(query_result: tuple, transcripts: list = None) -> dict:
    return {
        "id": query_result[0],
        "title": query_result[3],
        "year": query_result[1],
        "type": None,
        "actors": [],
        "studio": query_result[2],
        "content": transcripts,
    }


def search_results(conn: connection, page: int, results_per_page: int = 50):
    if not conn:
        raise Exception("No SQL connection found")

    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT id, copyright_year, studio, title \
            FROM documents \
            LIMIT %s \
            OFFSET %s;",
            [results_per_page, (page - 1) * results_per_page],
        )

        documents = cur.fetchall()

    conn.commit()

    return list(map(formatDocument, documents))


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

    cur: cursor
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

    conn.commit()

    return formatDocument(document, transcripts)


if __name__ == "__main__":
    pass
