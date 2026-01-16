# Ralph Loop

Autonomous coding agent that implements features by working through PRD user stories in isolation.

## Overview

Ralph Loop runs in a sandboxed Docker environment, working on one user story at a time. It implements code, runs quality checks, commits changes, and learns patterns across iterations until all stories are complete.

## Quick Start

### 1. Create PRD

You can discuss feature requirements with Claude Code in plan mode before creating your PRD. When ready, use the slash command to generate a structured PRD providing your feature description:

```bash
/ralph-create-prd "your feature description"
```

This creates `prd-[feature-name].md` with user stories and acceptance criteria.

### 2. Convert to JSON

Convert the markdown PRD to Ralph's execution format (recommended by [Anthropic](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)):

```bash
/ralph-prd-to-json prd-[feature-name].md
```

This creates `ralph_prd.json` with structured user stories for execution.

### 3. Run the Loop

Execute the autonomous loop:

```bash
./ralph.sh [max_iterations]
```

Ralph will work through stories, implement code, run quality checks, commit changes, and update progress until complete.

## How It Works

### The Loop Cycle

Each iteration:
1. **Read context**: PRD (`.md` for context, `.json` for execution) and `ralph_progress.txt`
2. **Pick story**: Highest priority where `passes: false`
3. **Implement**: Single user story, following codebase patterns
4. **Verify**: Run quality checks (`typecheck`, `lint`, `tests`)
5. **Commit**: Automated commit with `feat: [Story ID] - [Story Title]`
6. **Update**: Mark story `passes: true` in JSON, append to progress log
7. **Learn**: Document patterns and gotchas for future iterations

### Sandbox Environment

Runs in Docker with `--permission-mode acceptEdits` to safely make changes without manual approval for each edit.

### Progress Tracking

`ralph_progress.txt` accumulates:
- Completed stories with timestamps
- Files changed per story
- **Codebase Patterns**: Reusable learnings (read first each iteration)
- Gotchas and non-obvious details

### Stop Condition

When all stories have `passes: true`, Ralph outputs `<promise>COMPLETE</promise>` and exits.

## Files

- `ralph_prompt.md` - Agent instructions (what to do each iteration)
- `ralph_prd.md` - Human-readable PRD (context only)
- `ralph_prd.json` - Structured PRD for execution
- `ralph_progress.txt` - Cumulative progress log with patterns
- `ralph.sh` - Bash script that runs the loop

## Story Guidelines

### Keep Stories Small

Each story must complete in ONE iteration (one context window):
- ✅ Add database column and migration
- ✅ Add UI component to existing page
- ✅ Update server action with new logic
- ❌ "Build entire dashboard" (split into: schema, queries, UI, filters)

**Rule of thumb:** If you can't describe it in 2-3 sentences, split it.

### Order by Dependencies

Earlier stories must not depend on later ones:
1. Schema/database changes (migrations)
2. Server actions / backend logic
3. UI components using the backend
4. Dashboard/summary views

### Verifiable Acceptance Criteria

Each criterion must be checkable, not vague:
- ✅ "Add `status` column with default 'pending'"
- ✅ "Filter dropdown has options: All, Active, Completed"
- ✅ "Clicking delete shows confirmation dialog"
- ❌ "Works correctly"
- ❌ "Good UX"

## Tips

- Ralph learns from patterns in `ralph_progress.txt` - add architectural decisions there
- Failed iterations help Ralph learn what NOT to do
- Review progress log between runs to track pattern discovery
- Delete project-specific PRD files when done, but keep `README.md` and `ralph.sh`

## Configuration

Default: 10 iterations max. Override with:
```bash
./ralph.sh 20
```

## Requirements

- Docker
- Claude CLI with sandbox support
- Valid PRD in JSON format

## References

Learn more at: https://github.com/snarktank/ralph
