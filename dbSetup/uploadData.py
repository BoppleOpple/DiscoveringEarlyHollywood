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


def createTables(cursor: psycopg2.extras._cursor):
    print("Adding relations to database")
    with open("tableDefinitions.sql", "r") as f:
        cursor.execute(f.read())

def formatLLMAnalysis(analysis: dict) -> dict:
    formattedAnalysis: dict = {
        "title": None,
        "actors": [],
        "failed": False
    }
    if analysis:
        try:
            responses = analysis["response"].split("```json")

            responseList = []

            for response in responses:
                # locate the JSON content
                minCharacter: int = min(
                    response.index("{") if "{" in response else len(response),
                    response.index("[") if "[" in response else len(response)
                )
                maxCharacter: int = max(
                    response.rindex("}") if "}" in response else 0,
                    response.rindex("]") if "]" in response else 0
                )

                # ignore the string if there are no JSON opening or closing brackets
                if minCharacter == len(response) or maxCharacter == 0:
                    continue
                
                cleanedResponse, n = re.subn(r",(?=\s*[\}\]])", "", response[minCharacter:maxCharacter+1])
                
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
                    print(f"Analysis of {analysis["File_Name"]} is missing key 'Title': {responseDict}")

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
                print(f"Analysis of {analysis["File_Name"]} includes {len(responseList)} documents (expected 1)")

        except json.decoder.JSONDecodeError as e:
            formattedAnalysis["failed"] = True
            print(f"Error while decoding {analysis["File_Name"]}:")
            print(e)
    else:
        formattedAnalysis["failed"] = True
    
    return formattedAnalysis

def loadData(args: argparse.Namespace, cursor: psycopg2.extras._cursor):
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
                datetime.datetime.now()
            )
        )

        # insert actors, if any are present
        if formattedAnalysis["actors"]:
            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO actors ( \
                    name \
                ) VALUES (%s) \
                ON CONFLICT DO NOTHING;",
                [[actor] for actor in formattedAnalysis["actors"]]
            )

            psycopg2.extras.execute_batch(
                cursor,
                "INSERT INTO has_actor ( \
                    document_id, \
                    actor_name, \
                    role \
                ) VALUES (%s, %s, %s) \
                ON CONFLICT DO NOTHING;",
                [(document_id, actor, None) for actor in formattedAnalysis["actors"]]
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
                transcriptData
            )

    # print("Adding documents to database")
    # psycopg2.extras.execute_batch(
    #     cursor,
    #     "INSERT INTO documents ( \
    #         id, \
    #         copyright_year, \
    #         studio, \
    #         title, \
    #         uploaded_time \
    #     ) VALUES (%s, %s, %s, %s, %s) \
    #     ON CONFLICT DO NOTHING;",
    #     tqdm(movieData),
    #     page_size=500,
    # )

    # print("Adding transcripts to database")
    # psycopg2.extras.execute_batch(
    #     cursor,
    #     "INSERT INTO transcripts ( \
    #         document_id, \
    #         page_number, \
    #         content \
    #     ) VALUES (%s, %s, %s) \
    #     ON CONFLICT DO NOTHING;",
    #     tqdm(transcriptData),
    #     page_size=500,
    # )


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
