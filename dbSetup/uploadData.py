"""A CLI program that uploads LoC data from the local filesystem to a PostgreSQL database."""

import argparse
import json
import numpy as np
import os

# import datetime
# import re
from glob import iglob
from pathlib import Path
from dotenv import load_dotenv
from threading import Thread, Semaphore
from typing import AnyStr
from tqdm import tqdm

import psycopg2
import psycopg2.extras

parser = argparse.ArgumentParser(
    prog="uploadData.py",
    description="A program that uploads data to \
the Discovering Early Hollywood PostgreSQL database",
    epilog="Willy N' Gang, 2025",
)

parser.add_argument(
    "-d", "--document-directory", default="./data/film_copyright", type=Path
)
parser.add_argument(
    "-o",
    "--outdir",
    required=False,
    default="./out",
    type=Path,
)
parser.add_argument(
    "-t",
    "--transcript-directory",
    default="./data/qwen_ocr",
    type=Path,
)
parser.add_argument(
    "-m",
    "--metadata-directory",
    required=False,
    default="./data/cleaned_copyright_with_metadata",
    type=Path,
)
parser.add_argument(
    "-a",
    "--analysis-directory",
    required=False,
    default="./data/gemma4-metadata",
    type=Path,
)
parser.add_argument(
    "-j",
    "--thread-count",
    required=False,
    default=4,
    type=int,
)

progress_sem: Semaphore = Semaphore()


def create_tables(cursor: psycopg2.extensions.cursor):
    """Given a ``psycopg2`` cursor, create all SQL relations.

    Parameters
    ----------
    cursor : psycopg2.extensions.cursor
        The ``psycopg2`` ``cursor`` object with which the query is performed
    """
    print("Adding relations to database")
    with open("tableDefinitions.sql", "r") as f:
        cursor.execute(f.read())


# TODO improve code commenting post-prototype
def format_llm_analysis(analysis: str, id: str) -> dict:
    """Form a ``dict`` from metadata extracted by an LLM.

    Parameters
    ----------
    analysis : str

    Returns
    -------
    formatted_analysis : dict
        A ``dict`` of the form::

            {
                "title": str,
                "actors": list[str],
                "failed": bool
            }
    """
    formatted_analysis: dict = {
        "title": None,
        "producer": None,
        "writer": None,
        "production_company": None,
        "reels": None,
        "series": None,
        "genres": [],
        "characters": [],
        "locations": [],
        "failed": False,
    }
    if analysis:
        try:
            analysis_obj: dict | list | None = json.loads(analysis)

            for key in formatted_analysis.keys():
                if key in analysis_obj:
                    formatted_analysis[key] = analysis_obj[key]

        except json.decoder.JSONDecodeError as e:
            formatted_analysis["failed"] = True
            print(f"Error while decoding {id}:")
            print(e)
    else:
        formatted_analysis["failed"] = True

    return formatted_analysis


def _process_ids(
    args: argparse.Namespace,
    cursor: psycopg2.extensions.cursor,
    ids: list[AnyStr],
    transcripts: list[AnyStr],
    progress: tqdm,
):
    for document_path in ids:
        document_id: str = Path(document_path).name

        metadata_file: Path = (
            args.metadata_directory / f"{document_id}with_added_metadata.json"
        )

        relevant_transcripts: list[AnyStr] = list(
            filter(lambda fname: fname.startswith(document_id), transcripts)
        )

        analysis_file: Path = args.analysis_directory / f"{document_id}.json"

        metadata: dict = None
        if metadata_file.exists():
            with open(metadata_file, "r") as metadata_json:
                metadata = json.load(metadata_json)
                del metadata["text"]

        transcript_data: list = []
        for fname in relevant_transcripts:
            page: int = int(fname[:-4].split("_p")[-1])

            with open(fname, "r") as transcript_file:
                transcript_data.append((document_id, page, transcript_file.read()))

        analysis: dict = None
        if analysis_file.exists():
            with open(analysis_file, "r") as analysis_json:
                analysis = format_llm_analysis(analysis_json.read(), document_id)

            if analysis["failed"]:
                with open(args.outdir / "failed.txt", "a") as f:
                    f.write(document_id + "\n")

        # print(document_id)
        # print(metadata)
        # print(transcript_data)
        # pprint(analysis)
        # print(formatted_analysis)
        # exit(0)
        with progress_sem:
            progress.update()
            progress.display()


