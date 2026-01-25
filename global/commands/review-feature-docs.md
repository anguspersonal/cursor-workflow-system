# review-feature-docs

This command will be available in chat with `/review-feature-docs`.

# review-feature-docs

Quality-check requirements, design, and tasks created by `/mk-req`, `/gen-design`, and `/gen-tasks`. The goal is to ensure the documents are implementation-ready, aligned with the current repo, and free of unresolved ambiguities. The design doc is the highest priority since it drives how the system will be built.

## Usage

`/review-feature-docs <path(s)> [--feedback-only]`

**Examples:**
- `/review-feature-docs docs/personal-invites/` - Review requirements.md, design.md, tasks.md in a feature folder
- `/review-feature-docs docs/personal-invites/requirements.md` - Review only requirements
- `/review-feature-docs docs/personal-invites/requirements.md docs/personal-invites/design.md` - Review multiple specific documents
- `/review-feature-docs docs/personal-invites/ --feedback-only` - Feedback only, no edits
- `/review-feature-docs docs/send-invites/requirements.md --feedback-only`

**Flags:**
- `--feedback-only`: Provide detailed feedback without editing files. Still perform repo and best-practice checks before asking clarifications.

## Core Principles

1. **Clarifications are the output, not formatting.** Focus on missing decisions, unresolved behavior, and contradictions. Formatting fixes are secondary.
2. **Do not ask for clarification until you have checked the repo and best practice.** Every question must be preceded by a brief analysis of:
   - How the current repo already does this (or closest analogue)
   - Recommended best practice for this project context
   - Why the document is still ambiguous after that analysis
3. **Resolve inconsistencies if confidence >= 60%.** If confidence < 60%, ask the user.
4. **Design doc gets the deepest review.** It must align with current project patterns and explicitly document how the feature will be built.
5. **Tasks must be well-divided with tests next to the behavior.** Unit tests should be coupled with the task they validate by default.

## Process

### Step 1: Identify Documents

1. **If a directory path is provided**:
   - Locate `requirements.md`, `design.md`, `tasks.md`
   - If none are found, report error and stop
2. **If file paths are provided**:
   - Validate files exist and are readable
   - Identify type by filename or content
3. **If multiple documents are provided**:
   - Keep cross-document context as you review

### Step 2: Repo and Pattern Baseline (Mandatory)

Before asking for any clarification:
- Inspect existing code or docs for similar features or patterns
- Identify preferred architectural patterns (state management, API access, data model style)
- Note naming conventions and file layout norms
- If a best-practice decision is obvious based on the repo, resolve it directly

### Step 3: Requirements Review (Clarification-Driven)

Focus on decisions missing from the requirements and assumptions that would change implementation.

**Check for:**
- Unspecified behavior, data formats, or edge cases that block design or tasks
- Conflicts between acceptance criteria or glossary vs. usage
- Requirements that conflict with current repo behavior
- Missing non-functional requirements only if they impact the design

**Clarification rule:**
- Build a list of required clarifications (with repo/best-practice analysis)
- Ask questions **one at a time** until resolved
- Do not ask if the answer can be inferred from repo patterns with confidence >= 60%

### Step 4: Design Review (Highest Priority)

The design must be consistent with how this repo actually builds features.

**Check for:**
- Architecture diagram reflects the real system layout and data flow
- Components, hooks, and services match existing patterns
- Interfaces and data models are realistic and reference existing types or schemas
- Implementation details name real files and integration points
- Error handling and testing strategy are aligned with project conventions
- Correctness properties map cleanly to requirements

**If design deviates from repo patterns:**
- Propose a concrete adjustment based on existing code
- Only ask for clarification if multiple viable patterns exist and confidence < 60%

### Step 5: Tasks Review (Implementation-Ready)

Tasks should be sized and sequenced for execution, with tests adjacent to the behavior.

**Check for:**
- Clear chunking with 1-4 hour subtasks
- Dependency order is correct
- Each subtask has concrete files, symbols, or interfaces
- Requirement coverage is complete
- **Default testing placement**: unit tests appear immediately after the task that creates the behavior
- Property tests appear next to high-risk logic they validate

### Step 6: Cross-Document Consistency

- Requirements ↔ Design: Every requirement is addressed in the design
- Design ↔ Tasks: Every design element has a task
- Requirements ↔ Tasks: All acceptance criteria are covered by tasks

### Step 7: Clarification Workflow (Sequential)

When clarifications are required:
1. Present the **clarification list** with:
   - What is ambiguous
   - What the repo currently does (or closest analogue)
   - Best-practice recommendation
   - Confidence score (0-100)
2. Ask **one question at a time** in priority order
3. After each answer, update the remaining list and proceed to the next
4. Stop when all clarifications are resolved

### Step 8: Output

**If `--feedback-only`:**
- Provide a review report with:
  - Clarifications needed (sequential list)
  - Inconsistencies and how you resolved or need input
  - Design quality issues and alignment with repo patterns
  - Task breakdown issues and test placement feedback

**If improve mode (default):**
- Apply direct fixes where confidence >= 60%
- Document any changes made
- List clarifications still needed (and ask the first question)

## Output Format

```markdown
# Review: [Document Name(s)]

## Clarifications Needed (sequential)
1. [Clarification title]
   - Repo behavior: [what exists today]
   - Best practice: [recommendation]
   - Why unclear: [what is missing]
   - Confidence: [0-100]

## Inconsistencies Resolved
- [Issue] -> [Resolution] (Confidence: [0-100])

## Design Review Highlights
- [Gap or improvement tied to current repo patterns]

## Tasks Review Highlights
- [Chunking or test placement issue]

## Next Question
[Ask the first clarification question only]
```

## Important Notes

- **Design-first review**: The design doc must be brilliant and aligned with project patterns.
- **Clarification discipline**: Never ask without repo + best-practice analysis.
- **Resolve if confident**: If confidence >= 60%, resolve and document the decision.
- **Sequential questions**: Ask only one clarification at a time.
- **Tests by default**: Unit tests should be adjacent to the task they validate.
- **Preserve intent**: Do not overwrite scope; only clarify and align.

## Exit Criteria

- ✅ Requirements, design, and tasks reviewed
- ✅ Repo patterns consulted before clarifications
- ✅ Inconsistencies resolved or clarified
- ✅ Design aligned with current project approach
- ✅ Tasks are well-chunked and test placement is correct
- ✅ First clarification question asked (if any remain)

