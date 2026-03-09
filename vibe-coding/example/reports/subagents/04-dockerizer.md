# Dockerizer output

## Container files changed
- `Dockerfile`
- `compose.yaml`

## Why each change was needed
- `Dockerfile`: packages app in `python:3.11-slim` and sets `PYTHONPATH`.
- `compose.yaml`: provides a one-command local run path for the demo.

## Build and run commands
```bash
cd example
docker build -t tinyapp-demo .
docker run --rm tinyapp-demo
```

```bash
cd example
docker compose up --build
```

## Environment variables required
- None strictly required for this demo.

## Known limitations
- No healthcheck (not needed for this one-shot CLI demo).
- No multi-stage build because dependency footprint is minimal.
