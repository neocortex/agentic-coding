# Agentic Coding

Portable agentic coding configurations, skills, and tools for Claude Code and Codex.

`AGENTS.md` is the single, tool-neutral instruction file for both tools. Claude Code has no global `AGENTS.md`, so `~/.claude/CLAUDE.md` only imports the Codex one:

```markdown
@~/.codex/AGENTS.md
```

## Repository Structure

### Root Config Files

| File | Purpose | Global Counterpart |
|---|---|---|
| `AGENTS.md` | Agent instructions (code style, dev rules, tooling) | `~/.codex/AGENTS.md` (imported by `~/.claude/CLAUDE.md`) |
| `settings.json` | Claude Code settings (permissions, hooks, plugins, model) | `~/.claude/settings.json` |
| `config.toml` | Codex settings (model, approvals, plugins) | `~/.codex/config.toml` |

### `skills/` — Portable Skills

Skills invocable via `/skill-name` in Claude Code. Global counterparts: `~/.claude/skills/` and `~/.agents/skills/`. All are user-invocable only (`disable-model-invocation: true`) unless noted.

| Skill | Description |
|---|---|
| `commit` | Create git commits with conventional commit format. Model-invocable. |
| `audit-codebase` | KISS manifesto codebase audit with actionable report and KISS score. |
| `create-prd` | Create a Product Requirements Document from the conversation or an input file. |
| `excalidraw-diagram` | Create Excalidraw diagram JSON files that visualize workflows, architectures, or concepts. Model-invocable. |
| `handoff` | Write a session handoff document so the next agent or session can continue the work. Model-invocable. |
| `prime` | Deep codebase primer — structure, docs, key files, architecture, tech stack. |
| `ralph-create-prd` | Generate structured PRDs with user stories and acceptance criteria. |
| `ralph-prd-to-json` | Convert markdown PRDs to Ralph's JSON execution format. |
| `update-docs` | Scan and sync documentation against current code state. |

### `.claude/skills/` — Project Skills

Skills for this repo only, invocable via `/skill-name` in Claude Code.

| Skill | Description |
|---|---|
| `sync-config` | Diff local configs and skills against their global copies, one difference at a time. |

### `ralph/` — Ralph Loop

Autonomous coding agent that implements features by working through PRD user stories. See [`ralph/README.md`](ralph/README.md) for details.

| File | Purpose |
|---|---|
| `ralph_prompt.md` | Agent instructions for each Ralph iteration |
| `ralph.sh` | Bash script that runs the autonomous loop |
