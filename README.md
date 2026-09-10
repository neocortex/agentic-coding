# Agentic Coding

Portable agentic coding configurations, skills, and tools for Claude Code and Codex.

For Codex `AGENTS.md`, make a copy of `CLAUDE.md` and swap "Claude"/"Claude Code" for "Codex".

## Repository Structure

### Root Config Files

| File | Purpose | Global Counterpart |
|---|---|---|
| `CLAUDE.md` | Agent instructions (code style, dev rules, tooling) | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` |
| `settings.json` | Claude Code settings (permissions, hooks, plugins, model) | `~/.claude/settings.json` |
| `config.toml` | Codex settings (model, approvals, plugins) | `~/.codex/config.toml` |

### `skills/` — Portable Skills

Skills invocable via `/skill-name` in Claude Code. Global counterparts: `~/.claude/skills/` and `~/.agents/skills/`. All are user-invocable only (`disable-model-invocation: true`) unless noted.

| Skill | Description |
|---|---|
| `commit` | Create git commits with conventional commit format. Model-invocable. |
| `audit-codebase` | KISS manifesto codebase audit with actionable report and KISS score. |
| `excalidraw-diagram` | Create Excalidraw diagram JSON files that visualize workflows, architectures, or concepts. Model-invocable. |
| `handoff` | Write a session handoff document so the next agent or session can continue the work. Model-invocable. |
| `prime` | Deep codebase primer — structure, docs, key files, architecture, tech stack. |
| `ralph-create-prd` | Generate structured PRDs with user stories and acceptance criteria. |
| `ralph-prd-to-json` | Convert markdown PRDs to Ralph's JSON execution format. |
| `update-docs` | Scan and sync documentation against current code state. |

### `commands/` — Slash Commands

Commands invocable via `/command-name` in Claude Code. Global counterpart: `~/.claude/commands/`.

| Command | Description |
|---|---|
| `create_prd` | Create a Product Requirements Document from the conversation. |

### `.claude/skills/` — Project Skills

Skills specific to this project's workflow, loaded automatically by Claude Code.

| Skill | Description |
|---|---|
| `sync-config` | Compare local configs, skills, and commands against their global `~/.claude/`, `~/.agents/`, and `~/.codex/` counterparts. Reports diffs one at a time with a recommended resolution. |

### `ralph/` — Ralph Loop

Autonomous coding agent that implements features by working through PRD user stories. See [`ralph/README.md`](ralph/README.md) for details.

| File | Purpose |
|---|---|
| `ralph_prompt.md` | Agent instructions for each Ralph iteration |
| `ralph.sh` | Bash script that runs the autonomous loop |
| `README.md` | Setup and usage guide |
