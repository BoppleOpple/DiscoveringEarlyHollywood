import os
import math
from flask import (
    Flask,
    render_template,
    request,
    redirect,
    send_file,
    url_for,
    session,
    jsonify,
    flash,
)
import psycopg2
import csv
import re
import PIL
from werkzeug.utils import secure_filename
from werkzeug.security import generate_password_hash, check_password_hash
from dotenv import load_dotenv
from io import StringIO, BytesIO
from pathlib import Path
import pdf2image.pdf2image

from . import db_utils
from . import db_auth
from .datatypes import Document, Query

load_dotenv()
app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET"] or os.urandom(20)
app.config["UPLOAD_FOLDER"] = "uploads"
app.config["MAX_CONTENT_LENGTH"] = 50 * 1024 * 1024  # 50MB max file size

# Ensure upload folder exists
os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

if __name__ == "__main__":
    dbConnection = psycopg2.connect(
        host=os.environ["SQL_HOST"],
        port=os.environ["SQL_PORT"],
        dbname=os.environ["SQL_DBNAME"],
        user=os.environ["SQL_USER"],
        password=os.environ["SQL_PASSWORD"],
    )
    DOCUMENT_DIR: Path = Path(os.environ["DOCUMENT_DIR"])
    POPPLER_PATH: str = (
        os.environ["POPPLER_PATH"] if "POPPLER_PATH" in os.environ else None
    )
else:
    dbConnection = None
    DOCUMENT_DIR = None
    POPPLER_PATH = None

RESULTS_PER_PAGE = 20
DOCUMENTS = [
    {
        "id": 1,
        "title": "Sunset Boulevard",
        "description": "Copyright registration documents for the clas",
        "year": "1950",
        "documentType": "Copyright Registration",
        "fullDescription": "Sunset Boulevard is a classic American film noir ",
        "studio": "Paramount Pictures",
        "genre": "Film Noir / Drama",
        "director": "Billy Wilder",
        "actors": [
            "Gloria Swanson",
            "William Holden",
            "Erich von Stroheim",
            "Nancy Olson",
        ],
        "runtime": "110 minutes",
        "language": "English",
        "flags": [
            {
                "id": 1,
                "user": "Dr. Sarah Mitchell",
                "reason": "Document appears to have incorrect filing date. Should be s.",
                "date": "Nov 15, 2025",
            },
            {
                "id": 2,
                "user": "James Rodriguez",
                "reason": "Missing signature on page 3 of the copyright registration form.",
                "date": "Nov 12, 2025",
            },
            {
                "id": 3,
                "user": "Emily Chen",
                "reason": "Potential discrepancy in the listed production company name.",
                "date": "Nov 10, 2025",
            },
        ],
    },
    {
        "id": 2,
        "title": "The Jazz Singer",
        "description": "Historic copyright filing for the first feature-length.",
        "year": "1927",
        "documentType": "Copyright Registration",
        "fullDescription": "The Jazz Singer revolutionized the film industry as the ",
        "studio": "Warner Bros.",
        "genre": "Musical Drama",
        "director": "Alan Crosland",
        "actors": ["Al Jolson", "May McAvoy", "Warner Oland", "Eugenie Besserer"],
        "runtime": "88 minutes",
        "language": "English",
    },
    {
        "id": 3,
        "title": "Metropolis",
        "description": "Copyright documentation for Fritz Lang's influ.",
        "year": "1927",
        "documentType": "Copyright Registration",
        "fullDescription": "Metropolis is a groundbreaking German.",
        "studio": "UFA (Universum Film AG)",
        "genre": "Science Fiction / Drama",
        "director": "Fritz Lang",
        "actors": [
            "Brigitte Helm",
            "Gustav Fröhlich",
            "Alfred Abel",
            "Rudolf Klein-Rogge",
        ],
        "runtime": "153 minutes",
        "language": "Silent (German intertitles)",
        "flags": [
            {
                "id": 4,
                "user": "Prof. Heinrich Weber",
                "reason": "Translation of German text may be inaccurate.",
                "date": "Nov 14, 2025",
            },
            {
                "id": 5,
                "user": "Anna Foster",
                "reason": "Document quality is poor - some text illegible. May need.",
                "date": "Nov 8, 2025",
            },
        ],
    },
    {
        "id": 4,
        "title": "City Lights",
        "description": "Charlie Chaplin's romantic comedy-drama about.",
        "year": "1931",
        "documentType": "Copyright Registration",
        "fullDescription": "City Lights is a silent romantic comedy-.",
        "studio": "United Artists",
        "genre": "Romance / Comedy",
        "director": "Charlie Chaplin",
        "actors": [
            "Charlie Chaplin",
            "Virginia Cherrill",
            "Florence Lee",
            "Harry Myers",
        ],
        "runtime": "87 minutes",
        "language": "Silent with music",
    },
    {
        "id": 5,
        "title": "King Kong",
        "description": "Copyright records for .",
        "year": "1933",
        "documentType": "Copyright Registration",
        "fullDescription": "King Kong is a landmark .",
        "studio": "RKO Radio Pictures",
        "genre": "Adventure / Horror",
        "director": "Merian C. Cooper, Ernest B. Schoedsack",
        "actors": ["Fay Wray", "Robert Armstrong", "Bruce Cabot"],
        "runtime": "100 minutes",
        "language": "English",
    },
    {
        "id": 6,
        "title": "Gone with the Wind",
        "description": "Epic historical romance film set dura.",
        "year": "1939",
        "documentType": "Copyright Registration",
        "fullDescription": "Gone with the Wind is an .",
        "studio": "Metro-Goldwyn-Mayer",
        "genre": "Historical Romance / Drama",
        "director": "Victor Fleming",
        "actors": [
            "Vivien Leigh",
            "Clark Gable",
            "Olivia de Havilland",
            "Leslie Howard",
        ],
        "runtime": "238 minutes",
        "language": "English",
        "flags": [
            {
                "id": 6,
                "user": "Michael Thompson",
                "reason": "Multiple versions of this document exist in archive..",
                "date": "Nov 13, 2025",
            }
        ],
    },
]

