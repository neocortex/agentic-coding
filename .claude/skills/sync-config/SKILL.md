---
name: sync-config
description: "Compare local agentic-coding config files and skills against their global counterparts in ~/.claude/, ~/.agents/, and ~/.codex/. Use when the user wants to sync configs, check for drift between local and global settings/skills, or says things like 'sync config', 'check if configs match', 'compare settings', 'sync skills', 'are my configs in sync', or 'diff local vs global'."
disable-model-invocation: true
---

# Config Sync Check

Compare local project files against their global counterparts in `~/.claude/`, `~/.agents/`, and `~/.codex/`. Work through each comparison **one at a time** — check, report, resolve, then move to the next.

## How It Works

There are 6 comparisons to run (listed below). For each one:

1. **Read both files** and compare them
2. **Report the result** using this format:
   ```
   ## [N/6] [file pair]
   Status: In sync | Differences found
   ```
3. **If in sync** — say so and immediately move to the next comparison
4. **If differences found** — report them in this shape, then **stop and wait for the user's response**:
   ```
   - `<item>` — <what differs, one line>

   1. **<Option> (recommended)** — <concrete action> — <one-line reason>
   2. <Option> — <concrete action>
   3. <Option> — <concrete action>
   4. Custom — merge specific parts
   ```
   The options are **Update local** (overwrite local with global), **Update global** (overwrite global with local), **Skip** (leave as-is; it may be intentional), and **Custom**. Always list your recommendation first, in bold, with a one-line reason.

   Keep it short:
   - One line per difference. No full file contents, no paragraphs.
   - Don't mention ignored items or preview later comparisons.
   - Mention a side effect only if it would change the user's decision.
5. **After the user responds** — apply their choice, confirm the result, then move to the next comparison

Only present ONE comparison at a time. Do not batch multiple comparisons into a single message. The user should see one diff, make one decision, and then see the next.

**Shortcut**: If the user gives a blanket instruction like "update all locals to match global" or "skip all remaining", apply it across all remaining comparisons without asking each time — but still report the status of each.

## The 6 Comparisons

### 1. Skills: local `skills/` vs `~/.claude/skills/`

Compare each skill folder in the local `skills/` directory against `~/.claude/skills/`. Check:
- Skills that exist locally but not globally (and vice versa)
- For skills that exist in both places, diff the `SKILL.md` contents and any bundled resources

### 2. Skills: local `skills/` vs `~/.agents/skills/`

Same comparison but against `~/.agents/skills/`. Codex may not have a skills directory — if it doesn't exist, note that and move on.

### 3. Settings: local `settings.json` vs `~/.claude/settings.json`

Diff the two files. Pay attention to:
- Permission differences (allow/deny lists)
- Plugin differences
- Hook differences
- Model and mode settings

When showing diffs, note which settings are local-only vs global-only vs different values for the same key. Filter out project-specific entries (like trusted project paths) that wouldn't make sense to sync.

### 4. Config: local `config.toml` vs `~/.codex/config.toml`

Diff the two files. **Always ignore `[projects.*]` trusted project entries** — these are private and live only in the global config. If the local `config.toml` contains any `[projects.*]` sections, remove them from local as part of the sync (no need to ask). Compare only the remaining settings (personality, model, approvals, plugins, etc.).

### 5. Instructions: local `AGENTS.md` vs `~/.codex/AGENTS.md`

Diff the two files. These are the instruction files that guide agent behavior for both Claude Code and Codex, so they must stay tool-neutral. Even small differences can cause inconsistent behavior across projects.

### 6. Instructions: `~/.claude/CLAUDE.md` imports `~/.codex/AGENTS.md`

Claude Code has no global `AGENTS.md`, so `~/.claude/CLAUDE.md` must contain only the import line `@~/.codex/AGENTS.md`. Anything else in it (e.g. an old copy of the rules) is a difference — **Update global** moves any extra rules into local `AGENTS.md`, then resets the file to the import line.

## Gotchas

- The local skills directory is `skills/` at the project root — **not** `.claude/skills/`. Only compare `skills/` against global.
- The local settings file is `settings.json` at the project root — **not** `.claude/settings.json` or `.claude/settings.local.json`.
- `~/.agents/skills/.system/` holds Codex's built-in skills — always ignore it.
- Codex paths are split: skills live in `~/.agents/skills/`, and `AGENTS.md` and `config.toml` live in `~/.codex/`.

## Important

- For JSON files, use structural comparison — reordered keys aren't meaningful differences
- For markdown files, focus on content differences, not whitespace
- Don't modify any files until the user explicitly says what to do
- If a global counterpart doesn't exist (e.g., `~/.agents/skills/` is empty), just report it and move on
