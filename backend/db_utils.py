from psycopg2.extensions import connection, cursor


def get_document(conn: connection, doc_id: str) -> dict:

    if not conn:
        raise Exception("No SQL connection found")

    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            " \
            SELECT id, copyright_year, studio \
            FROM documents \
            WHERE id=%s;",
            [doc_id.lower()],
        )

        document = cur.fetchone()

        cur.execute(
            " \
            SELECT page_number, content \
            FROM transcripts \
            WHERE document_id=%s;",
            [doc_id.lower()],
        )

        transcripts = cur.fetchall()

    conn.commit()
    conn.close()

    return {
        "id": document[0],
        "title": None,
        "year": document[1],
        "type": None,
        "actors": [],
        "studio": document[2],
        "content": "\n\n".join([pageData[1] for pageData in transcripts]),
    }


if __name__ == "__main__":
    pass