# Mock history data
SEARCH_HISTORY = [
    {"id": 1, "query": "Sunset Boulevard", "date": "Nov 15, 2025"},
    {"id": 2, "query": "Charlie Chaplin", "date": "Nov 14, 2025"},
    {"id": 3, "query": "1927 films", "date": "Nov 12, 2025"},
    {"id": 4, "query": "film noir", "date": "Nov 10, 2025"},
    {"id": 5, "query": "Gone with the Wind", "date": "Nov 8, 2025"},
]

VIEW_HISTORY = [
    {
        "id": 1,
        "title": "Sunset Boulevard",
        "description": "Copyright registration documents for .",
        "year": "1950",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 15, 2025",
    },
    {
        "id": 4,
        "title": "City Lights",
        "description": "Charlie Chaplin's romantic comedy-drama .",
        "year": "1931",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 14, 2025",
    },
    {
        "id": 2,
        "title": "The Jazz Singer",
        "description": "Historic copyright filing .",
        "year": "1927",
        "documentType": "Copyright Registration",
        "viewedDate": "Nov 12, 2025",
    },
]


def valid_id(doc_id: str) -> bool:
    return re.fullmatch(r"\w\d{4}\w\d{5}", doc_id) is not None


@app.route("/")
def index():
    search = request.args.get("search", "")
    genre = request.args.get("genre", None)
    year_min: int = request.args.get("year_min", 1915, type=int)
    year_max: int = request.args.get("year_max", 1926, type=int)
    page: int = request.args.get("page", 1, type=int)

    # Filter documents
    # filtered_docs = db_utils.search_results(
    #    dbConnection,
    #    query,
    # )

    # if search:
    #    filtered_docs = [
    #        d
    #        for d in filtered_docs
    #         if search.lower() in d["title"].lower()
    #        or search.lower() in d["description"].lower()
    #    ]

    query: Query = Query(
        actors=[],  # TODO
        tags=[],  # TODO
        genres=[genre] if genre else [],
        keywords=list(
            filter(lambda s: s != "", search.split(" ")) if search else []
        ),  # TODO allow searching both titles and transcripts
        documentType=None,  # TODO
        studio=None,  # TODO
        copyrightYearRange=(year_min, year_max),  # TODO allow a start & end value
        durationRange=(None, None),  # TODO
    )

    num_results = db_utils.get_num_results(
        dbConnection,
        query,
    )

    results: list[Document] = db_utils.search_results(
        dbConnection,
        query,
        page,
    )

    return render_template(
        "index.html",
        documents=results,
        search=search,
        genre=genre,
        page=page,
        num_results=num_results,
        results_per_page=RESULTS_PER_PAGE,
    )


