FROM python:3.11-slim

WORKDIR /app
COPY pyproject.toml /app/
COPY src /app/src

ENV PYTHONPATH=/app/src

CMD ["python", "-m", "tinyapp.cli", "--total", "29.9", "--member"]
