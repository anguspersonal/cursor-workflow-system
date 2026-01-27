# Commands Overview

Your global commands and how they work together.

## Command Inventory

You have **10 global commands** that form a complete development workflow:

### 🎯 Feature Planning & Design

#### `/discuss` - Feature Debate & Validation
**Purpose:** Conversational debate about feature desirability and feasibility  
**Modes:** `--chat` (default), `--doc` (captures to discussion.md)  
**Output:** Decision (proceed/defer/reject) + scope statement  
**Handoff:** Usually → `/mk-req`

#### `/mk-req` - Requirements Creation
**Purpose:** Create structured requirements document from discussion  
**Input:** Feature scope from `/discuss`  
**Output:** `requirements.md` with acceptance criteria  
**Handoff:** → `/gen-design`

#### `/gen-design` - Design Document Generation
**Purpose:** Generate technical design from requirements  
**Input:** `requirements.md`  
**Output:** `design.md` with architecture details  
**Handoff:** → `/gen-tasks`

#### `/gen-tasks` - Task File Generation
**Purpose:** Generate structured implementation tasks from requirements + design  
**Input:** `requirements.md` + `design.md`  
**Flags:**
- `--includeLegacyTestStep` - Include old verification checklist (prefer `/implement-g`)
- `--testAtEnd` - Group tests at end instead of alongside implementation
- `--testLevel <minimal|medium|production>` - Control test coverage guidance  
**Output:** `tasks.md` with checkbox task list  
**Handoff:** → `/implement-g`

---

### ⚙️ Implementation & Quality

#### `/implement-g` - Global Implementation with Checks
**Purpose:** Implement tasks with automatic quality checks before commit  
**Usage:** `/implement-g [--require-previous-success | -rps] <task description or IDs>`  
**Flags:**
- `-rps` / `--require-previous-success` - Only run if previous command succeeded (chaining)  
**Process:**
1. Implement specified tasks
2. Run type checking
3. Run linting
4. Run tests
5. Run build
6. Stage and commit changes  
**Output:** Working code + passing tests + git commit  
**Adapts to:** Monorepos (turbo), single packages, various build tools

#### `/code-review` - Comprehensive Code Review
**Purpose:** Review code for quality, correctness, best practices  
**Usage:** `/code-review <path(s)> [--suggest-fixes] [--check-tests] [--check-requirements]`  
**Flags:**
- `--suggest-fixes` - Provide concrete code improvement suggestions
- `--check-tests` - Verify test coverage
- `--check-requirements` - Check alignment with requirements docs  
**Priority Levels:** Critical → High → Medium → Low  
**Output:** Detailed review report with prioritized issues  
**Focus:** TypeScript, React patterns, correctness, security, accessibility

#### `/fix` - Fix Stale Tests
**Purpose:** Run and fix the most stale unit tests in repo  
**Usage:** `/fix [-<number>]` (e.g., `/fix -5` to fix 5 tests)  
**Tracking:** Uses `testlog.json` to track test staleness  
**Process:**
1. Audit `testlog.json` for stale tests
2. Select most stale test (never run, or oldest timestamp)
3. Run test with timeout
4. Fix failures iteratively
5. Update `testlog.json` with current timestamp  
**Output:** Passing tests + updated test log

---

### 📝 Documentation & Review

#### `/review-feature-docs` - Feature Documentation Review
**Purpose:** Review feature documentation  
*(Details to be explored in actual command file)*

#### `/command-improve` - Command Improvement
**Purpose:** Improve existing commands  
*(Details to be explored in actual command file)*

---

### 🤖 Experimental

#### `/ralph-manual` - Autonomous PRD Implementation
**Purpose:** Autonomous agent loop for implementing features from PRD  
**Input:** `ralph/prd.json` + `ralph/progress.txt`  
**Process:**
1. Read PRD, find highest-priority ready feature
2. Mark as 'in progress'
3. Implement feature completely
4. Run typecheck + tests (must pass)
5. Update PRD status to 'done'
6. Append to progress log
7. Make git commit
8. Continue to next feature  
**Rules:**
- No questions, no summaries - implement immediately
- Cannot mark 'done' if checks fail
- One feature per iteration  
**Output:** `<promise>FEATURE_COMPLETE</promise>` or `<promise>COMPLETE</promise>`

---

## The Complete Workflow

```mermaid
graph TB
    A[Feature Idea] --> B[/discuss]
    B --> C{Proceed?}
    C -->|Yes| D[/mk-req]
    C -->|No| Z[Defer/Reject]
    D --> E[/gen-design]
    E --> F[/gen-tasks]
    F --> G[/implement-g]
    G --> H[/code-review]
    H --> I{Issues?}
    I -->|Yes| J[/fix]
    J --> G
    I -->|No| K[Done]
```

**Typical Flow:**
1. `/discuss` - Validate the idea
2. `/mk-req` - Document requirements
3. `/gen-design` - Technical design
4. `/gen-tasks` - Break into tasks
5. `/implement-g` - Implement with quality checks
6. `/code-review` - Review quality
7. `/fix` - Fix any issues

**Quick Iterations:**
- Skip to `/implement-g` for clear, small changes
- Use `/fix` regularly to prevent test decay
- Use `/code-review --suggest-fixes` for quick feedback

---

## Command Chaining

### Sequential Implementation with Safety

```bash
/implement-g task 1.1
/implement-g -rps task 1.2  # Only runs if 1.1 succeeded
/implement-g -rps task 1.3  # Only runs if 1.2 succeeded
```

The `-rps` flag creates a safety chain - if any task fails, subsequent tasks won't run.

---

## Tips & Best Practices

1. **Start with `/discuss`** for non-trivial features to validate before building
2. **Use `/gen-tasks --testLevel`** to control test coverage expectations
3. **Chain `/implement-g` calls** with `-rps` for safe sequential implementation
4. **Run `/fix` regularly** to keep tests healthy (prevents test debt)
5. **Use `/code-review`** after major changes to catch issues early
6. **Try `/ralph-manual`** for experimental autonomous implementation

---

## Customization

These commands are in `global/commands/` and sync to `~/.cursor/commands/`:

- Edit command files here to customize behavior
- Add new commands by creating new `.md` files
- Run `scripts/sync-global.ps1` (Windows) or `scripts/sync-global.sh` (Unix) to apply changes

---

## Related Documentation

- [best-practices.md](../learnings/best-practices.md) - Detailed workflow patterns
- [CursorDocs.md](../docs/CursorDocs.md) - Complete Cursor documentation
- [VISION.md](../docs/VISION.md) - Why this repo exists
