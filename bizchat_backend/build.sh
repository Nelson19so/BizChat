#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status
set -o errexit

echo "Running Database Migrations..."
python manage.py migrate --noinput

echo "Collecting Static Files..."
python manage.py collectstatic --noinput

echo "Starting Daphne ASGI Production Web Server..."
# Daphne uses the asgi application configuration, not wsgi
exec daphne -b 0.0.0.0 -p 8000 config.asgi:application
