# Coder output

## Files changed
- `src/tinyapp/core.py`
- `src/tinyapp/cli.py`
- `tests/test_core.py`
- `Dockerfile`
- `compose.yaml`
- `README.md`

## Behavior change
- Added `calculate_checkout(total, is_member)` with discount and shipping rules.
- Added CLI interface: `python -m tinyapp.cli --total <value> [--member]`.

## Why this approach
- Minimal function-first design keeps logic testable and easy to maintain.
- CLI and container files are intentionally tiny for demo readability.

## Verification
- `PYTHONPATH=src python3 -m pytest` (requires pytest installed)
- `PYTHONPATH=src python3 -m tinyapp.cli --total 39.9 --member`
