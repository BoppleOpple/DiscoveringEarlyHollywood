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


def valid_id(doc_id: str) -> bool:
    return re.fullmatch(r"\w\d{4}\w\d{5}", doc_id) is not None


def _search_signature_from_args() -> str:
    """Stable signature of active filters, excluding page number."""
    keys: list[str] = sorted(
        k for k in request.args.keys() if k not in {"page", "replay_search_id"}
    )
    return "&".join(
        f"{key}={(request.args.get(key) or '').strip()}"
        for key in keys
        if (request.args.get(key) or "").strip() != ""
    )


@app.context_processor
def utility_processor():
    """A ``Flask.context_processor`` that provides helper functions to template."""

    def modify_args_on_page(page: str, args: dict):
        """A helper that modifies a page's URL arguments to include different or new values.

        Parameters
        ----------
        page : str
            The Flask page to which arguments are appended
        args : dict
            A ``dict`` containing the URL arguments to modify or add

        Examples
        --------
        >>> # executing on page ``http://localhost:3388/results?query=How+to+Perform+Electrolysis&page=1``
        >>> modify_args_on_page("results", {"page": 2}})
        "http://localhost:3388/results?query=How+to+Perform+Electrolysis&page=2"
        """  # noqa E501
        return url_for(page, **{**request.args, **args})

    return dict(modify_args_on_page=modify_args_on_page, ceil=math.ceil)


@app.route("/")
def index():
    search = request.args.get("search", "")
    genre = request.args.get("genre", None)
    year_min: int = request.args.get("year_min", 1912, type=int)
    year_max: int = request.args.get("year_max", 1928, type=int)
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
        dbConnection, query, page, resultsPerPage=RESULTS_PER_PAGE
    )

    headlines: dict[str, str] = db_utils.get_headlines(dbConnection, results, query)
    current_search_id: int | None = None
    viewed_doc_ids: set[str] = set()

    user_name = session.get("user")
    # If the user is signed in, append to their search history
    if user_name:
        viewed_doc_ids = db_utils.get_viewed_document_ids(dbConnection, user_name)
        replay_search_id: int | None = request.args.get("replay_search_id", type=int)
        replay_entry = (
            db_utils.get_search_history_entry(dbConnection, user_name, replay_search_id)
            if replay_search_id is not None
            else None
        )

        # load from previous search if it is a repeat
        if replay_entry:
            current_search_id = replay_entry["id"]
            session["last_search_signature"] = _search_signature_from_args()
            session["last_search_id"] = current_search_id
        else:
            # Only log when explicit filters are present; avoid logging blank "/" loads.
            signature: str = _search_signature_from_args()
            if signature:
                if signature == session.get("last_search_signature"):
                    current_search_id = session.get("last_search_id")
                else:
                    current_search_id = db_utils.log_search(
                        dbConnection,
                        user_name=user_name,
                        start_year=year_min if "year_min" in request.args else None,
                        end_year=year_max if "year_max" in request.args else None,
                        studio=None,  # TODO wire studio filter when available
                        actors=[],
                        genres=[genre] if genre else [],
                        tags=[],
                        search_text=search,
                    )
                    session["last_search_signature"] = signature
                    session["last_search_id"] = current_search_id

    return render_template(
        "index.html",
        documents=results,
        headlines=headlines,
        search=search,
        genre=genre,
        year_min=year_min,
        year_max=year_max,
        page=page,
        num_results=num_results,
        results_per_page=RESULTS_PER_PAGE,
        viewed_doc_ids=viewed_doc_ids,
        current_search_id=current_search_id,
        current_results_path=request.full_path.rstrip("?"),
    )


