from flask import Blueprint, request, render_template

from ... import db_utils
from ...datatypes import Query

manager = Blueprint("manager", __name__, url_prefix="/manager")


@manager.route("/")
def documents_manager():
    search = request.args.get("search", "")
    query: Query = Query(
        actors=[],  # TODO
        tags=[],  # TODO
        keywords=list(
            filter(lambda s: s != "", search.split(" ")) if search else []
        ),  # TODO allow searching both titles and transcripts
        document_type=None,  # TODO
        studio=None,  # TODO
        reel_range=(None, None),  # TODO
    )

    docs = db_utils.search_results(db_utils.get_db_connection(), query)
    if search:
        docs = [
            d
            for d in docs
            if search.lower() in d["title"].lower()
            or search.lower() in d.get("studio", "").lower()
            or search in d["year"]
        ]
    return render_template("documents_manager.html", documents=docs, search=search)


@manager.route("/remove", methods=["POST"])
def remove_documents():
    return "Not yet implemented", 404


@manager.route("/upload", methods=["POST"])
def upload_documents():
    return "Not yet implemented", 404
