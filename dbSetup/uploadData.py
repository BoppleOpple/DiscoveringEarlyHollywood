import os
import argparse
import json
import datetime
from dotenv import load_dotenv
from tqdm import tqdm

import psycopg2
import psycopg2.extras

parser = argparse.ArgumentParser(
    prog="uploadData.py",
    description="A program that uploads data to \
the Discovering Early Hollywood PostgreSQL database",
    epilog="Willy N' Gang, 2025",
)

parser.add_argument("-d", "--document-directory", default="./data/film_copyright")
parser.add_argument(
    "-t",
    "--transcript-directory",
    default="./data/Hollywood_Copyright_Materials_Base_Transcriptions",
)
parser.add_argument(
    "-m",
    "--metadata-directory",
    required=False,
    default="./data/cleaned_copyright_with_metadata",
)


def createTables(cursor: psycopg2.extras._cursor):
    print("Adding relations to database")
    with open("tableDefinitions.sql", "r") as f:
        cursor.execute(f.read())


def loadData(args: argparse.Namespace, cursor: psycopg2.extras._cursor):
    print("parsing movies")
    ids: list[str] = [fname[:-24] for fname in os.listdir(args.metadata_directory)]
    movieData: list = []
    transcriptData: list = []

    for document_id in tqdm(ids):
        currentMovieEntry = [document_id, None, None, datetime.datetime.now()]

        with open(
            f"{args.metadata_directory}/{document_id}with_added_metadata.json"
        ) as metadataJson:
            metadata = json.load(metadataJson)

            currentMovieEntry[1] = metadata["date"]
            currentMovieEntry[2] = metadata["producer"]

            for page, content in enumerate(metadata["text"]):
                transcriptData.append((document_id, page, content))

        movieData.append(currentMovieEntry)

    print("Adding documents to database")
    psycopg2.extras.execute_batch(
        cursor,
        "INSERT INTO documents ( \
            id, \
            copyright_year, \
            studio, \
            uploaded_time \
        ) VALUES (%s, %s, %s, %s) \
        ON CONFLICT DO NOTHING;",
        tqdm(movieData),
        page_size=500,
    )

    print("Adding transcripts to database")
    psycopg2.extras.execute_batch(
        cursor,
        "INSERT INTO transcripts ( \
            document_id, \
            page_number, \
            content \
        ) VALUES (%s, %s, %s) \
        ON CONFLICT DO NOTHING;",
        tqdm(transcriptData),
        page_size=500,
    )


def main(argv=None):
    args = parser.parse_args(argv)
    load_dotenv()

    dbConnection: psycopg2.extensions.connection = psycopg2.connect(
        host=os.environ["SQL_HOST"],
        port=os.environ["SQL_PORT"],
        dbname=os.environ["SQL_DBNAME"],
        user=os.environ["SQL_USER"],
        password=os.environ["SQL_PASSWORD"],
    )

    with dbConnection.cursor() as cursor:
        try:
            createTables(cursor)
            dbConnection.commit()
        except Exception:
            print("error?")
            dbConnection.rollback()

        loadData(args, cursor)
        dbConnection.commit()

    dbConnection.close()


if __name__ == "__main__":
    main()
