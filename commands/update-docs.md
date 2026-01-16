# Documentation Sync Check

Analyze the codebase and ensure all documentation is accurate and up to date.

## Instructions

1. **Discover documentation files** - Scan the repository for:
   - `README.md` (root and subdirectories)
   - `*.md` files that appear to be documentation (PRDs, guides, specs, architecture docs)
   - `docs/` or `documentation/` directories
   - Any `CONTRIBUTING.md`, `CHANGELOG.md`, `ARCHITECTURE.md`, etc.

2. **Analyze the codebase** - For each documentation file, understand:
   - What the doc claims to describe (features, APIs, setup, architecture)
   - The actual current state of the code it references
   - Any new features, files, or patterns not documented
   - Any documented features that no longer exist or work differently

3. **Identify gaps** - Flag only **substantial** discrepancies:
   - Missing documentation for major features or modules
   - Incorrect setup/installation instructions
   - Outdated API signatures or usage examples
   - Deprecated code paths still documented as current
   - New important directories or entry points not mentioned
   
   **Ignore minor issues** like typos, style preferences, or trivial version bumps.

4. **Report findings** - Before making changes, provide a concise summary:
   ```
   📄 [filename]
   Status: ✅ Up to date | ⚠️ Needs updates
   Gaps found: [brief list if any]
   ```

5. **Update if needed** - For files with substantial gaps:
   - Make **minimal, targeted edits** - don't rewrite entire docs
   - Preserve the original structure and style
   - Add missing information inline where it belongs
   - Remove or correct only clearly wrong information
   - Add a small "Last synced" note only if the project uses them

6. **Skip updates** when:
   - Changes would be purely cosmetic
   - The gap is minor or subjective
   - You're uncertain if something is intentionally undocumented

## Output Format

Start with a quick scan summary, then detail each file. End with a list of files updated (if any).

## Important

- Be conservative - documentation churn is annoying
- Prefer accuracy over completeness
- Match the existing doc style and tone
- Don't add boilerplate or fluff
- If a README is intentionally minimal, keep it minimal
