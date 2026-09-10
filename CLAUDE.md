# CLAUDE.md 

This file provides comprehensive guidance to Claude Code when working with Python code.

## Core Development Philosophy

KISS (Keep It Simple, Stupid)
Simplicity should be a key goal in design. Choose straightforward solutions over complex ones whenever possible. Simple solutions are easier to understand, maintain, and debug.

YAGNI (You Aren't Gonna Need It)
Avoid building functionality on speculation. Implement features only when they are needed, not when you anticipate they might be useful in the future.

## Code Structure & Development Rules

- Max. 500 lines per file - split larger files into modules
- Line length should be max 119 characters ruff rule in pyproject.toml
- Organize code into clearly separated modules, grouped by feature or responsibility
- Match existing code style over external standards
- Keep naming evergreen (no "new", "improved", "enhanced")
- Prefer simple, maintainable solutions over clever/complex ones
- Readability and maintainability are primary concerns
- NEVER use --no-verify when committing
- NEVER remove existing comments unless provably false
- NEVER reimplement without permission - update existing code
- NEVER fix unrelated issues - document in new issue instead
- NEVER use mock implementations - always real data/APIs
- Make smallest reasonable changes for desired outcome
- Single Responsibility: Each function, class, and module should have one clear purpose.
- IMPORTANT: Never mention "Claude" or "Claude Code" as co-author in commit messages

## Documentation

- Every module should have a docstring explaining its purpose
- Write Google-style docstrings for all functions
- Public functions must have complete docstrings
- Comment non-obvious code for mid-level developer understanding
- Complex logic should have inline comments with # Reason: prefix
- Keep comments evergreen (no temporal references like "recent changes" or "refactored")
- Keep README.md and other documentation markdown files updated for new features/dependencies with setup instructions and examples
- Maintain CHANGELOG.md for version history

## Python Setup & Development Environment

- Use uv exclusively:
```bash
# Create virtual environment
uv venv

# Sync dependencies
uv sync

# Add a package ***NEVER UPDATE A DEPENDENCY DIRECTLY IN PYPROJECT.toml***
# ALWAYS USE UV ADD
uv add requests

# Add development dependency
uv add --dev pytest ruff mypy

# Remove a package
uv remove requests

# Run commands in the environment
uv run python script.py
uv run pytest
uv run ruff check .

# Install specific Python version
uv python install 3.12
```
- Activate venv: source .venv/bin/activate
- Ensure pyproject.toml exists (create with uv init if missing)

## Testing

- Write Pytest tests for all features in /tests folder
- Include: expected uses, edge cases, failure cases
- Update tests when logic changes
- Test output must be pristine - capture expected errors
- NO EXCEPTIONS: All projects need unit, integration, and E2E tests unless explicitly authorized to skip
- Testing commands:
```bash
# Run all tests
uv run pytest

# Run specific tests with verbose output
uv run pytest tests/test_module.py -v

# Run tests with coverage
uv run pytest --cov=src --cov-report=html
```
## Style

- Python with PEP8 with line-width: 119
- Use double quotes for strings
- Always use type hints for function signatures and class attributes
- Use ruff for formatting and linting:
```bash
# Format code
uv run ruff format . --line-length 119

# Check linting
uv run ruff check .

# Fix linting issues automatically
uv run ruff check --fix .
```

## Important notes 

- NEVER ASSUME OR GUESS - When in doubt, ask for clarification
- Request help when stuck
- Always verify file paths and module names before use
- Keep CLAUDE.md updated when adding new patterns or dependencies
- Test your code - No feature is complete without tests
- Document your decisions - Future developers (including yourself) will thank you
- ULTRATHINK before major changes

## Behavioural Guidelines

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
