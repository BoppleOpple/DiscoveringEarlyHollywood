import os
import tempfile
import math
from flask import (
    Flask,
    render_template,
    request,
    redirect,
    url_for,
    session,
    jsonify,
    flash,
)
import psycopg2
import pytesseract
from flask_cors import CORS
from PIL import Image
from werkzeug.utils import secure_filename
from pdf2image import convert_from_path
from dotenv import load_dotenv

import db_utils
from datatypes import Document, Query

load_dotenv()
app = Flask(__name__, template_folder="templates")

CORS(app)
app.secret_key = os.environ["FLASK_SECRET"] or os.urandom(20)

dbConnection = psycopg2.connect(
    host=os.environ["SQL_HOST"],
    port=os.environ["SQL_PORT"],
    dbname=os.environ["SQL_DBNAME"],
    user=os.environ["SQL_USER"],
    password=os.environ["SQL_PASSWORD"],
)

pytesseract.pytesseract.tesseract_cmd = (
    r"C:\Program Files\Tesseract-OCR\tesseract.exe"  # Adjust this path as needed
)
# Adjust this path as needed
poppler_path = r"C:\Users\shtgu\Documents\CodingPackages\poppler-24.08.0\Library\bin"

# TODO manage globals in a better way, will look into standard practice for this
RESULTS_PER_PAGE = 20
UPLOAD_FOLDER = "backend/static/img"
EDITS_FOLDER = "backend/static/edits"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg", "pdf"}
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["EDITS_FOLDER"] = EDITS_FOLDER


def allowed_file(filename: str):
    """Checks if a file is uploadable based on file extension."""
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


def print_kwargs(**kwargs):
    """Prints keyword arguments to the server console."""
    print(kwargs)


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

    return dict(modify_args_on_page=modify_args_on_page)


@app.route("/")
def home():
    """Register a new route for the ``home`` page of the app."""
    # earliest_year = 1887
    earliest_year = 1912
    current_year = 1928
    years = list(range(earliest_year, current_year + 1))
    return render_template("home.html", years=years, documents=[])


@app.route("/history")
def history():
    """Register a new route for the history page of the app."""
    # viewed_docs_ids = session.get("viewed_documents", [])
    viewed_documents = []  # Fetch from client-side if needed
    return render_template("history.html", documents=viewed_documents)


@app.route("/clear_history")
def clear_history():
    """Register a new route for clearing viewing history."""
    session.pop("viewed_documents", None)
    return redirect(url_for("history"))


@app.route("/remove_from_history/<int:doc_id>")
def remove_from_history(doc_id):
    """Register a new route for removing specific documents from viewing history."""
    if "viewed_documents" in session:
        session["viewed_documents"] = [
            id for id in session["viewed_documents"] if id != doc_id
        ]
        session.modified = True
    return redirect(url_for("history"))


@app.route("/upload", methods=["GET"])
def upload_page():
    """Register a new route for the ``upload`` page of the app."""
    return render_template("upload.html")


@app.route("/process_image", methods=["POST"])
def process_image():
    """Register a new route for the processing of uploaded files."""
    uploaded_files = request.files.getlist("file")

    if not uploaded_files or all(f.filename == "" for f in uploaded_files):
        flash("No files selected")
        return redirect(url_for("upload_page"))

    all_texts = []
    image_filenames = []

    for file in uploaded_files:
        filename = secure_filename(file.filename)
        if filename == "":
            continue

        ext = os.path.splitext(filename)[1].lower()

        if ext == ".pdf":
            tmp_fd, tmp_path = tempfile.mkstemp(suffix=".pdf")
            os.close(tmp_fd)  # Close the open file descriptor
            file.save(tmp_path)  # Save uploaded PDF to that path
            try:
                images = convert_from_path(
                    tmp_path, poppler_path=poppler_path
                )  # Only needed if Poppler isn't in PATH
                if len(images) > 1:
                    images.pop()

                for i, image in enumerate(images):
                    image_filename = f"{os.path.splitext(filename)[0]}_page_{i + 1}.jpg"
                    image_path = os.path.join(
                        app.config["UPLOAD_FOLDER"], image_filename
                    )
                    image.save(image_path)
                    text = pytesseract.image_to_string(image)
                    all_texts.append((image_filename, text))
                    image_filenames.append(image_filename)

            except Exception as e:
                flash(f"Failed to process PDF: {str(e)}")
                return redirect(url_for("upload_page"))

            finally:
                os.remove(tmp_path)  # Clean up temp PDF file

        elif allowed_file(filename):
            filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(filepath)

            try:
                text = pytesseract.image_to_string(Image.open(filepath))
                all_texts.append((filename, text))
                image_filenames.append(filename)
            except Exception as e:
                flash(f"Failed to process image {filename}: {str(e)}")
            finally:
                os.remove(filepath)

        else:
            flash(f"Unsupported file type: {filename}")

    if not all_texts:
        flash("No valid files processed.")
        return redirect(url_for("upload_page"))

    return render_template("OCRresults.html", results=all_texts)


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


@app.route("/view_document/<doc_id>")
def view_document(doc_id):
    """Register a new route for the ``view_document`` page of the app."""
    document: Document = db_utils.get_document(dbConnection, doc_id)

    if not document:
        return "Document not found", 404

    return render_template("view_document.html", document=document)


@app.route("/upload_pdf", methods=["GET", "POST"])
def upload_pdf():
    """Register a new route for the ``upload_pdf`` page of the app."""
    return render_template("upload_pdf.html")


if __name__ == "__main__":
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(EDITS_FOLDER, exist_ok=True)
    app.run(host="0.0.0.0", port=3388, debug=True)