@app.route("/document/<doc_id>")
def document_detail(doc_id):
    document = db_utils.get_document(dbConnection, doc_id)
    if not document:
        flash("Document not found", "error")
        return redirect(url_for("index"))
    return render_template("document_detail.html", document=document)


@app.route("/history")
def view_history():
    return render_template(
        "view_history.html", history=VIEW_HISTORY, searches=SEARCH_HISTORY
    )


@app.route("/thumbnail/<doc_id>.jpg", methods=["GET"])
def thumbnail(doc_id):
    scale: float = request.args.get("scale", 1, type=float)
    page: int = request.args.get("page", 1, type=int)

    try:
        if not valid_id(doc_id):
            raise Exception("Not a valid doc_id")

        pdf_path: Path = DOCUMENT_DIR / doc_id / f"{doc_id}.pdf"

        if not pdf_path.exists():
            raise Exception("Not a valid document path")

        # get pdf info for page count and size
        info: dict = pdf2image.pdfinfo_from_path(pdf_path, poppler_path=POPPLER_PATH)

        page_size_split: list[str] = str(info["Page size"]).split(" ")
        page_size: tuple[float, float] = (
            float(page_size_split[0]) * scale,
            float(page_size_split[2]) * scale,
        )

        # clamp requested page
        page = max(1, min(page, info["Pages"]))

        image: PIL.Image.Image = pdf2image.convert_from_path(
            pdf_path=pdf_path,
            first_page=page,
            last_page=page,
            size=page_size,
            poppler_path=POPPLER_PATH,
        )[0]

        image_buffer: BytesIO = BytesIO()
        image.save(image_buffer, format="jpeg")

        # Create response
        image_buffer.seek(0)
        return send_file(
            image_buffer,
            mimetype="image/jpg",
            as_attachment=False,
            download_name=f"{doc_id}_page_{page}.jpg",
        )
    except Exception as e:
        print(e)
        return "Document not found", 404


@app.route("/document/<doc_id>/download", methods=["GET"])
def download_document(doc_id):
    """Download the document as a PDF if available, otherwise as a text transcript."""
    try:
        if not valid_id(doc_id):
            raise Exception("Not a valid doc_id")

        # First, try to serve the original PDF from the document store (image-based docs)
        if DOCUMENT_DIR is not None:
            pdf_path: Path = DOCUMENT_DIR / doc_id / f"{doc_id}.pdf"
            if pdf_path.exists():
                return send_file(
                    pdf_path,
                    mimetype="application/pdf",
                    as_attachment=True,
                    download_name=f"{doc_id}.pdf",
                )

        # Fallback: build a text file from transcript pages stored in the database
        document = db_utils.get_document(dbConnection, doc_id)
        if not document or not document.transcripts:
            raise Exception("No transcript content found for document")

        output = StringIO()
        for page, text in document.transcripts:
            output.write(f"--- Page {page} ---\n")
            output.write(text or "")
            output.write("\n\n")

        output.seek(0)

        return send_file(
            StringIO(output.getvalue()),
            mimetype="text/plain",
            as_attachment=True,
            download_name=f"{doc_id}.txt",
        )
    except Exception as e:
        print(e)
        flash("Unable to download document.", "error")
        return redirect(url_for("document_detail", doc_id=doc_id))


