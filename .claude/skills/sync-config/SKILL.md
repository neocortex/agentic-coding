---
name: sync-config
description: "Compare local agentic-coding config files, skills, and commands against their global counterparts in ~/.claude/, ~/.agents/, and ~/.codex/. Use when the user wants to sync configs, check for drift between local and global settings/commands, or says things like 'sync config', 'check if configs match', 'compare settings', 'sync commands', 'are my configs in sync', or 'diff local vs global'."
disable-model-invocation: true
---

# Config Sync Check

Compare local project files against their global counterparts in `~/.claude/`, `~/.agents/`, and `~/.codex/`. Work through each comparison **one at a time** — check, report, resolve, then move to the next.

## How It Works

There are 8 comparisons to run (listed below). For each one:

1. **Read both files** and compare them
2. **Report the result** using this format:
   ```
   ## [N/8] [file pair]
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

## The 8 Comparisons

### 1. Skills: local `skills/` vs `~/.claude/skills/`

Compare each skill folder in the local `skills/` directory against `~/.claude/skills/`. Check:
- Skills that exist locally but not globally (and vice versa)
- For skills that exist in both places, diff the `SKILL.md` contents and any bundled resources

### 2. Skills: local `skills/` vs `~/.agents/skills/`

Same comparison but against `~/.agents/skills/`. Codex may not have a skills directory — if it doesn't exist, note that and move on.

### 3. Commands: local `commands/` vs `~/.claude/commands/`

Compare each file and subfolder in the local `commands/` directory against `~/.claude/commands/`. Check:
- Command files that exist locally but not globally (and vice versa)
- For commands that exist in both places, diff the file contents

Ignore `.claude/` subfolders inside `commands/` — those are project-local settings, not command files to sync.

### 4. Commands: local `commands/` vs `~/.codex/prompts/`

Same comparison but against `~/.codex/prompts/`. This directory may not exist — if it doesn't, note that and move on.

### 5. Settings: local `settings.json` vs `~/.claude/settings.json`

Diff the two files. Pay attention to:
- Permission differences (allow/deny lists)
- Plugin differences
- Hook differences
- Model and mode settings

When showing diffs, note which settings are local-only vs global-only vs different values for the same key. Filter out project-specific entries (like trusted project paths) that wouldn't make sense to sync.

### 6. Config: local `config.toml` vs `~/.codex/config.toml`

Diff the two files. **Always ignore `[projects.*]` trusted project entries** — these are private and live only in the global config. If the local `config.toml` contains any `[projects.*]` sections, remove them from local as part of the sync (no need to ask). Compare only the remaining settings (personality, model, approvals, plugins, etc.).

### 7. Instructions: local `CLAUDE.md` vs `~/.claude/CLAUDE.md`

Diff the two files. These are the instruction files that guide agent behavior. Even small differences can cause inconsistent behavior across projects.

### 8. Instructions: local `CLAUDE.md` vs `~/.codex/AGENTS.md`

Compare these two. They serve the same purpose (agent instructions) but for different tools. **Before diffing, normalize these expected naming substitutions** — they are intentional and must never be flagged:
- "CLAUDE.md" ↔ "AGENTS.md" (each file references itself)
- "Claude Code" ↔ "Codex"
- "Claude" ↔ "Codex" (when referring to the tool, not the model)

After normalizing, flag only substantive differences in rules, conventions, or instructions. If the only differences are naming, report as "In sync" and move on.

## Gotchas

- The local skills directory is `skills/` at the project root — **not** `.claude/skills/`. Only compare `skills/` against global.
- The local commands directory is `commands/` at the project root. Ignore any `.claude/` subfolder inside it (that's a project-local settings override, not a command).
- The local settings file is `settings.json` at the project root — **not** `.claude/settings.json` or `.claude/settings.local.json`.
- `~/.agents/skills/.system/` holds Codex's built-in skills — always ignore it.
- Codex paths are split: skills live in `~/.agents/skills/`, prompts (commands) live in `~/.codex/prompts/`, and `AGENTS.md` and `config.toml` live in `~/.codex/`.

## Important

- For JSON files, use structural comparison — reordered keys aren't meaningful differences
- For markdown files, focus on content differences, not whitespace
- Don't modify any files until the user explicitly says what to do
- If a global counterpart doesn't exist (e.g., `~/.agents/skills/` is empty), just report it and move on
