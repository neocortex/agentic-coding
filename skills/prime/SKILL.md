---
name: prime
description: "Prime the agent with deep codebase understanding. Analyzes project structure, documentation, key files, architecture, tech stack, and recent git activity to produce a comprehensive project overview. Use when the user wants to onboard onto a project, understand a codebase, get a project summary, or says things like 'prime yourself', 'learn this codebase', 'understand this project', 'what is this repo', or 'give me a project overview'."
disable-model-invocation: true
---

# Prime: Load Project Context

Build comprehensive understanding of the codebase by analyzing structure, documentation, and key files. The goal is to produce a report that gives a clear mental model of the project — what it does, how it's organized, what it's built with, and what's been happening recently.

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
- Read README files at project root and major directories
- Search for and read all other documentation files in the project root and subfolders
- Read any architecture documentation

### 3. Identify Key Files

Based on the structure, identify and read:
- Main entry points (main.py, index.ts, app.py, etc.)
- Core configuration files (*.toml, *.json, *.yaml)
- Key model/schema definitions
- Important service or controller files
- Look for tests to understand expected behavior

### 4. Understand Current State

Check recent activity and current status:

```bash
git log -10 --oneline
git status
```

## Output Report

Provide a concise, scannable summary covering:

### Project Overview
- Purpose and type of application
- Primary technologies and frameworks
- Current version/state

### Architecture
- Overall structure and organization
- Key architectural patterns identified
- Important directories and their purposes

### Tech Stack
- Languages and versions
- Frameworks and major libraries
- Build tools and package managers
- Testing frameworks

### Core Principles
- Code style and conventions observed
- Documentation standards
- Testing approach

### Current State
- Active branch
- Recent changes or development focus
- Any immediate observations or concerns

Use bullet points and clear headers — make it easy to scan.
