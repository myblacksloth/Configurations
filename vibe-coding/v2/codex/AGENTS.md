# AGENTS.md

## Project overview

Modular Flask backend (Python 3.11 · SQLAlchemy · Alembic · Redis · pytest · Docker/Compose).

## Architecture rules

- Flask route handlers must be thin — no business logic in views.
- Business logic lives exclusively in `services/`.
- All database access is isolated in dedicated repository / DAO modules.
- Redis and DB configuration come strictly from environment variables.
- Use `logging`, not `print`.
- Add type hints to every new or modified function/method signature.
- Never hardcode secrets, tokens, or credentials.
- Do not change DB schema or Alembic migrations unless explicitly instructed.
- Avoid introducing new dependencies unless required by the task.

## Implementation workflow

1. Read existing patterns before writing any code.
2. Identify the minimal set of files to touch.
3. Implement the smallest coherent diff.
4. Add or update `pytest` coverage for every non-trivial change.
5. Run `pytest -x` (or a focused subset) and confirm it passes.
6. Report: files changed · behaviour changed · risks · exact verification commands.

## Testing commands

```bash
# Run all tests
pytest -x

# Run a focused subset
pytest -x tests/<module>/

# Run with coverage
pytest --cov=src --cov-report=term-missing
```

## Linting

```bash
ruff check src/ tests/
```

## Containerisation

- Adapt existing `Dockerfile` / `compose.yaml` before creating new files.
- Never embed secrets in images or compose files.

## Pull request messages

Every PR must include:
- Summary of what changed and why.
- Files changed with brief rationale.
- Exact commands to verify locally.
- Known limitations or follow-ups.
