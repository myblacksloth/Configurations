# CLAUDE.md

## Project overview
Modular Flask backend with PostgreSQL and Redis.

## Global rules
- Keep Flask handlers thin
- Business logic in services
- DB access isolated
- Redis config from environment variables
- Use logging, not print
- Add or update pytest tests for non-trivial changes
- Avoid large refactors unless explicitly requested