@app.route("/document/<doc_id>")
def document_detail(doc_id):
    document = db_utils.get_document(dbConnection, doc_id)
    if not document:
        flash("Document not found", "error")
        return redirect(url_for("index"))

    # if the user is logged in, add the document to the user's viewing history
    user_name = session.get("user")
    if user_name:
        request_search_id: int | None = request.args.get("search_id", type=int)
        valid_search_id: int | None = None
        if request_search_id is not None:
            search_entry = db_utils.get_search_history_entry(
                dbConnection, user_name, request_search_id
            )
            valid_search_id = search_entry["id"] if search_entry else None

        db_utils.log_view(
            dbConnection,
            user_name=user_name,
            document_id=doc_id,
            search_id=valid_search_id,
        )

    back_url = url_for("index")
    return_to = request.args.get("return_to", "")
    # prevents links which would redirect to outside the website
    if return_to.startswith("/") and not return_to.startswith("//"):
        back_url = return_to

    return render_template("document_detail.html", document=document, back_url=back_url)


@app.route("/history")
def view_history():
    user_name = session.get("user")
    if not user_name:
        flash("Log in to view your history.", "error")
        return redirect(url_for("index"))

    searches = db_utils.get_search_history(dbConnection, user_name)
    history = db_utils.get_view_history(dbConnection, user_name)

    return render_template("view_history.html", history=history, searches=searches)


@app.route("/history/replay/<int:search_id>")
def replay_search(search_id):
    user_name = session.get("user")
    if not user_name:
        flash("Log in to replay a saved search.", "error")
        return redirect(url_for("index"))

    search_entry = db_utils.get_search_history_entry(dbConnection, user_name, search_id)
    if not search_entry:
        flash("Saved search not found.", "error")
        return redirect(url_for("view_history"))

    query_args: dict[str, str | int] = {"replay_search_id": search_id}

    if search_entry["search_text"]:
        query_args["search"] = search_entry["search_text"]
    if search_entry["start_year"] is not None:
        query_args["year_min"] = search_entry["start_year"]
    if search_entry["end_year"] is not None:
        query_args["year_max"] = search_entry["end_year"]
    if search_entry["genres"]:
        first_genre = search_entry["genres"].split(",")[0].strip()
        if first_genre:
            query_args["genre"] = first_genre

    return redirect(url_for("index", **query_args))


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


@app.route("/history/download")
def download_history():
    user_name = session.get("user")
    if not user_name:
        flash("Log in to download your history.", "error")
        return redirect(url_for("index"))

    history = db_utils.get_view_history(dbConnection, user_name)

    # Create CSV
    output = StringIO()
    writer = csv.writer(output)
    writer.writerow(
        ["Title", "Year", "Document Type", "Description", "Viewed Date", "Search Text"]
    )
    for doc in history:
        writer.writerow(
            [
                doc["title"],
                doc["year"],
                doc["documentType"],
                doc["description"],
                doc["viewedDate"],
                doc["searchText"] or "",
            ]
        )

    # Create response
    csv_bytes = output.getvalue().encode("utf-8")
    buffer = BytesIO(csv_bytes)
    buffer.seek(0)

    return send_file(
        buffer,
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
        return jsonify({"errors": errors}), 400

    session["user"] = username

    flash(f"Welcome back, {username}!", "success")
    return jsonify({"success": True})


@app.route("/signup", methods=["POST"])
def signup():
    username = request.form.get("full_name", "").strip()
    email = request.form.get("email", "").strip()
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

    # Email validation
    if not email:
        errors.append("Email is required.")
    elif db_auth.email_exists(dbConnection, email):
        errors.append("Email already registered.")

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
        return jsonify({"errors": errors}), 400

    password_hash = generate_password_hash(password)
    success_signup = db_auth.create_user(dbConnection, username, email, password_hash)

    if not success_signup:
        return jsonify({"errors": ["Could not create account. Please try again."]}), 400

    session["user"] = username

    flash(f"Account created! Welcome, {username}.", "success")
    return jsonify({"success": True})


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
    return redirect(url_for("document_detail", doc_id=doc_id))


if __name__ == "__main__":
    app.run(debug=True, port=5000)
