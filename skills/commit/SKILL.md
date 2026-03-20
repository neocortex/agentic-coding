---
name: commit
description: Create git commits with conventional commit message format. Use this skill whenever the user wants to commit changes, save progress, create a commit, or says things like "commit this", "commit my changes", "make a commit", "save these changes to git", or any variation of committing code. Also trigger when the user finishes a task and wants to wrap up with a commit, or asks to stage and commit files.
---

# Commit: Create Git Commit with Conventional Format

## Commit Instructions

$ARGUMENTS

If no specific instructions are provided (such as which files or changes to commit), commit all current changes — or if the changes are logically distinct, suggest how to break them into multiple focused commits.

## Commit Process

### 1. Review Current State

Check git status to understand what's changed:

```bash
git status
```

Review both staged and unstaged diffs to understand the full picture:

```bash
git diff --cached
git diff
```

### 2. Analyze Changes

Examine the diff and determine the following:

**Type of change:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation only
- `test`: Adding or updating tests
- `chore`: Maintenance (deps, config, etc.)
- `perf`: Performance improvement
- `style`: Code style/formatting

**Scope** (optional but helpful): the component or area affected — e.g., `api`, `auth`, `ui`, `db`.

**Subject line**: a brief imperative-mood summary of 50 characters or less ("add X" not "added X").

**Body** (when the subject alone isn't enough): explain *why* the change was made, any important context, and what it affects.

**Breaking changes**: note any breaking changes in the footer.

### 3. Stage Files

If the commit targets specific related files, stage only those:

```bash
git add <file1> [<file2> ...]
```

If the commit intentionally covers all current changes:

```bash
git add .
```

Never mix unrelated changes in a single commit — if the working tree has unrelated changes, stage selectively and explain why.

### 4. Create Commit

Format the message using conventional commits:

```
type(scope): subject

[optional body]

[optional footer]
```

**Example:**
```
feat(auth): add JWT-based authentication

Implements token-based auth with:
- Login endpoint with credentials validation
- Token generation and verification
- Protected route middleware

Tests added for all auth flows
```

Execute:

```bash
git commit -m "[commit message]"
```

For multi-line messages, use a heredoc:

```bash
git commit -m "$(cat <<'EOF'
type(scope): subject

Body text here.
EOF
)"
```

### 5. Confirm Success

Verify the commit and show a summary:

```bash
git log -1 --oneline && git show --stat
```

## Output Report

After committing, report:

- **Commit hash**
- **Full commit message**
- **Files committed** with change stats
- **Summary**: files changed, insertions, deletions

## Important Rules

- If there are no changes to commit, say so clearly — don't create an empty commit.
- If a pre-commit hook fails, report the error and help fix the underlying issue. Do not use `--no-verify`.
- Follow the project's existing commit conventions if they differ from conventional commits.
- Never mention "Claude" or "Claude Code" as co-author in commit messages.
