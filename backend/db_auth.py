"""A collection of helpers for user authentication against the PostgreSQL database."""

import psycopg2.sql as sql
from psycopg2.extensions import connection, cursor


def create_user(conn: connection, username: str, email: str, password_hash: str) -> bool:
    """Create a new user in the database.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    username : str
        The username for the new user
    email : str
        The email address for the new user
    password_hash : str
        The hashed password for the new user

    Returns
    -------
    success : bool
        ``True`` if the user was created successfully, ``False`` if a
        user with that username or email already exists
    """
    try:
        cur: cursor
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO users (name, email, encoded_password) VALUES (%s, %s, %s);",
                [username, email.lower(), password_hash],
            )
        conn.commit()
        return True
    except sql.IntegrityError:
        # User already exists
        conn.rollback()
        return False
    except Exception as e:
        conn.rollback()
        raise e


def get_user_password_hash(conn: connection, username: str) -> str | None:
    """Get the password hash for a user.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    username : str
        The username to look up

    Returns
    -------
    password_hash : str or None
        The stored password hash if the user exists, otherwise ``None``
    """
    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT encoded_password FROM users WHERE name = %s;",
            [username],
        )
        result = cur.fetchone()
        if result:
            return result[0]
        return None


def get_user_by_email(conn: connection, email: str) -> dict | None:
    """Get a user record by email address.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    email : str
        The email address to look up; 
    Returns
    -------
    user : dict or None
        A dictionary with keys ``name``, ``email``, and
        ``encoded_password`` if the user exists, otherwise ``None``
    """
    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT name, email FROM users WHERE email = %s;",
            [email.lower()],
        )
        result = cur.fetchone()
        if result:
            return {
                "name": result[0],
                "email": result[1]
            }
        return None


def get_user_by_name(conn: connection, username: str) -> dict | None:
    """Get a user record by username.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    username : str
        The username to look up

    Returns
    -------
    user : dict or None
        A dictionary with keys ``name``, ``email``, and
        ``encoded_password`` if the user exists, otherwise ``None``
    """
    cur: cursor
    with conn.cursor() as cur:
        cur.execute(
            "SELECT name, email FROM users WHERE name = %s;",
            [username],
        )
        result = cur.fetchone()
        if result:
            return {
                "name": result[0],
                "email": result[1]
            }
        return None


def user_exists(conn: connection, username: str) -> bool:
    """Check if a user exists in the database.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    username : str
        The username to check

    Returns
    -------
    exists : bool
        ``True`` if the user exists, ``False`` otherwise
    """
    cur: cursor
    with conn.cursor() as cur:
        cur.execute("SELECT 1 FROM users WHERE name = %s;", [username])
        return cur.fetchone() is not None


def email_exists(conn: connection, email: str) -> bool:
    """Check if an email address is already registered.

    Parameters
    ----------
    conn : :obj:`psycopg2.extensions.connection`
        A ``psycopg2`` connection to perform queries with
    email : str
        The email address to check; matched case-insensitively

    Returns
    -------
    exists : bool
        ``True`` if the email is already registered, ``False`` otherwise
    """
    cur: cursor
    with conn.cursor() as cur:
        cur.execute("SELECT 1 FROM users WHERE email = %s;", [email.lower()])
        return cur.fetchone() is not None


if __name__ == "__main__":
    pass