# Prompt examples

## Planning (architect)

```text
Use the architect agent to propose the smallest coherent implementation plan for <feature>.
Return:
1. scope (in/out)
2. files to inspect
3. files to modify
4. ordered implementation steps
5. risks and test impact
```

## Implementation (coder)

```text
Use the coder agent to implement the approved plan with minimal diffs.
Respect existing project structure and avoid unrelated changes.
Return files changed, behavior changed, and verification commands.
```

## Review (reviewer)

```text
Use the reviewer agent to review current changes.
Focus on high-impact findings first: bugs, security issues, regressions, architecture violations, missing tests.
Include file/line references where possible.
```

## Testing (tester)

```text
Use the tester agent to add or update pytest coverage for modified behavior.
Prefer focused unit tests and cover important error paths.
Return covered and uncovered scenarios plus commands run.
```

## Containerization (dockerizer)

```text
Use the dockerizer agent to dockerize the project.
If Dockerfile/compose files already exist, adapt them instead of replacing them.
Return container files changed, required env vars, and exact build/run commands.
```

## Repository analysis (analyst)

```text
Use the analyst agent to inspect the codespace and produce a Markdown analysis report.
I want to achieve: <analysis objectives and decisions to support>.
Project structure/context: <stack, module boundaries, critical flows, constraints>.
Scope: <in-scope folders/files> / <out-of-scope folders/files>.
Depth: <overview|standard|deep-dive>.
```

### Analysis brief template (recommended)

```md
# Analysis Request

## 1) Analysis objectives
- What I want from this analysis:
- Decisions this analysis should support:
- Priority dimensions: architecture | performance | security | maintainability | delivery risk

## 2) Expected depth
- Overview / Standard / Deep-dive

## 3) Project structure and context
- Tech stack and runtime:
- Module/domain boundaries:
- Critical business/user flows:
- Constraints (timeline, compliance, compatibility):

## 4) Scope boundaries
- In scope:
- Out of scope:

## 5) Success criteria
- This analysis is useful if:
```

# Usage

Interactive:

```text
/agent
```

Prompt-driven pipeline:

```text
Use the architect agent to plan the smallest coherent way to add Redis caching.
Use the coder agent to implement the approved plan.
Use the analyst agent to produce a Markdown analysis of architecture risks and delivery bottlenecks.
Use the dockerizer agent to create or adapt Dockerfile and docker-compose setup.
Use the reviewer agent to review the implementation for regressions and security issues.
Use the tester agent to add pytest coverage for the modified behavior.
```
