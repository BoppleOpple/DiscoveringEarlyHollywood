"""A CLI program that uploads LoC data from the local filesystem to a PostgreSQL database."""

import os
import argparse
import json
import datetime
import re
from pathlib import Path
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

parser.add_argument(
    "-d", "--document-directory", default="./data/film_copyright", type=Path
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
def format_llm_analysis(analysis: dict) -> dict:
    """Form a ``dict`` from metadata extracted by an LLM.

    Parameters
    ----------
    analysis : dict
        A ``dict`` of the form::

            {
                "File_Name": A string containing the document id,
                "text": A string containing the transcript of the document,
                "response": A string containing:
                    - a JSON of a single analysis
                    - a JSON of an array of analyses
                    - a markdown block for either above JSON
                    - several markdown blocks for either above JSON
            }

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
    formatted_analysis: dict = {"title": None, "actors": [], "failed": False}
    if analysis:
        try:
            responses = analysis["response"].split("```json")

            response_list = []

            for response in responses:
                # locate the JSON content
                min_character: int = min(
                    response.index("{") if "{" in response else len(response),
                    response.index("[") if "[" in response else len(response),
                )
                max_character: int = max(
                    response.rindex("}") if "}" in response else 0,
                    response.rindex("]") if "]" in response else 0,
                )

                # ignore the string if there are no JSON opening or closing brackets
                if min_character == len(response) or max_character == 0:
                    continue

                cleaned_response, n = re.subn(
                    r",(?=\s*[\}\]])",
                    "",
                    response[min_character : max_character + 1],  # noqa E203
                )

                # LLM allows comments in JSON files
                cleaned_response, n = re.subn(r"//.*\n", "", cleaned_response)

                # account for multiple documents being stored in the same JSON object
                response_object = json.loads(cleaned_response)
                if type(response_object) is dict:
                    if "Films" not in response_object:
                        response_list.append(response_object)
                    else:
                        response_list.extend(response_object["Films"])
                elif type(response_object) is list:
                    response_list.extend(response_object)

            if len(response_list) == 1:
                response_dict = response_list[0]
                # parse "Title" field
                if "Title" in response_dict:
                    formatted_analysis["title"] = response_dict["Title"]
                else:
                    print(
                        f"Analysis of {analysis["File_Name"]} is missing key 'Title': {response_dict}"  # noqa E501
                    )

                # parse "Actors" field
                if "Actors" in response_dict:
                    actors = response_dict["Actors"]

                    # no actors can be represented as "N/A", ["N/A"], or []
                    if type(actors) is list:
                        if "N/A" not in actors:
                            formatted_analysis["actors"] = actors
                        else:
                            formatted_analysis["actors"] = []

                    elif type(actors) is str:
                        if actors != "N/A":
                            # Assume the string contains the actor's name
                            formatted_analysis["actors"] = [actors]
                        else:
                            formatted_analysis["actors"] = []
            else:
                formatted_analysis["failed"] = True
                print(
                    f"Analysis of {analysis["File_Name"]} includes {len(response_list)} documents (expected 1)"  # noqa E501
                )

        except json.decoder.JSONDecodeError as e:
            formatted_analysis["failed"] = True
            print(f"Error while decoding {analysis["File_Name"]}:")
            print(e)
    else:
        formatted_analysis["failed"] = True

    return formatted_analysis


def loadData(args: argparse.Namespace, cursor: psycopg2.extensions.cursor):
    """Format documents in directories specified by ``args`` and uploads them to ``cursor``.

    Parameters
    ----------
    args : argparse.Namespace
        A ``Namespace`` containing data specified through argparse. It must include:

        - document_directory (:obj:`pathlib.Path`): The path to a directory containing each
            document ``{id}.pdf`` in a subdirectory of name ``{id}``
        - transcript_directory (:obj:`pathlib.Path`): The path to a directory containing each
            transcript with the name ``{id}.txt``
        - metadata_directory (:obj:`pathlib.Path`): The path to a directory containing each
            metadata file with the name ``{id}with_added_metadata.json``
        - analysis_directory (:obj:`pathlib.Path`): The path to a directory containing each
            LLM analysis with the name ``{id}.json``

    cursor : psycopg2.extensions.cursor
        A ``cursor`` object referencing the desired ``psycopg2`` session to use when uploading
        data.
    """
    print("parsing movies")
    ids: list[str] = [fname[:-24] for fname in os.listdir(args.metadata_directory)]

    # iterate through every document id that contains metadata
    for document_id in tqdm(ids):
        metadata_file: Path = (
            args.metadata_directory / f"{document_id}with_added_metadata.json"
        )
        analysis_file: Path = args.analysis_directory / f"{document_id}.json"

        metadata: dict = None
        with open(metadata_file, "r") as metadata_json:
            metadata = json.load(metadata_json)

        transcript_data: list = []
        for page, content in enumerate(metadata["text"]):
            transcript_data.append((document_id, page, content))

        analysis: dict = None
        if analysis_file.exists():
            with open(analysis_file, "r") as analysis_json:
                analysis = json.load(analysis_json)

        formatted_analysis = format_llm_analysis(analysis)

        # insert document data
        cursor.execute(
            "INSERT INTO documents ( \
                id, \
                copyright_year, \
                studio, \
                title, \
                uploaded_time \
            ) VALUES (%s, %s, %s, %s, %s) \
            ON CONFLICT DO NOTHING;",
            (
                document_id,
                metadata["date"],
                metadata["producer"],
                formatted_analysis["title"],
                datetime.datetime.now(),
            ),
        )

        # insert actors, if any are present
        if formatted_analysis["actors"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO actors ( \
                    name \
                ) VALUES (%s) \
                ON CONFLICT DO NOTHING;",
                [[actor] for actor in formatted_analysis["actors"]],
            )

            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_actor ( \
                    document_id, \
                    actor_name, \
                    role \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                [(document_id, actor, None) for actor in formatted_analysis["actors"]],
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

    cursor.execute("REFRESH MATERIALIZED VIEW text_search_view;")


def main(argv=None):
    """Upload data to the database specified in ``.env``."""
    args = parser.parse_args(argv)
    load_dotenv()

    db_connection: psycopg2.extensions.connection = psycopg2.connect(
        host=os.environ["SQL_HOST"],
        port=os.environ["SQL_PORT"],
        dbname=os.environ["SQL_DBNAME"],
        user=os.environ["SQL_USER"],
        password=os.environ["SQL_PASSWORD"],
    )

    with db_connection.cursor() as cursor:
        try:
            create_tables(cursor)
            db_connection.commit()
        except Exception:
            print("tables already exist!")
            db_connection.rollback()

        loadData(args, cursor)
        db_connection.commit()

    db_connection.close()


if __name__ == "__main__":
    main()
