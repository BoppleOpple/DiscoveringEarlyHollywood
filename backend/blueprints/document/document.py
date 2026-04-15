import pdf2image.pdf2image
import psycopg2
import PIL
import re

from flask import (
    Blueprint,
    flash,
    redirect,
    url_for,
    session,
    request,
    send_file,
    current_app,
    render_template,
)
from pathlib import Path
from io import BytesIO

from ... import db_utils

document = Blueprint("document", __name__, url_prefix="/document")


def _valid_id(doc_id: str) -> bool:
    if doc_id is None:
        return False
    return re.fullmatch(r"\w\d{4}\w\d{5}", doc_id) is not None


def _bool_string(s: str) -> bool:
    if s is None:
        return False
    return s.lower() == "true"


@document.route("/<doc_id>")
def document_detail(doc_id):
    document = db_utils.get_document(db_utils.get_db_connection(), doc_id)
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
                db_utils.get_db_connection(), user_name, request_search_id
            )
            valid_search_id = search_entry["id"] if search_entry else None

        db_utils.log_view(
            db_utils.get_db_connection(),
            user_name=user_name,
            document_id=doc_id,
            search_id=valid_search_id,
        )

    back_url = url_for("index")
    return_to = request.args.get("return_to", "")
    safe_return_to = ""
    # prevents links which would redirect to outside the website
    if return_to.startswith("/") and not return_to.startswith("//"):
        back_url = return_to
        safe_return_to = return_to

    return render_template(
        "document_detail.html",
        document=document,
        back_url=back_url,
        safe_return_to=safe_return_to,
    )


@document.route("/<doc_id>.pdf")
def download_pdf(doc_id):
    download: bool = request.args.get("download", True, type=_bool_string)
    try:
        if not _valid_id(doc_id):
            raise Exception("Not a valid doc_id")

        pdf_path: Path = (
            Path(current_app.config["DOCUMENT_DIR"]) / doc_id / f"{doc_id}.pdf"
        ).absolute()

        if not pdf_path.exists():
            raise Exception("Not a valid document path")

        return send_file(
            pdf_path,
            mimetype="application/pdf",
            as_attachment=download,
            download_name=f"{doc_id}.pdf",
        )
    except Exception as e:
        print(e)
        return "Document not found", 404


@document.route("/<doc_id>.csv")
def download_csv(doc_id):
    download: bool = request.args.get("download", True, type=_bool_string)
    try:
        if not _valid_id(doc_id):
            raise Exception("Not a valid doc_id")

        connection: psycopg2.extensions.connection = db_utils.get_db_connection()
        if not db_utils.get_document(connection, doc_id):
            raise Exception("Not a valid document path")

        content: str = db_utils.get_documents_as_csv(connection, [doc_id])

        return send_file(
            BytesIO(content.encode("utf-8")),
            mimetype="text/csv",
            as_attachment=download,
            download_name=f"{doc_id}.csv",
        )
    except Exception as e:
        print(e)
        return "Document not found", 404


@document.route("/<doc_id>.jpg", methods=["GET"])
def thumbnail(doc_id):
    scale: float = request.args.get("scale", 1, type=float)
    page: int = request.args.get("page", 1, type=int)

    try:
        if not _valid_id(doc_id):
            raise Exception("Not a valid doc_id")

        pdf_path: Path = (
            Path(current_app.config["DOCUMENT_DIR"]) / doc_id / f"{doc_id}.pdf"
        )

        if not pdf_path.exists():
            raise Exception("Not a valid document path")

        # get pdf info for page count and size
        info: dict = pdf2image.pdfinfo_from_path(
            pdf_path, poppler_path=current_app.config["POPPLER_PATH"]
        )

        page_size_split: list[str] = str(info["Page size"]).split(" ")
        page_size: tuple[float, float] = (
            float(page_size_split[0]) * scale,
            float(page_size_split[2]) * scale,
        )

        # clamp requested page
        if page < 1 or page > info["Pages"]:
            raise IndexError("Page number not valid")

        image: PIL.Image.Image = pdf2image.convert_from_path(
            pdf_path=pdf_path,
            first_page=page,
            last_page=page,
            size=page_size,
            poppler_path=current_app.config["POPPLER_PATH"],
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


@document.route("/flag/<doc_id>", methods=["POST"])
def flag_document(doc_id):
    redirect_args: dict[str, str] = {}

    return_to = request.form.get("return_to", "").strip()
    search_id = request.form.get("search_id", "").strip()
    if return_to:
        redirect_args["return_to"] = return_to
    if search_id:
        redirect_args["search_id"] = search_id

    user_name = session.get("user")
    if not user_name:
        flash("Log in to flag documents for review.", "error")
        return redirect(
            url_for("document.document_detail", doc_id=doc_id, **redirect_args)
        )

    if not db_utils.get_document(db_utils.get_db_connection(), doc_id):
        flash("Document not found", "error")
        return redirect(url_for("index"))

    error_location = request.form.get("error_location", "").strip()
    error_description = request.form.get("error_description", "").strip()

    if not error_location:
        flash("Please provide where the issue appears.", "error")
        return redirect(
            url_for("document.document_detail", doc_id=doc_id, **redirect_args)
        )
    if len(error_location) > 20:
        flash("Issue location must be 20 characters or fewer.", "error")
        return redirect(
            url_for("document.document_detail", doc_id=doc_id, **redirect_args)
        )
    if not error_description:
        flash("Please describe the issue before submitting a flag.", "error")
        return redirect(
            url_for("document.document_detail", doc_id=doc_id, **redirect_args)
        )

    db_utils.log_flag(
        db_utils.get_db_connection(),
        user_name=user_name,
        document_id=doc_id,
        error_location=error_location,
        error_description=error_description,
    )

    flash("Document flagged for review.", "success")
    return redirect(url_for("document.document_detail", doc_id=doc_id, **redirect_args))
