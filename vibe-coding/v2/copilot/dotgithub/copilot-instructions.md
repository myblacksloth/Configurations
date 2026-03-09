# Repository instructions for GitHub Copilot

This repository hosts a modular Python backend (Flask · PostgreSQL · Redis).

## Project architecture

- **Routes** (`routes/`): thin Flask handlers — no business logic.
- **Services** (`services/`): all business logic lives here.
- **Repositories / DAOs** (`repositories/` or `db/`): all database access is isolated here.
- **Config**: every DB, Redis, and external-service credential comes from environment variables.

## Code and architecture rules

- Use Python 3.11.
- Add type hints to every new or modified function/method signature.
- Use `logging` at the appropriate level — never `print`.
- Never hardcode secrets, tokens, URLs, or credentials.
- Do not change database schema or Alembic migration history unless explicitly requested.
- Do not introduce new dependencies unless required by the task.
- Follow PEP 8; prefer `ruff` for linting.
- Write docstrings for public functions and classes.

## Implementation workflow

1. Read existing patterns in the relevant module before writing any code.
2. Identify the minimal set of files to touch.
3. Implement the smallest coherent diff that solves the request.
4. Add or update `pytest` coverage for every non-trivial behaviour change.
5. Run `pytest -x` (or a focused subset) and confirm it passes.
6. Summarise: files changed · behaviour changed · risks · exact verification commands.

## Containerisation guidance

- If asked to dockerise, first adapt existing `Dockerfile` / `compose.yaml`.
- Create new container files only when genuinely absent.
- Never embed secrets in images or compose files — use env-var references.
- Add `HEALTHCHECK` directives for every long-running service.

## Pull request expectations

Every PR opened by Copilot coding agent must include:
- A one-paragraph summary of what changed and why.
- A list of files changed with a brief rationale for each.
- Exact commands to verify the change locally.
- Any follow-ups or known limitations.