def loadData(args: argparse.Namespace, cursor: psycopg2.extensions.cursor):
    """Format documents in directories specified by ``args`` and uploads them to ``cursor``.

    Parameters
    ----------
    args : argparse.Namespace
        A ``Namespace`` containing data specified through argparse. It must include:

        - document_directory (:obj:`pathlib.Path`): The path to a directory containing each
            document ``{id}.pdf`` in a subdirectory of name ``{id}``
        - transcript_directory (:obj:`pathlib.Path`): The path to a directory containing each
            transcript with the name ``{id}_{page}.txt``
        - metadata_directory (:obj:`pathlib.Path`): The path to a directory containing each
            metadata file with the name ``{id}with_added_metadata.json``
        - analysis_directory (:obj:`pathlib.Path`): The path to a directory containing each
            LLM analysis with the name ``{id}.json``

    cursor : psycopg2.extensions.cursor
        A ``cursor`` object referencing the desired ``psycopg2`` session to use when uploading
        data.
    """
    print("parsing movies")
    # ids: list[str] = [fname[:-24] for fname in os.listdir(args.metadata_directory)]

    ids: list[AnyStr] = list(iglob(str(args.document_directory) + "/*"))
    transcripts: list[AnyStr] = list(
        iglob(str(args.transcript_directory) + "/*_p*.txt")
    )

    id_pools: np.ndarray[list[AnyStr]] = np.array_split(ids, args.thread_count)
    threads: list[Thread] = []
    # iterate through every document id that contains metadata

    progress_bar: tqdm = tqdm()
    progress_bar.total = len(ids)
    progress_bar.smoothing = 0

    for i in range(args.thread_count):
        thread: Thread = Thread(
            target=_process_ids,
            args=[args, cursor, id_pools[i], transcripts, progress_bar],
        )
        thread.start()
        threads.append(thread)

    for thread in threads:
        thread.join()

    #     # insert document data
    #     cursor.execute(
    #         "INSERT INTO documents ( \
    #             id, \
    #             copyright_year, \
    #             studio, \
    #             title, \
    #             uploaded_time \
    #         ) VALUES (%s, %s, %s, %s, %s) \
    #         ON CONFLICT DO NOTHING;",
    #         (
    #             document_id,
    #             metadata["date"],
    #             metadata["producer"],
    #             formatted_analysis["title"],
    #             datetime.datetime.now(),
    #         ),
    #     )

    #     # insert actors, if any are present
    #     if formatted_analysis["actors"]:
    #         psycopg2.extras.execute_batch(
    #             cursor,
    #             "INSERT INTO actors ( \
    #                 name \
    #             ) VALUES (%s) \
    #             ON CONFLICT DO NOTHING;",
    #             [[actor] for actor in formatted_analysis["actors"]],
    #         )

    #         psycopg2.extras.execute_batch(
    #             cursor,
    #             "INSERT INTO has_actor ( \
    #                 document_id, \
    #                 actor_name, \
    #                 role \
    #             ) VALUES (%s, %s, %s) \
    #             ON CONFLICT DO NOTHING;",
    #             [(document_id, actor, None) for actor in formatted_analysis["actors"]],
    #         )

    #     # insert transcripts, if any are present
    #     if transcript_data:
    #         psycopg2.extras.execute_batch(
    #             cursor,
    #             "INSERT INTO transcripts ( \
    #                 document_id, \
    #                 page_number, \
    #                 content \
    #             ) VALUES (%s, %s, %s) \
    #             ON CONFLICT DO NOTHING;",
    #             transcript_data,
    #         )

    # cursor.execute("REFRESH MATERIALIZED VIEW text_search_view;")


def main(argv=None):
    """Upload data to the database specified in ``.env``."""
    args = parser.parse_args(argv)
    load_dotenv()

    os.makedirs(args.outdir, exist_ok=True)

    if (args.outdir / "failed.txt").exists():
        os.remove(args.outdir / "failed.txt")

    db_connection: psycopg2.extensions.connection = psycopg2.connect(
        host=os.environ["SQL_HOST"],
        port=os.environ["SQL_PORT"],
        dbname=os.environ["SQL_DBNAME"],
        user=os.environ["SQL_USER"],
        password=os.environ["SQL_PASSWORD"],
    )

    with db_connection.cursor() as cursor:
        # try:
        #     create_tables(cursor)
        #     db_connection.commit()
        # except Exception:
        #     print("tables already exist!")
        #     db_connection.rollback()

        loadData(args, cursor)
        db_connection.commit()

    db_connection.close()


if __name__ == "__main__":
    main()
