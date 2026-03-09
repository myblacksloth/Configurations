# Custom Copilot Agents

This folder defines role-based custom agents for a predictable, auditable delivery workflow.

## Recommended invocation order

1. **`architect`** — inspect the codebase, propose the minimal plan, map file changes and risks.
2. **`coder`** — implement the approved plan with focused, minimal diffs.
3. **`analyst`** *(optional)* — produce a structured Markdown analysis report when the scope or health of the project is uncertain.
4. **`dockerizer`** *(optional)* — create or adapt `Dockerfile` and `compose.yaml`.
5. **`reviewer`** — findings-first audit for bugs, security issues, regressions, and design violations.
6. **`tester`** — add or update `pytest` coverage; propose manual checks for areas that cannot be automated.

## Agent responsibilities

| Agent | Responsibility | Writes code? |
|-------|---------------|-------------|
| `architect` | Planning only; no implementation | No |
| `coder` | Implementation only; no broad redesign | Yes |
| `analyst` | Repository analysis report in Markdown | No |
| `dockerizer` | Containerisation; adapt existing files first | Yes |
| `reviewer` | Findings-first review ordered by impact | No |
| `tester` | Risk-focused tests with explicit coverage gaps | Yes |

## Quality contract (all agents)

- Preserve existing architecture unless explicitly requested.
- Prefer minimal changes over broad refactors.
- Make every assumption explicit.
- Produce structured, actionable output.
- Include exact verification commands in every response.
