---
applyTo: "migrations/**"
---

Migration rules:
- do not rewrite historical migrations unless explicitly requested
- prefer additive schema changes
- keep migrations minimal and reversible when possible
