# Example project: tinyapp

Tiny Python project used as a practical demo of subagent workflow.

## Run locally

```bash
cd example
PYTHONPATH=src python3 -m tinyapp.cli --total 39.9 --member
```

## Run tests

```bash
cd example
PYTHONPATH=src python3 -m pytest
```

## Run with Docker

```bash
cd example
docker build -t tinyapp-demo .
docker run --rm tinyapp-demo
```

## Run with Compose

```bash
cd example
docker compose up --build
```

## Local Codex subagent config

This project includes a local Codex setup in `example/.codex/` with:
- `architect`
- `coder`
- `analyst`
- `dockerizer`
- `reviewer`
- `tester`

Use the reports in `reports/subagents/` as a practical, end-to-end example of subagent outputs.

## Subagent demo outputs

See `reports/subagents/` for a complete scenario showing how each subagent contributes:
- architect
- coder
- analyst
- dockerizer
- reviewer
- tester
