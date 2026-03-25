---
name: sync-config
description: "Compare local agentic-coding config files and skills against their global counterparts in ~/.claude/ and ~/.agents/. Use when the user wants to sync configs, check for drift between local and global settings, or says things like 'sync config', 'check if configs match', 'compare settings', 'are my configs in sync', or 'diff local vs global'."
disable-model-invocation: true
---

# Config Sync Check

Compare local project files against their global counterparts in `~/.claude/` and `~/.agents/`. Work through each comparison **one at a time** — check, report, resolve, then move to the next.

## How It Works

There are 6 comparisons to run (listed below). For each one:

1. **Read both files** and compare them
2. **Report the result** using this format:
   ```
   ## [N/6] [file pair]
   Status: In sync | Differences found
   ```
3. **If in sync** — say so and immediately move to the next comparison
4. **If differences found** — show a concise summary of what differs (meaningful deltas only, not full file contents), then present these options and **stop and wait for the user's response**:
   - **Update local** — overwrite the local file with the global version
   - **Update global** — overwrite the global file with the local version
   - **Skip** — leave the difference as-is (it may be intentional)
   - **Custom** — the user may want to merge specific parts
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

### 4. Config: local `config.toml` vs `~/.agents/config.toml`

Diff the two files. Same approach — highlight meaningful differences, filter out project-specific entries (trusted project paths).

### 5. Instructions: local `CLAUDE.md` vs `~/.claude/CLAUDE.md`

Diff the two files. These are the instruction files that guide agent behavior. Even small differences can cause inconsistent behavior across projects.

### 6. Instructions: local `CLAUDE.md` vs `~/.agents/agents.md`

Compare these two. They serve the same purpose (agent instructions) but for different tools, so expect some intentional differences (e.g., "CLAUDE.md" vs "AGENTS.md" self-references, "Claude Code" vs "Codex" naming). Flag only substantive differences in rules, conventions, or instructions.

## Gotchas

- The local skills directory is `skills/` at the project root — **not** `.claude/skills/`. Only compare `skills/` against global.

## Important

- For JSON files, use structural comparison — reordered keys aren't meaningful differences
- For markdown files, focus on content differences, not whitespace
- Don't modify any files until the user explicitly says what to do
- If a global counterpart doesn't exist (e.g., `~/.agents/skills/` is empty), just report it and move on
