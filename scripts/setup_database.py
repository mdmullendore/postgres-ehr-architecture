#!/usr/bin/env python3
"""Create the EHR database, apply schema SQL, and load seed data."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

import psycopg
from dotenv import load_dotenv
from psycopg import sql

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")
DEFAULT_DB_NAME = "ehr_db"

SCHEMA_FILES = [
    "schema/functions/set_updated_at.sql",
    "schema/functions/record_phi_audit.sql",
    "schema/tables/facilities.sql",
    "schema/tables/staff_roles.sql",
    "schema/tables/staff_users.sql",
    "schema/tables/audit_log.sql",
    "schema/tables/providers.sql",
    "schema/tables/patients.sql",
    "schema/tables/patient_portal_users.sql",
    "schema/tables/appointments.sql",
    "schema/tables/clinical_notes.sql",
    "schema/triggers/phi_audit_triggers.sql",
    "schema/policies/row_level_security.sql",
]

SEED_FILES = [
    "seed/facilities.sql",
    "seed/staff_roles.sql",
    "seed/staff_users.sql",
    "seed/providers.sql",
    "seed/patients.sql",
    "seed/patient_portal_users.sql",
    "seed/appointments.sql",
    "seed/clinical_notes.sql",
    "seed/audit_log.sql",
]


def connection_kwargs(dbname: str) -> dict[str, str]:
    return {
        "host": os.environ.get("PGHOST", "localhost"),
        "port": os.environ.get("PGPORT", "5432"),
        "user": os.environ.get("PGUSER", "postgres"),
        "password": os.environ.get("PGPASSWORD", ""),
        "dbname": dbname,
    }


def database_exists(admin_conn: psycopg.Connection, db_name: str) -> bool:
    with admin_conn.cursor() as cur:
        cur.execute(
            "SELECT 1 FROM pg_database WHERE datname = %s",
            (db_name,),
        )
        return cur.fetchone() is not None


def create_database(admin_conn: psycopg.Connection, db_name: str) -> None:
    if database_exists(admin_conn, db_name):
        print(f"Database {db_name!r} already exists; skipping create.")
        return

    create_with_locale = sql.SQL(
        "CREATE DATABASE {} "
        "WITH ENCODING = 'UTF8' "
        "LC_COLLATE = 'en_US.UTF-8' "
        "LC_CTYPE = 'en_US.UTF-8' "
        "TEMPLATE = template0"
    ).format(sql.Identifier(db_name))

    create_without_locale = sql.SQL(
        "CREATE DATABASE {} WITH ENCODING = 'UTF8' TEMPLATE = template0"
    ).format(sql.Identifier(db_name))

    try:
        admin_conn.execute(create_with_locale)
    except psycopg.Error as exc:
        if "locale" not in str(exc).lower():
            raise
        print(
            "Locale en_US.UTF-8 unavailable; creating database with server defaults."
        )
        admin_conn.execute(create_without_locale)

    print(f"Created database {db_name!r}.")


def run_sql_file(conn: psycopg.Connection, relative_path: str) -> None:
    path = PROJECT_ROOT / relative_path
    if not path.is_file():
        raise FileNotFoundError(f"SQL file not found: {path}")

    sql_text = path.read_text(encoding="utf-8")
    with conn.transaction():
        conn.execute(sql_text)
    print(f"Applied {relative_path}")


def apply_schema(conn: psycopg.Connection) -> None:
    conn.execute("CREATE EXTENSION IF NOT EXISTS pgcrypto")
    print("Ensured pgcrypto extension is available.")

    for relative_path in SCHEMA_FILES:
        run_sql_file(conn, relative_path)


def apply_seeds(conn: psycopg.Connection) -> None:
    for relative_path in SEED_FILES:
        run_sql_file(conn, relative_path)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create the EHR PostgreSQL database, schema, and seed data."
    )
    parser.add_argument(
        "--db-name",
        default=os.environ.get("EHR_DB_NAME", DEFAULT_DB_NAME),
        help=f"Target database name (default: {DEFAULT_DB_NAME}).",
    )
    parser.add_argument(
        "--schema-only",
        action="store_true",
        help="Apply schema only; skip seed data.",
    )
    parser.add_argument(
        "--seed-only",
        action="store_true",
        help="Load seed data only; assume schema already exists.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.schema_only and args.seed_only:
        print("Cannot use --schema-only and --seed-only together.", file=sys.stderr)
        return 1

    admin_kwargs = connection_kwargs("postgres")
    target_kwargs = connection_kwargs(args.db_name)

    try:
        if not args.seed_only:
            with psycopg.connect(**admin_kwargs, autocommit=True) as admin_conn:
                create_database(admin_conn, args.db_name)

        with psycopg.connect(**target_kwargs) as conn:
            if not args.seed_only:
                apply_schema(conn)
            if not args.schema_only:
                apply_seeds(conn)
    except psycopg.Error as exc:
        print(f"Database error: {exc}", file=sys.stderr)
        return 1
    except FileNotFoundError as exc:
        print(exc, file=sys.stderr)
        return 1

    print("Setup complete.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
