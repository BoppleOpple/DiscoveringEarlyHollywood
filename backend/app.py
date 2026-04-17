import os
import math
from flask import (
    Flask,
    render_template,
    request,
    url_for,
    session,
    g,
)
import psycopg2
from dotenv import load_dotenv

from . import db_utils
from .datatypes import Document, Query
from .blueprints.account import account as bp_account
from .blueprints.document import document as bp_document
from .blueprints.history import history as bp_history
from .blueprints.manager import manager as bp_manager


def _search_signature_from_args() -> str:
    """Stable signature of active filters, excluding page number."""
    keys: list[str] = sorted(
        k for k in request.args.keys() if k not in {"page", "replay_search_id", "genre"}
    )
    return "&".join(
        f"{key}={(request.args.get(key) or '').strip()}"
        for key in keys
        if (request.args.get(key) or "").strip() != ""
    )


def _print_kwargs(**kwargs):
    """Prints keyword arguments to the server console."""
    print(kwargs)


def create_app(flask_constructor_options: dict = None, **kwargs) -> Flask:
    if flask_constructor_options is None:
        flask_constructor_options = {}
    app: Flask = Flask(__name__, subdomain_matching=True, **flask_constructor_options)

    app.config.update(**kwargs)

    app.secret_key = (
        app.config["FLASK_SECRET"] if "FLASK_SECRET" in app.config else None
    )

    app.register_blueprint(bp_account)
    app.register_blueprint(bp_document)
    app.register_blueprint(bp_history)
    app.register_blueprint(bp_manager)

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

    @app.teardown_appcontext
    def teardown_db_connection(exception):
        db_connection: psycopg2.extensions.connection = g.pop("db_connection", None)
        if db_connection:
            db_connection.close()

    @app.route("/")
    def index():
        search = request.args.get("search", "")
        year_min: int = request.args.get("year_min", 1912, type=int)
        year_max: int = request.args.get("year_max", 1928, type=int)
        page: int = request.args.get("page", 1, type=int)

        query: Query = Query(
            actors=[],  # TODO
            tags=[],  # TODO
            keywords=list(
                filter(lambda s: s != "", search.split(" ")) if search else []
            ),  # TODO allow searching both titles and transcripts
            document_type=None,  # TODO
            studio=None,  # TODO
            copyright_year_range=(year_min, year_max),  # TODO allow a start & end value
            duration_range=(None, None),  # TODO
        )

        num_results = db_utils.get_num_results(
            db_utils.get_db_connection(),
            query,
        )

        results: list[Document] = db_utils.search_results(
            db_utils.get_db_connection(),
            query,
            page,
            resultsPerPage=app.config["RESULTS_PER_PAGE"],
        )

        headlines: dict[str, str] = db_utils.get_headlines(
            db_utils.get_db_connection(), results, query
        )
        current_search_id: int | None = None
        viewed_doc_ids: set[str] = set()

        user_name = session.get("user")
        # If the user is signed in, append to their search history
        if user_name:
            viewed_doc_ids = db_utils.get_viewed_document_ids(
                db_utils.get_db_connection(), user_name
            )
            replay_search_id: int | None = request.args.get(
                "replay_search_id", type=int
            )
            replay_entry = (
                db_utils.get_search_history_entry(
                    db_utils.get_db_connection(), user_name, replay_search_id
                )
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
                            db_utils.get_db_connection(),
                            user_name=user_name,
                            start_year=year_min if "year_min" in request.args else None,
                            end_year=year_max if "year_max" in request.args else None,
                            studio=None,  # TODO wire studio filter when available
                            actors=[],
                            genres=[],
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
            year_min=year_min,
            year_max=year_max,
            page=page,
            num_results=num_results,
            results_per_page=app.config["RESULTS_PER_PAGE"],
            viewed_doc_ids=viewed_doc_ids,
            current_search_id=current_search_id,
            current_results_path=request.full_path.rstrip("?"),
        )

    @app.route("/flagged")
    def flagged_documents():
        flagged = db_utils.get_flagged(db_utils.get_db_connection())
        return render_template("flagged_documents.html", documents=flagged)

    return app


if __name__ == "__main__":
    load_dotenv()

    app = create_app(
        FLASK_SECRET=os.environ["FLASK_SECRET"],
        SQL_HOST=os.environ["SQL_HOST"],
        SQL_PORT=os.environ["SQL_PORT"],
        SQL_DBNAME=os.environ["SQL_DBNAME"],
        SQL_USER=os.environ["SQL_USER"],
        SQL_PASSWORD=os.environ["SQL_PASSWORD"],
        DOCUMENT_DIR=os.environ["DOCUMENT_DIR"],
        POPPLER_PATH=(
            os.environ["POPPLER_PATH"] if "POPPLER_PATH" in os.environ else None
        ),
        RESULTS_PER_PAGE=20,
    )

    app.run(debug=True, port=5000)
