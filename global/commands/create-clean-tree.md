# Create Clean Tree

## Purpose

Clean the project's git working tree by reviewing current changes, grouping them semantically, and committing in meaningful batches with clear, conventional commit messages. End goal: a clean tree (no uncommitted changes, or a single coherent set of commits).

## Scope

**Local command.** Applies to the current repository. Use the project's branch and working tree only.

---

## Process

### 1. Inspect current state

- Run `git status` to see modified, added, and untracked files.
- Run `git diff` (and `git diff --staged` if anything is already staged) to understand what changed.
- Note which areas of the codebase are touched (e.g. docs, tests, one feature, refactor).

### 2. Plan semantic batches

- **Group changes by intent**, not just by file. Examples:
  - One batch: "Add ADR13 layout tests"
  - Another: "Fix typo in README"
  - Another: "Refactor SlideContent container classes"
- Prefer small, logical commits over one large "fix everything" commit.
- If changes mix multiple concerns, split into multiple commits (stage and commit one batch at a time).

### 3. Stage and commit each batch

- Stage only the files or hunks that belong to one batch: `git add <path>` or `git add -p` for partial staging.
- Commit with a **clear, semantic message**:
  - Good: `docs: accept ADR13 Option B and note implementation`, `test: update PitchDeckViewer layout tests for flex layout`, `refactor(slides): use h-full min-h-0 in slide types`.
  - Avoid: `updates`, `fix`, `WIP`, or messages that mix multiple unrelated changes.
- Repeat until all changes are committed or intentionally left unstaged (e.g. WIP you will commit later).

### 4. Verify

- Run `git status` to confirm the tree is clean (or only intended changes remain).
- Optionally run the project's test/lint commands to ensure nothing is broken.

---

## Notes

- Use git commands (e.g. `git status`, `git diff`, `git add`, `git commit`) to inspect and commit; run them in the project root.
- If the user wants to keep some changes unstaged (e.g. work-in-progress), say so in the final commit batch and leave those files unstaged.
- Prefer present tense, imperative messages: "add tests" not "added tests".
