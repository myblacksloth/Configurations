# Practical subagent scenario (example project)

This file shows a realistic workflow on `example/` using all subagents.

## Scenario goal
Deliver a tiny checkout app with tests, container run support, and quality checks.

## Recommended execution order
1. `architect`
2. `coder`
3. `analyst`
4. `dockerizer`
5. `reviewer`
6. `tester`

## Prompt examples

### 1) Architect
```text
Use the architect subagent on example/ and return a minimal implementation plan.
```

### 2) Coder
```text
Use the coder subagent to implement the approved plan in example/ with minimal diffs.
```

### 3) Analyst
```text
Use the analyst subagent to produce a Markdown analysis for example/.

Analysis objectives:
- validate architecture clarity
- identify delivery and maintenance risks

Project structure/context:
- stack: Python CLI module
- boundaries: core logic in src/tinyapp/core.py, CLI in src/tinyapp/cli.py
- critical flow: input -> pricing rules -> output JSON
- constraints: keep project very small and dependency-light

Scope:
- in scope: example/src, example/tests, example/Dockerfile, example/compose.yaml
- out of scope: repository root templates outside example/

Depth:
- standard
```

### 4) Dockerizer
```text
Use the dockerizer subagent on example/.
If Dockerfile/compose exist, adapt them; otherwise create minimal versions.
```

### 5) Reviewer
```text
Use the reviewer subagent to review example/ changes and list findings by severity.
```

### 6) Tester
```text
Use the tester subagent to add/update pytest coverage for example/ and report uncovered scenarios.
```

## Produced outputs in this demo
- `reports/subagents/01-architect.md`
- `reports/subagents/02-coder.md`
- `reports/subagents/03-analyst.md`
- `reports/subagents/04-dockerizer.md`
- `reports/subagents/05-reviewer.md`
- `reports/subagents/06-tester.md`

## Local Codex config for this project
- `example/.codex/config.toml`
- `example/.codex/agents/*.toml`
- `example/.codex/instructions/*.md`
