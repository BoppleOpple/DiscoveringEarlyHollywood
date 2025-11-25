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
	description="A program that uploads data to the Discovering Early Hollywood PostgreSQL database",
	epilog="Willy N' Gang, 2025"
)

parser.add_argument("-d", "--document-directory", default="./data/film_copyright")
parser.add_argument("-t", "--transcript-directory", default="./data/Hollywood_Copyright_Materials_Base_Transcriptions")
parser.add_argument("-m", "--metadata-directory", required=False, default="./data/cleaned_copyright_with_metadata")

parser.add_argument("-u", "--user", required=False, default="system")

def createTables(cursor: psycopg2.extras._cursor):
	print("Adding relations to database")
	with open("tableDefinitions.sql", "r") as f:
		cursor.execute(f.read())

def loadData(args: argparse.Namespace, cursor: psycopg2.extras._cursor):
	print("parsing movies")
	ids: list[str] = os.listdir(args.metadata_directory)
	movieData: list = []
	transcriptData: list = []

	for document_id in tqdm(ids):
		currentMovieEntry = (
			document_id,
			None,
			None,
			f"{args.document_directory}/{document_id}.pdf",
			None,
			datetime.datetime.now()
		)

		with open(f"{args.metadata_directory}/{document_id}") as metadataJson:
			metadata = json.load(metadataJson)

			currentMovieEntry[1] = metadata["date"]
			currentMovieEntry[2] = metadata["producer"]

			for page, content in enumerate(metadata["text"]):
				transcriptData.append((
					document_id,
					page,
					content
				))

		movieData.append(currentMovieEntry)

	print("Adding documents to database")
	psycopg2.extras.execute_batch(
		cursor,
		"INSERT INTO movies ( \
			id \
			copyright_year \
			studio \
			image_path \
			uploaded_time \
		) VALUES (%s, %s, %s, %s, %s) \
		ON CONFLICT DO NOTHING;",
		movieData,
		page_size=500
	)



	with dbConnection.cursor() as cursor:
		try:
			createTables(cursor)
			dbConnection.commit()
		except:
			print("error?")
			dbConnection.rollback()

		loadData(args, cursor)
		dbConnection.commit()

	dbConnection.close()

if __name__ == "__main__":
	main()
