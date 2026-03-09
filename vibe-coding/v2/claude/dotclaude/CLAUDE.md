# CLAUDE.md

## Project overview

Modular Flask backend with PostgreSQL and Redis.
Stack: Python 3.11 · Flask · SQLAlchemy · Alembic · Redis · pytest · Docker / Compose.

## Architecture rules

- Keep Flask route handlers thin — no business logic in views.
- Place business logic exclusively in `services/`.
- Isolate all DB access in dedicated data-access modules (repositories or DAOs).
- Load Redis and DB configuration strictly from environment variables.
- Use `logging` (not `print`) at the appropriate level (`DEBUG`, `INFO`, `WARNING`, `ERROR`).
- Add Python type hints to every new or modified function/method signature.
- Never hardcode secrets, tokens, URLs, or credentials anywhere in source or config files.
- Do not alter DB schema or Alembic migration history unless explicitly requested.
- Avoid introducing new dependencies unless strictly required by the task.

## Coding standards

- Follow PEP 8; use `ruff` for linting when available.
- Prefer small, single-responsibility, testable functions.
- Write docstrings for public functions and classes.
- Handle errors explicitly; never silence exceptions without logging.

## Implementation workflow

1. Read existing patterns in the relevant module before writing any code.
2. Identify the minimal set of files to touch.
3. Produce the smallest coherent diff that satisfies the request.
4. Add or update `pytest` tests for every non-trivial behavior change.
5. Run `pytest -x` (or a focused subset) and confirm it passes.
6. Summarize: files changed · behavior changed · risks · exact verification commands.

## Containerization guidance

- When dockerizing, adapt existing `Dockerfile`/`compose.yaml` before creating new ones.
- Create new container artifacts only when they are truly absent.
- Never embed secrets in images or compose files — use env-var references only.
- Add healthchecks for every long-running service.

## Sub-agent routing (parallel vs sequential)

**Dispatch in parallel** when all of the following are true:
- Three or more independent domains with no shared state.
- Clear file boundaries — no overlap risk.

**Dispatch sequentially** when any of the following applies:
- Task B depends on the output of task A.
- Tasks share files or mutable state.
- Scope is unclear and must be clarified first.

## Output expectations

Every response must include:
- Files changed (with paths)
- Behavior changed
- Risks or follow-ups
- Exact verification commands (or an explicit reason if verification was not possible)
