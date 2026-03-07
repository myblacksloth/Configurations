# Repository instructions for Copilot

This repository contains a modular Python backend.

General rules:
- Use Python 3.11
- Keep Flask routes thin
- Put business logic in service modules
- Isolate PostgreSQL access in dedicated modules
- Redis configuration must come from environment variables
- Use logging, not print
- Use type hints in new or modified code
- Avoid large refactors unless explicitly requested
- Add or update pytest tests for non-trivial changes
- Do not change database schema unless explicitly requested

When making changes:
1. inspect existing files first
2. prefer the smallest coherent change
3. preserve current structure unless a refactor is explicitly requested
4. explain files changed and how to verify