@app.route("/history/download")
def download_history():
    # Create CSV
    output = StringIO()
    writer = csv.writer(output)
    writer.writerow(["Title", "Year", "Document Type", "Description", "Viewed Date"])
    for doc in VIEW_HISTORY:
        writer.writerow(
            [
                doc["title"],
                doc["year"],
                doc["documentType"],
                doc["description"],
                doc["viewedDate"],
            ]
        )

    # Create response
    output.seek(0)
    return send_file(
        StringIO(output.getvalue()),
        mimetype="text/csv",
        as_attachment=True,
        download_name="viewing-history.csv",
    )


@app.route("/flagged")
def flagged_documents():
    flagged = db_utils.get_flagged(dbConnection)
    return render_template("flagged_documents.html", documents=flagged)


def print_kwargs(**kwargs):
    """Prints keyword arguments to the server console."""
    print(kwargs)


@app.route("/manager")
def documents_manager():
    search = request.args.get("search", "")
    query: Query = Query(
        actors=[],  # TODO
        tags=[],  # TODO
        keywords=list(
            filter(lambda s: s != "", search.split(" ")) if search else []
        ),  # TODO allow searching both titles and transcripts
        documentType=None,  # TODO
        studio=None,  # TODO
        durationRange=(None, None),  # TODO
    )

    docs = db_utils.search_results(dbConnection, query)
    if search:
        docs = [
            d
            for d in docs
            if search.lower() in d["title"].lower()
            or search.lower() in d.get("studio", "").lower()
            or search in d["year"]
        ]
    return render_template("documents_manager.html", documents=docs, search=search)


@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("full_name", "").strip()
    password = request.form.get("password", "")

    errors = []

    if not username or not password:
        errors.append("Full name and password are required.")

    if not errors:
        password_hash = db_auth.get_user_password_hash(dbConnection, username)
        if password_hash is None or not check_password_hash(password_hash, password):
            errors.append("Invalid name or password.")

    if errors:
        return render_template("index.html", errors=errors, open_modal=True)

    session["user"] = username
    session["user_name"] = username

    flash(f"Welcome back, {username}!", "success")
    return redirect(url_for("index"))


@app.route("/signup", methods=["POST"])
def signup():
    username = request.form.get("full_name", "").strip()
    password = request.form.get("password", "")
    confirm_password = request.form.get("confirm_password", "")

    errors = []

    # Username validation
    if not username:
        errors.append("Username is required.")
    elif not username.replace("_", "").isalnum():
        errors.append("Username must contain only letters, numbers, and underscores.")
    elif len(username) > 20:
        errors.append("Username must be 20 characters or less.")
    elif db_auth.user_exists(dbConnection, username):
        errors.append("An account with that username already exists.")

    # Password validation
    if not password:
        errors.append("Password is required.")
    else:
        if password != confirm_password:
            errors.append("Passwords do not match.")
        if len(password) < 8:
            errors.append("Password must be at least 8 characters.")
        if not any(c.isupper() for c in password):
            errors.append("Password must contain at least one uppercase letter.")
        if not any(c.islower() for c in password):
            errors.append("Password must contain at least one lowercase letter.")
        if not any(c.isdigit() for c in password):
            errors.append("Password must contain at least one number.")
        if not re.search(r"[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]", password):
            errors.append(
                "Password must contain at least one special character (!@#$%^&*()_+-=[]{}|;:,.<>?)."
            )

    if errors:
        return render_template(
            "index.html", errors=errors, open_modal=True, open_signup=True
        )

    password_hash = generate_password_hash(password)
    success = db_auth.create_user(dbConnection, username, password_hash)

    if not success:
        flash("Could not create account. Please try again.", "error")
        return redirect(url_for("index"))

    session["user"] = username
    session["user_name"] = username

    flash(f"Account created! Welcome, {username}.", "success")
    return redirect(url_for("index"))


