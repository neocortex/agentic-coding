---
name: sync-config
description: "Compare local agentic-coding config files and skills against their global counterparts in ~/.claude/, ~/.agents/, and ~/.codex/. Use when the user wants to sync configs, check for drift between local and global settings/skills, or says things like 'sync config', 'check if configs match', 'compare settings', 'sync skills', 'are my configs in sync', or 'diff local vs global'."
disable-model-invocation: true
---

# Config Sync

Sync local project files with their global counterparts in `~/.claude/`, `~/.agents/`, and `~/.codex/`. The direction rules settle most differences — apply those without asking, and ask only about the rest.

## The 6 Comparisons

| # | Local | Global |
|---|---|---|
| 1 | `skills/` | `~/.claude/skills/` |
| 2 | `skills/` | `~/.agents/skills/` |
| 3 | `settings.json` | `~/.claude/settings.json` |
| 4 | `config.toml` | `~/.codex/config.toml` |
| 5 | — | `~/.claude/CLAUDE.md` must contain only the line `@~/.codex/AGENTS.md` |
| 6 | `AGENTS.md` | `~/.codex/AGENTS.md` |

Compare single differences, not whole files: a JSON or TOML key, a Markdown line or section, a skill file. Reordered JSON keys and Markdown whitespace aren't differences.

Comparison 5 needs no direction: Claude Code has no global `AGENTS.md`, so move any extra rules from `~/.claude/CLAUDE.md` into local `AGENTS.md` and reset the file to the import line. It runs before 6 so those rules then reach `~/.codex/AGENTS.md`.

## Direction Rules

A path's **base** is its version in the last sync commit:

```bash
S=$(git log -1 --format=%h --grep='^chore(config): sync local configs')
git show "$S:settings.json"                          # base version of a file
git diff --name-only "$S" -- <path>                  # local changed since base (incl. uncommitted)
git ls-files --others --exclude-standard -- <path>   # new untracked local files
```

For each difference, the first matching rule decides:

1. **Ignore** — it's on the ignore list. Don't sync it, don't mention it.
2. **Ask** — both local and global differ from base; or the change would delete something global; or a whole skill exists only globally and not in base (it may be a third-party install).
3. **Local → global** — local differs from base, global still equals base. The repo was edited.
4. **Local → `~/.agents/skills/`** — comparison 2 only, local matches `~/.claude/skills/`. Codex skills are a copy of the Claude ones, so this overwrites edits made only in `~/.agents/skills/`.
5. **Global → local** — local equals base. `/config`, the Codex app, and installers write to the global files, so global is usually newer.

## Ignore List

- Secrets such as `PLAYWRIGHT_MCP_EXTENSION_TOKEN` in `[mcp_servers.playwright.env]`. They never go into the repo.
- Codex machine state in `config.toml`: `[projects.*]`, `[hooks.state]`, `[tui] screen_reader_detection_done`. If local has `[projects.*]` sections, delete them from local.
- The Herdr `SessionStart` hook in `~/.claude/settings.json` — it runs a script on this machine.
- Skills managed by their own installers: `herdr`, `impeccable`.
- `~/.claude/skills/synced/` (Claude account sync) and `~/.agents/skills/.system/` (Codex built-ins).
- Generated files inside skills: `.venv/`, `uv.lock`, `__pycache__/`, `.DS_Store`.

When the user answers **Skip**, add that item here so it isn't asked again.

## Process

1. Run all 6 comparisons and sort every difference by the rules.
2. Apply every rule 3–5 difference. Edit key by key — never copy a whole `settings.json` or `config.toml` over the other, since each holds ignored entries that must stay. Copy skill files whole.
3. Ask about the rule 2 differences one at a time and wait for each answer. An item that shows up in several comparisons is one question:
   ```
   - `<item>` — local: <…>; global: <…>; base: <…>

   1. **<Option> (recommended)** — <concrete action> — <one-line reason>
   2. <Option> — <concrete action>
   3. <Option> — <concrete action>
   4. Custom — merge specific parts
   ```
   Options are **Update local**, **Update global**, **Skip**, and **Custom**, recommendation first.
4. Report one summary: a table with one row per comparison (`In sync` or what changed, with direction), then a **Global writes** list naming every global file changed — they aren't in git.
5. Offer to commit local changes as `chore(config): sync local configs with global counterparts`. The next sync uses that commit as its base.

## Gotchas

- The local skills directory is `skills/` at the project root — **not** `.claude/skills/`.
- The local settings file is `settings.json` at the project root — **not** `.claude/settings.json` or `.claude/settings.local.json`.
- Codex paths are split: skills live in `~/.agents/skills/`, and `AGENTS.md` and `config.toml` live in `~/.codex/`.
- If a global counterpart doesn't exist, report it and move on.
