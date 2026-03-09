# Tester output

## Tests added or updated
- Added `tests/test_core.py` with 3 focused unit tests.

## Scenarios covered
- Non-member order with shipping.
- Member order with discount and free shipping.
- Negative totals raise validation error.

## Scenarios not covered
- Threshold boundaries: `19.99`, `20`, `49.99`, `50`.

## Commands run
- `PYTHONPATH=src python3 -m pytest` (failed in this environment: pytest not installed)

## Manual verification
- `PYTHONPATH=src python3 -m tinyapp.cli --total 39.9 --member`