@app.route("/logout")
def logout():
    session.clear()
    flash("You have been logged out.", "success")
    return redirect(url_for("index"))


@app.route("/upload", methods=["POST"])
def upload_documents():
    upload_type = request.form.get("upload_type", "zip")

    if upload_type == "zip":
        zip_file = request.files.get("zip_file")
        if zip_file:
            filename = secure_filename(zip_file.filename)
            zip_file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash(f'ZIP file "{filename}" uploaded successfully!', "success")
    else:
        document_file = request.files.get("document_file")
        metadata_file = request.files.get("metadata_file")
        transcript_file = request.files.get("transcript_file")

        files_uploaded = []
        if document_file:
            filename = secure_filename(document_file.filename)
            document_file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            files_uploaded.append(filename)
        if metadata_file:
            filename = secure_filename(metadata_file.filename)
            metadata_file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            files_uploaded.append(filename)
        if transcript_file:
            filename = secure_filename(transcript_file.filename)
            transcript_file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            files_uploaded.append(filename)

        if files_uploaded:
            flash(f'Files uploaded: {", ".join(files_uploaded)}', "success")

    return redirect(url_for("documents_manager"))


@app.route("/save_ocr_content", methods=["POST"])
def save_ocr_content():
    """Register a new route for storing transcript data to the database."""
    data = request.get_json()
    image_filename = data["image_filename"]
    updated_ocr_text = data["ocr_text"]

    try:
        ocr_file_path = os.path.join(
            app.config["EDITS_FOLDER"], image_filename + ".txt"
        )
        with open(ocr_file_path, "w", encoding="utf-8") as file:
            file.write(updated_ocr_text)
        return jsonify({"message": "OCR content saved successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/results", methods=["GET", "POST"])
def results():
    """Register a new route for the ``results`` page of the app."""

    textQuery: str = request.args.get("query", "")

    yearString: str = request.args.get("year", "")
    year: int = int(yearString) if yearString.isnumeric() else None

    page = request.args.get("page", 1, type=int)

    print_kwargs(**request.args)

    query: Query = Query(
        actors=[],  # TODO
        tags=[],  # TODO
        genres=[],  # TODO
        keywords=list(
            filter(lambda s: s != "", textQuery.split(" "))
        ),  # TODO allow searching both titles and transcripts
        documentType=None,  # TODO
        studio=None,  # TODO
        copyrightYearRange=(year, year),  # TODO allow a start & end value
        durationRange=(None, None),  # TODO
    )

    num_results = db_utils.get_num_results(
        dbConnection,
        query,
    )

    results: list[Document] = db_utils.search_results(
        dbConnection,
        query,
        page,
    )

    return render_template(
        "results.html",
        results=results,
        page=page,
        num_pages=math.ceil(num_results / RESULTS_PER_PAGE),
    )


@app.route("/remove", methods=["POST"])
def remove_documents():
    # Get selected document IDs from form
    doc_ids = request.form.getlist("selected_docs")

    # Mock removal - in production, remove from database
    flash(f"Removed {len(doc_ids)} document(s) from database", "success")
    return redirect(url_for("documents_manager"))


@app.route("/view_document/<doc_id>")
def view_document(doc_id):
    """Register a new route for the ``view_document`` page of the app."""
    document: Document = db_utils.get_document(dbConnection, doc_id)

    if not document:
        return "Document not found", 404

    return render_template("view_document.html", document=document)


@app.route("/flag/<doc_id>", methods=["POST"])
def flag_document(doc_id):
    # Mock flagging - in production, save to database
    flash("Document flagged for review", "success")
    return render_template(url_for("document_detail", doc_id=doc_id))


if __name__ == "__main__":
    app.run(debug=True, port=5000)
