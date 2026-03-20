---
name: prime-short
description: "Quick project context primer. A lighter version of the full prime skill — analyzes project structure, reads core docs and config, and checks recent git activity to produce a concise summary. Use when the user wants a quick overview of a project, wants to get up to speed fast, or says things like 'quick prime', 'give me a quick overview', 'what's this project about', or 'catch me up'."
disable-model-invocation: true
---

# Prime Short: Quick Project Context

Build a working understanding of the codebase quickly by focusing on structure, core docs, key config, and recent activity. This is the lightweight version — skip deep dives into tests and architecture docs, and produce a concise summary rather than a full report.

## Process

### 1. Analyze Project Structure

List all tracked files and show directory structure:

```bash
git ls-files
tree -L 3 -I 'node_modules|__pycache__|.git|dist|build'
```

- Examine the directory structure to understand project organization
- Identify the main entry points and core modules

### 2. Read Core Documentation

- Read CLAUDE.md or similar global rules file
- Read README files and other .md files at project root

### 3. Identify Key Files

Based on the structure, identify and read:
- Main entry points (main.py, index.ts, app.py, etc.)
- Core configuration files (*.toml, *.json, *.yaml)
- Important service or controller files

### 4. Understand Current State

Check recent activity and current status:

```bash
git log -10 --oneline
git status
```

## Output Report

Provide a concise summary and the last things that were worked on.
