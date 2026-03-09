---
name: review
description: >
  Findings-first review of the current diff. Covers security, correctness,
  regression risk, missing tests, and architecture violations.
  Trigger with /review after staging changes.
---

Review the current diff and produce a structured findings report.

## Checklist

- **Security** — injection, secret exposure, insecure defaults, unvalidated inputs.
- **Correctness** — logic bugs, incorrect conditions, off-by-one, null/empty handling.
- **Regressions** — broken existing contracts, callers, or API surface.
- **Architecture** — business logic in Flask handlers, DB access outside repositories, hardcoded config.
- **Test coverage** — risky changes with no corresponding tests.

## Output format

```
## Findings
<!-- Ordered by severity: CRITICAL → HIGH → MEDIUM → LOW → INFO -->
<!-- Format per finding: **<title>** (`file:line`) — impact — fix -->

## Residual risks

## Testing gaps
```

If no issues are found, state: `No significant findings`.

<!--
/review
-->
