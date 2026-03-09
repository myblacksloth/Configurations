# Architect output

## Scope
- In: tiny Python module for checkout calculation, CLI wrapper, tests, minimal container files.
- Out: framework adoption, DB integration, external services.

## Files to inspect
- `example/`

## Plan
1. Implement a single service function with explicit rules and validation.
2. Add a tiny CLI to execute the logic.
3. Add pytest tests for happy-path and error-path scenarios.
4. Add Dockerfile and compose setup for reproducible runtime.
5. Provide concise usage docs.

## Risks
- Floating-point rounding drift if rules change.
- Missing test for boundary values around free-shipping threshold.

## Test impact
- Unit tests on core calculator logic.
- Basic CLI command execution check (manual).
