---
applyTo: "migrations/**"
---

# Migration file conventions

- **Never rewrite or delete historical migration files** unless explicitly instructed.
- Prefer additive schema changes (add columns, tables, indexes) over destructive ones.
- Keep each migration minimal, focused, and reversible when possible.
- Separate data migrations from schema migrations — never mix them in the same file.
- Always provide a `downgrade()` function that safely rolls back the change.
- Use descriptive migration message slugs: `alembic revision -m "add_user_email_index"`.
- Validate that the migration does not cause data loss before committing.
