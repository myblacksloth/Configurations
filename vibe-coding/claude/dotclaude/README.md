# Prompt examples

```text
Use the architect subagent to propose the smallest coherent implementation plan for adding Redis caching.
Return scope, files to inspect/modify, risks, and test impact.
```

```text
Use the coder subagent to implement the approved plan with minimal diffs.
Return files changed, behavior changed, and verification commands.
```

```text
Use the reviewer subagent to review the current changes.
Prioritize high-impact findings first and include file/line references where possible.
```

```text
Use the tester subagent to add or update pytest coverage for the modified behavior.
Report covered and uncovered scenarios plus commands run.
```

```text
Use the dockerizer subagent to dockerize the project.
If Dockerfile/compose files already exist, adapt them instead of replacing them.
Return changed container files, required env vars, and build/run commands.
```

```text
Use the analyst subagent to inspect the codespace and produce a Markdown analysis.
Objectives: <what decisions this analysis should support>.
Project structure/context: <stack, boundaries, critical flows, constraints>.
Scope: <in-scope/out-of-scope files and folders>.
Depth: <overview|standard|deep-dive>.
```

## Analysis brief template (recommended)

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

# Workflow

## Planning

```text
Use the architect subagent to inspect the repo and propose the smallest coherent plan to add email notifications after motion detection.
```

## Implementation

```text
Use the coder subagent to implement the approved plan with minimal changes.
```

## Containerization

```text
Use the dockerizer subagent to create or adapt Dockerfile and docker-compose configuration for the current project.
```

## Analysis

```text
Use the analyst subagent to read the repository and produce a structured Markdown analysis report.
```

## Review

```text
Use the reviewer subagent to audit the implementation for logic errors, weak error handling, regressions, and security issues.
```

## Testing

```text
Use the tester subagent to add or update pytest tests for the modified modules and propose focused manual checks when needed.
```
