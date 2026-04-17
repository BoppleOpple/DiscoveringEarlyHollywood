"""A CLI program that uploads LoC data from the local filesystem to a PostgreSQL database."""

import argparse
import datetime
import json
import numpy as np
import os

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
parser.add_argument("--wipe", required=False, action="store_true")

progress_sem: Semaphore = Semaphore()


def wipe(cursor: psycopg2.extensions.cursor):
    """Given a ``psycopg2`` cursor, delete all SQL relations.

    Parameters
    ----------
    cursor : psycopg2.extensions.cursor
        The ``psycopg2`` ``cursor`` object with which the query is performed
    """
    print("Removing relations from database")
    with open("dbSetup/dropAll.sql", "r") as f:
        cursor.execute(f.read())


def create_tables(cursor: psycopg2.extensions.cursor):
    """Given a ``psycopg2`` cursor, create all SQL relations.

    Parameters
    ----------
    cursor : psycopg2.extensions.cursor
        The ``psycopg2`` ``cursor`` object with which the query is performed
    """
    print("Adding relations to database")
    with open("dbSetup/tableDefinitions.sql", "r") as f:
        cursor.execute(f.read())


def string_is_none(s: str | None) -> bool:
    # if s is not a string (i.e. dict, list, None) count it as None
    if not isinstance(s, str):
        return True
    elif s.lower() in ["null", "none", "n/a"]:
        return True
    else:
        return False


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

            if "title" in analysis_obj:
                if not string_is_none(analysis_obj["title"]):
                    formatted_analysis["title"] = analysis_obj["title"]

            if "producer" in analysis_obj:
                if not string_is_none(analysis_obj["producer"]):
                    formatted_analysis["producer"] = analysis_obj["producer"]

            if "writer" in analysis_obj:
                if not string_is_none(analysis_obj["writer"]):
                    formatted_analysis["writer"] = analysis_obj["writer"]

            if "production_company" in analysis_obj:
                if not string_is_none(analysis_obj["production_company"]):
                    formatted_analysis["production_company"] = analysis_obj[
                        "production_company"
                    ]

            if "reels" in analysis_obj:
                try:
                    formatted_analysis["reels"] = int(analysis_obj["reels"])
                except TypeError:
                    formatted_analysis["reels"] = None

            if "series" in analysis_obj:
                if not string_is_none(analysis_obj["series"]):
                    formatted_analysis["series"] = analysis_obj["series"]

            if "genres" in analysis_obj:
                formatted_analysis["genres"] = analysis_obj["genres"]

            # "characters" is a list of dicts
            if "characters" in analysis_obj:
                # these are the fields that *should* be present (but are not necessarily)
                expected_fields: list[str] = [
                    "character_name",
                    "character_description",
                    "actor",
                ]

                # for every dict in the JSON list
                for location in analysis_obj["characters"]:
                    # assume it is invalid until it contains valid data
                    valid: bool = False
                    for field in expected_fields:
                        if field in location and not string_is_none(location[field]):
                            valid = True
                            break

                    # if it contained valid data, create an entry
                    if valid:
                        formatted_analysis["characters"].append({})

                        for field in expected_fields:
                            if field in location and not string_is_none(
                                location[field]
                            ):
                                formatted_analysis["characters"][-1][field] = location[
                                    field
                                ]
                            else:
                                formatted_analysis["characters"][-1][field] = None

            # "locations" is a list of dicts
            if "locations" in analysis_obj:
                # these are the fields that *should* be present (but are not necessarily)
                expected_fields: list[str] = ["location_name", "location_description"]

                # for every dict in the JSON list
                for location in analysis_obj["locations"]:
                    # assume it is invalid until it contains valid data
                    valid: bool = False
                    for field in expected_fields:
                        if field in location and not string_is_none(location[field]):
                            valid = True
                            break

                    # if it contained valid data, create an entry
                    if valid:
                        formatted_analysis["locations"].append({})

                        for field in expected_fields:
                            if field in location and not string_is_none(
                                location[field]
                            ):
                                formatted_analysis["locations"][-1][field] = location[
                                    field
                                ]
                            else:
                                formatted_analysis["locations"][-1][field] = None

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
            filter(
                lambda filepath: Path(filepath).name.startswith(document_id),
                transcripts,
            )
        )

        analysis_file: Path = args.analysis_directory / f"{document_id}.json"

        metadata: dict = None
        if metadata_file.exists():
            with open(metadata_file, "r") as metadata_json:
                metadata = json.load(metadata_json)
                del metadata["text"]
        else:
            metadata = {
                "date": None,
                "producer": [None],
            }

        transcript_data: list = []
        for fname in relevant_transcripts:
            page: int = int(fname[:-4].split("_p")[-1])

            with open(fname, "r") as transcript_file:
                transcript_data.append((document_id, page, transcript_file.read()))

        analysis: dict = None
        if analysis_file.exists():
            with open(analysis_file, "r") as analysis_json:
                analysis = format_llm_analysis(analysis_json.read(), document_id)
        else:
            analysis = format_llm_analysis(None, document_id)

        if analysis["failed"]:
            with open(args.outdir / "failed.txt", "a") as f:
                f.write(document_id + "\n")

        # insert document data
        cursor.execute(
            "INSERT INTO documents ( \
                id, \
                copyright_year, \
                studio, \
                title, \
                producer, \
                writer, \
                reel_count, \
                series, \
                uploaded_by, \
                uploaded_time \
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) \
            ON CONFLICT DO NOTHING;",
            (
                document_id,
                metadata["date"],
                metadata["producer"][0],
                analysis["title"],
                analysis["producer"],
                analysis["writer"],
                analysis["reels"],
                analysis["series"],
                None,
                datetime.datetime.now(),
            ),
        )

        # insert characters, if any are present
        if analysis["characters"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO actors ( \
                    name \
                ) VALUES (%s) \
                ON CONFLICT DO NOTHING;",
                [
                    [character["actor"]]
                    for character in analysis["characters"]
                    if character["actor"] is not None
                ],
            )

            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_character ( \
                    document_id, \
                    actor_name, \
                    character_name, \
                    character_description \
                ) VALUES (%s, %s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                [
                    (
                        document_id,
                        character["actor"],
                        character["character_name"],
                        character["character_description"],
                    )
                    for character in analysis["characters"]
                ],
            )

        # insert genres, if any are present
        if analysis["genres"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO genres ( \
                    genre \
                ) VALUES (%s) \
                ON CONFLICT DO NOTHING;",
                [[genre] for genre in analysis["genres"]],
            )

            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_genre ( \
                    document_id, \
                    genre \
                ) VALUES (%s, %s) \
                ON CONFLICT DO NOTHING;",
                [
                    (
                        document_id,
                        genre,
                    )
                    for genre in analysis["genres"]
                ],
            )

        # insert locations, if any are present
        if analysis["locations"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_location ( \
                    document_id, \
                    location, \
                    description \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                [
                    (
                        document_id,
                        location["location_name"],
                        location["location_description"],
                    )
                    for location in analysis["locations"]
                ],
            )

        # insert transcripts, if any are present
        if transcript_data:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO transcripts ( \
                    document_id, \
                    page_number, \
                    content \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                transcript_data,
            )

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

    cursor.execute("REFRESH MATERIALIZED VIEW text_search_view;")


def main(argv=None):
    """Upload data to the database specified in ``.env``."""
    args = parser.parse_args(argv)
    load_dotenv()

    if args.wipe:
        print(
            "WARNING: The `--wipe` flag has been passed. This will erase all tables and data"
        )
        print("from the database before reinstating the schema and uploading data.")
        print("Are you sure you want to continue? [y/N]")
        response: str = input()

        if not response.lower().startswith("y"):
            print("Exiting...")
            exit(0)

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
        if args.wipe:
            wipe(cursor)
            db_connection.commit()

        try:
            create_tables(cursor)
            db_connection.commit()
        except Exception as e:
            print(e)
            db_connection.rollback()

        loadData(args, cursor)
        db_connection.commit()

    db_connection.close()


if __name__ == "__main__":
    main()
