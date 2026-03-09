# Codex subagents (sample setup)

This folder contains a Codex multi-agent configuration aligned with the official Codex configuration model:
- `config.toml` with `features.multi_agent`
- `agents.<name>` registrations with `description` + `config_file`
- per-agent TOML configs using `model_instructions_file`

## Files
- `dotcodex/config.toml`
- `dotcodex/agents/*.toml`
- `dotcodex/instructions/*.md`

## Included subagents
- `architect`
- `coder`
- `reviewer`
- `tester`
- `dockerizer`
- `analyst`

## How to use locally
1. Copy `codex/dotcodex/*` into your `~/.codex/` directory.
2. Start Codex from your repository root.
3. Ask Codex to delegate to subagents (for example: plan with `architect`, implement with `coder`, review with `reviewer`).

## Notes
- This repository currently has no Dockerfile/compose files, so `dockerizer` is configured to create them only when missing.
- `architect` and `reviewer` are configured as read-only.
- `analyst` is read-only and returns Markdown reports.

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
