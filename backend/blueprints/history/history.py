import csv

from flask import (
    Blueprint,
    url_for,
    flash,
    redirect,
    session,
    send_file,
    render_template,
)
from io import StringIO, BytesIO

from ... import db_utils

history = Blueprint("history", __name__, url_prefix="/history")


@history.route("/")
def view_history():
    user_name = session.get("user")
    if not user_name:
        flash("Log in to view your history.", "error")
        return redirect(url_for("index"))

    searches = db_utils.get_search_history(db_utils.get_db_connection(), user_name)
    history = db_utils.get_view_history(db_utils.get_db_connection(), user_name)

    return render_template("view_history.html", history=history, searches=searches)


@history.route("/download")
def download_history():
    user_name = session.get("user")
    if not user_name:
        flash("Log in to download your history.", "error")
        return redirect(url_for("index"))

    history = db_utils.get_view_history(db_utils.get_db_connection(), user_name)

    # Create CSV
    output = StringIO()
    writer = csv.writer(output)
    writer.writerow(
        [
            "Title",
            "Year",
            "Document Type",
            "Description",
            "Viewed Date",
            "Search Text",
        ]
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


@history.route("/history/replay/<int:search_id>")
def replay_search(search_id):
    user_name = session.get("user")
    if not user_name:
        flash("Log in to replay a saved search.", "error")
        return redirect(url_for("index"))

    search_entry = db_utils.get_search_history_entry(
        db_utils.get_db_connection(), user_name, search_id
    )
    if not search_entry:
        flash("Saved search not found.", "error")
        return redirect(url_for("history.view_history"))

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
