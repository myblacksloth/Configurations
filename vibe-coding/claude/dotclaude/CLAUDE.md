# CLAUDE.md

## Project overview
Modular Flask backend with PostgreSQL and Redis.

## Global rules
- Keep Flask handlers thin
- Business logic in services
- DB access isolated
- Redis config from environment variables
- Use logging, not print
- Use Python type hints in new or modified code
- Do not hardcode secrets or credentials
- Add or update pytest tests for non-trivial changes
- Keep changes minimal and coherent
- Avoid large refactors unless explicitly requested
- Do not change DB schema unless explicitly requested

## Workflow expectations
1. Inspect existing patterns before writing code.
2. Prefer the smallest coherent diff.
3. Verify with focused commands where possible.
4. Summarize files changed, behavior changed, risks, and verification steps.

## Containerization guidance
- If dockerizing is requested, adapt existing Dockerfile/compose first.
- Create new Docker artifacts only when missing.
- Keep credentials and secrets in environment variables.
