---
applyTo: "src/**/*.py"
---

# Python source file conventions

- Follow PEP 8. Use `ruff` for linting when available.
- Add type hints to every function/method signature (parameters and return type).
- Prefer small, single-responsibility, independently testable functions.
- Use `logging` at the appropriate level (`DEBUG`, `INFO`, `WARNING`, `ERROR`). Never use `print`.
- Do not introduce new dependencies unless they are strictly required.
- Handle exceptions explicitly — never swallow errors silently.
- Write docstrings for all public functions and classes (Google or NumPy style).
- Keep Flask route handlers thin: delegate all logic to `services/`.
- Never hardcode secrets, tokens, or credentials.
