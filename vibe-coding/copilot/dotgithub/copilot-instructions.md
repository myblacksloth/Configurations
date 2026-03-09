# Repository instructions for Copilot

This repository hosts a modular Python backend (Flask + PostgreSQL + Redis).

## Objectives
- Deliver the smallest coherent change that solves the requested task.
- Preserve current architecture unless refactor is explicitly requested.
- Keep changes easy to review, test, and roll back.

## Code and architecture rules
- Use Python 3.11.
- Keep Flask routes thin; place business logic in service modules.
- Isolate database access in dedicated data-access modules.
- Keep Redis and database configuration in environment variables.
- Use logging instead of print.
- Use type hints in all new or modified code.
- Do not hardcode secrets, tokens, URLs, or credentials.
- Do not change database schema or migration history unless explicitly requested.
- Avoid introducing new dependencies unless needed for the task.

## Implementation workflow
1. Inspect existing patterns before editing.
2. Identify minimal file set to modify.
3. Implement the smallest coherent diff.
4. Add or update pytest coverage for non-trivial logic.
5. Run focused verification commands when possible.
6. Summarize what changed, why, and how to verify.

## Containerization guidance
- If asked to dockerize, first reuse/adapt existing Dockerfile or compose files.
- Add new container files only when missing.
- Keep secrets in environment variables, not in image or compose files.

## Output expectations
When responding, include:
- files changed
- behavior changed
- risks or follow-ups
- exact verification commands (or why verification could not run)
