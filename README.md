# Agentic Coding

Portable agentic coding configurations, skills, and tools for Claude Code and Codex.

For Codex `AGENTS.md`, make a copy of `CLAUDE.md`.

## Repository Structure

### Root Config Files

| File | Purpose | Global Counterpart |
|---|---|---|
| `CLAUDE.md` | Agent instructions (code style, dev rules, tooling) | `~/.claude/CLAUDE.md`, `~/.agents/agents.md` |
| `settings.json` | Claude Code settings (permissions, hooks, plugins, model) | `~/.claude/settings.json` |
| `config.toml` | Codex settings (model, approvals, MCP servers) | `~/.agents/config.toml` |

### `skills/` — Portable Skills

Skills invocable via `/skill-name` in Claude Code. All are user-invocable only (`disable-model-invocation: true`) unless noted.

| Skill | Description |
|---|---|
| `commit` | Create git commits with conventional commit format. Model-invocable. |
| `audit-codebase` | KISS manifesto codebase audit with actionable report and KISS score. |
| `prime` | Deep codebase primer — structure, docs, key files, architecture, tech stack. |
| `prime-short` | Quick codebase primer — lightweight overview and recent activity. |
| `ralph-create-prd` | Generate structured PRDs with user stories and acceptance criteria. |
| `ralph-prd-to-json` | Convert markdown PRDs to Ralph's JSON execution format. |
| `update-docs` | Scan and sync documentation against current code state. |

### `.claude/skills/` — Project Skills

Skills specific to this project's workflow, loaded automatically by Claude Code.

| Skill | Description |
|---|---|
| `sync-config` | Compare local configs and skills against global `~/.claude/` and `~/.agents/` counterparts. Reports diffs and asks how to resolve. |

### `ralph/` — Ralph Loop

Autonomous coding agent that implements features by working through PRD user stories. See [`ralph/README.md`](ralph/README.md) for details.

| File | Purpose |
|---|---|
| `ralph_prompt.md` | Agent instructions for each Ralph iteration |
| `ralph.sh` | Bash script that runs the autonomous loop |
| `README.md` | Setup and usage guide |
