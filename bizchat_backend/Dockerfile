# Base Image
FROM python:3.11-slim-bookworm AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    WORKDIR=/app

WORKDIR ${WORKDIR}

# Install system dependencies required for building Python packages and Postgres/Celery health checks
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# Development Stage
FROM base AS development
COPY . .

# Keep the container running or override via docker-compose
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


# Production Stage
FROM base AS production

# Create a non-privileged user for security
RUN useradd -U appuser && chown -R appuser:appuser ${WORKDIR}

# Copy project files into the container as root first
COPY . .

# Execute build.sh to collect static files and start the server
RUN chmod +x build.sh

# Copy project files
COPY chown -R appuser:appuser ${WORKDIR}

# Switch to non-root user
USER appuser

RUN chmod +x build.sh

# Expose port and let build.sh handle the startup commands
EXPOSE 8000
