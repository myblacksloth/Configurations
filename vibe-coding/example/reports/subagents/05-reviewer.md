# Reviewer findings

## Findings
1. Medium: missing boundary tests around discount/free-shipping thresholds.
   - File: `tests/test_core.py`
   - Impact: regression risk when rule constants are modified.
   - Suggested fix: add tests for `19.99`, `20.0`, `49.99`, `50.0`.

2. Low: float arithmetic may be insufficient for production-grade billing.
   - File: `src/tinyapp/core.py`
   - Impact: rare rounding edge cases.
   - Suggested fix: migrate to `Decimal` if strict accounting precision is required.

## Residual risks
- Business rules are hardcoded (acceptable for demo size).

## Testing gaps
- Boundary tests not yet implemented.
