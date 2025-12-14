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
    default="./data/Hollywood_Copyright_Materials_Base_Transcriptions",
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
    default="./data/no_shot_gpt_analysis",
    type=Path,
)


def createTables(cursor: psycopg2.extensions.cursor):
    """Given a ``psycopg2`` cursor, create all SQL relations.

    Parameters
    ----------
    cursor : psycopg2.extensions.cursor
        The ``psycopg2`` ``cursor`` object with which the query is performed
    """
    print("Adding relations to database")
    with open("tableDefinitions.sql", "r") as f:
        cursor.execute(f.read())


def formatLLMAnalysis(analysis: dict) -> dict:
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
    formattedAnalysis : dict
        A ``dict`` of the form::

            {
                "title": str,
                "actors": list[str],
                "failed": bool
            }
    """
    formattedAnalysis: dict = {"title": None, "actors": [], "failed": False}
    if analysis:
        try:
            responses = analysis["response"].split("```json")

            responseList = []

            for response in responses:
                # locate the JSON content
                minCharacter: int = min(
                    response.index("{") if "{" in response else len(response),
                    response.index("[") if "[" in response else len(response),
                )
                maxCharacter: int = max(
                    response.rindex("}") if "}" in response else 0,
                    response.rindex("]") if "]" in response else 0,
                )

                # ignore the string if there are no JSON opening or closing brackets
                if minCharacter == len(response) or maxCharacter == 0:
                    continue

                cleanedResponse, n = re.subn(
                    r",(?=\s*[\}\]])",
                    "",
                    response[minCharacter : maxCharacter + 1],  # noqa E203
                )

                # LLM allows comments in JSON files
                cleanedResponse, n = re.subn(r"//.*\n", "", cleanedResponse)

                # account for multiple documents being stored in the same JSON object
                responseObject = json.loads(cleanedResponse)
                if type(responseObject) is dict:
                    if "Films" not in responseObject:
                        responseList.append(responseObject)
                    else:
                        responseList.extend(responseObject["Films"])
                elif type(responseObject) is list:
                    responseList.extend(responseObject)

            if len(responseList) == 1:
                responseDict = responseList[0]
                # parse "Title" field
                if "Title" in responseDict:
                    formattedAnalysis["title"] = responseDict["Title"]
                else:
                    print(
                        f"Analysis of {analysis["File_Name"]} is missing key 'Title': {responseDict}"  # noqa E501
                    )

                # parse "Actors" field
                if "Actors" in responseDict:
                    actors = responseDict["Actors"]

                    # no actors can be represented as "N/A", ["N/A"], or []
                    if type(actors) is list:
                        if "N/A" not in actors:
                            formattedAnalysis["actors"] = actors
                        else:
                            formattedAnalysis["actors"] = []

                    elif type(actors) is str:
                        if actors != "N/A":
                            # Assume the string contains the actor's name
                            formattedAnalysis["actors"] = [actors]
                        else:
                            formattedAnalysis["actors"] = []
            else:
                formattedAnalysis["failed"] = True
                print(
                    f"Analysis of {analysis["File_Name"]} includes {len(responseList)} documents (expected 1)"  # noqa E501
                )

        except json.decoder.JSONDecodeError as e:
            formattedAnalysis["failed"] = True
            print(f"Error while decoding {analysis["File_Name"]}:")
            print(e)
    else:
        formattedAnalysis["failed"] = True

    return formattedAnalysis


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
        metadataFile: Path = (
            args.metadata_directory / f"{document_id}with_added_metadata.json"
        )
        analysisFile: Path = args.analysis_directory / f"{document_id}.json"

        metadata: dict = None
        with open(metadataFile, "r") as metadataJson:
            metadata = json.load(metadataJson)

        transcriptData: list = []
        for page, content in enumerate(metadata["text"]):
            transcriptData.append((document_id, page, content))

        analysis: dict = None
        if analysisFile.exists():
            with open(analysisFile, "r") as analysisJson:
                analysis = json.load(analysisJson)

        formattedAnalysis = formatLLMAnalysis(analysis)

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
                formattedAnalysis["title"],
                datetime.datetime.now(),
            ),
        )

        # insert actors, if any are present
        if formattedAnalysis["actors"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO actors ( \
                    name \
                ) VALUES (%s) \
                ON CONFLICT DO NOTHING;",
                [[actor] for actor in formattedAnalysis["actors"]],
            )

            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_actor ( \
                    document_id, \
                    actor_name, \
                    role \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                [(document_id, actor, None) for actor in formattedAnalysis["actors"]],
            )

        # insert transcripts, if any are present
        if transcriptData:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO transcripts ( \
                    document_id, \
                    page_number, \
                    content \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                transcriptData,
            )


def main(argv=None):
    """Upload data to the database specified in ``.env``."""
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
            print("tables already exist!")
            dbConnection.rollback()

        loadData(args, cursor)
        dbConnection.commit()

    dbConnection.close()


if __name__ == "__main__":
    main()
