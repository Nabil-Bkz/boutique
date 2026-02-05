#!/bin/sh
set -e

echo "Applying migrations..."
uv run python manage.py migrate

echo "Starting Django server..."
exec uv run python manage.py runserver 0.0.0.0:8000
