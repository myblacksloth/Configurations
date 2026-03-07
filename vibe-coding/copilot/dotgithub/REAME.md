# Prompt

## Pianificazione

```
Create a minimal implementation plan for the requested feature.

Return:
1. files to inspect
2. files to modify
3. risks
4. test plan
```

## Revisione

```
Review the current changes for:
- bugs
- security issues
- architecture violations
- missing tests

Return findings ordered by severity.
```

## Test cases

```
Generate pytest tests for the current changes.
Prefer focused unit tests and include important edge cases.
```

# Utilizzo


```
/agent
```

oppure, tramite prompt

```
Use the architect agent to plan the smallest coherent way to add Redis caching.
Use the coder agent to implement the approved plan.
Use the reviewer agent to review the changes for regressions and security issues.
Use the tester agent to add pytest coverage.
```
