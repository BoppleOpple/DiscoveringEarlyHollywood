import re

from werkzeug.security import generate_password_hash, check_password_hash
from flask import Blueprint, session, flash, redirect, url_for, request, jsonify

from ... import db_utils, db_auth

account = Blueprint("account", __name__, url_prefix="/account")


@account.route("/login", methods=["POST"])
def login():
    username = request.form.get("full_name", "").strip()
    password = request.form.get("password", "")

    errors = []

    if not username or not password:
        errors.append("Full name and password are required.")

    if not errors:
        password_hash = db_auth.get_user_password_hash(
            db_utils.get_db_connection(), username
        )
        if password_hash is None or not check_password_hash(password_hash, password):
            errors.append("Invalid name or password.")

    if errors:
        return jsonify({"errors": errors}), 400

    session["user"] = username

    flash(f"Welcome back, {username}!", "success")
    return jsonify({"success": True})


@account.route("/signup", methods=["POST"])
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
    elif db_auth.user_exists(db_utils.get_db_connection(), username):
        errors.append("An account with that username already exists.")

    # Email validation
    if not email:
        errors.append("Email is required.")
    elif db_auth.email_exists(db_utils.get_db_connection(), email):
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
                "Password must contain at least one special character (!@#$%^&*()_+-=[]{}|;:,.<>?)."  # noqa E501
            )

    if errors:
        return jsonify({"errors": errors}), 400

    password_hash = generate_password_hash(password)
    success_signup = db_auth.create_user(
        db_utils.get_db_connection(), username, email, password_hash
    )

    if not success_signup:
        return (
            jsonify({"errors": ["Could not create account. Please try again."]}),
            400,
        )

    session["user"] = username

    flash(f"Account created! Welcome, {username}.", "success")
    return jsonify({"success": True})


@account.route("/logout")
def logout():
    session.clear()
    flash("You have been logged out.", "success")
    return redirect(url_for("index"))
