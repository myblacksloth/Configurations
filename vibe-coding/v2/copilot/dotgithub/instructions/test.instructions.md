---
applyTo: "tests/**/*.py"
---

# Test file conventions

- Use `pytest` exclusively.
- Prefer unit tests for service-layer and business logic.
- Cover error-handling paths for every risky code path.
- Keep fixtures minimal, readable, and scoped as tightly as possible (`function` scope by default).
- Never introduce network calls, real filesystem writes, or live external-service calls in unit tests — mock or patch them.
- Avoid brittle tests that assert on implementation details instead of observable behaviour.
- Name test functions descriptively: `test_<unit>_<scenario>_<expected_outcome>`.
- Group related tests in classes only when shared fixtures justify it.
