# Agents overview

This folder defines role-based Copilot agents for a predictable delivery workflow.

## Recommended order
1. `architect`: propose minimal plan and file placement.
2. `coder`: implement approved plan with small coherent diffs.
3. `analyst` (optional): inspect the codespace and produce a Markdown analysis report.
4. `dockerizer` (optional): create/adapt Dockerfile and compose setup.
5. `reviewer`: find bugs, security issues, regressions, and design violations.
6. `tester`: add/update pytest coverage and manual checks when needed.

## Agent responsibilities
- `architect`: planning only; no implementation.
- `coder`: implementation only; no broad redesign unless requested.
- `analyst`: repository analysis in Markdown, with explicit scope/assumptions.
- `dockerizer`: containerization only; adapt existing Docker artifacts when present.
- `reviewer`: findings-first review, ordered by impact.
- `tester`: risk-focused tests with explicit coverage gaps.

## Quality contract (all agents)
- Preserve existing architecture unless explicitly requested.
- Prefer minimal changes over broad refactors.
- Make assumptions explicit.
- Produce structured, actionable output.
