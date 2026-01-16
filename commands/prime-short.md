# Project Context Short 

> Follow the instructions to understand the project

---
description: Prime agent with codebase understanding
---

# Prime: Load Project Context

## Objective

Build comprehensive understanding of the codebase by analyzing structure, documentation, and key files.

## Process

### 1. Analyze Project Structure

List all tracked files:
!`git ls-files`

Show directory structure:
!`tree -L 3 -I 'node_modules|__pycache__|.git|dist|build'`

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

Check recent activity:
!`git log -10 --oneline`

Check current branch and status:
!`git status`

## Output Report

Provide a concise summary and the last things that were worked on.
