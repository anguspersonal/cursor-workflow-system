# Generate Tasks from Requirements

Generate a structured implementation task file from a feature folder’s `requirements.md` and `design.md`. This command analyzes those documents and creates a comprehensive task breakdown following the project's standard task file format.
How 
## Usage

`/genTasks <path-to-requirements-file> [output-path] [--includeLegacyTestStep] [--testAtEnd] [--testLevel <minimal|medium|production>]`

**Examples:**
- `/genTasks docs/styling/requirements.md` - Generate tasks.md in the same directory as requirements.md (no verification sections)
- `/genTasks docs/slideVariantMgmt/requirements.md docs/slideVariantMgmt/tasks.md` - Generate tasks.md at specific path (no verification sections)
- `/genTasks docs/styling/requirements.md --includeLegacyTestStep` - Generate tasks.md including the legacy “Run checks and tests” step (not recommended; prefer `/implement-g`)
- `/genTasks docs/styling/requirements.md --testAtEnd` - Generate tasks.md that groups most tests into dedicated testing tasks near the end (instead of next to the step that introduced the behavior)
- `/genTasks docs/styling/requirements.md --testLevel medium` - Generate tasks.md with broader test coverage guidance (unit + e2e expectations)
- `/genTasks docs/styling/requirements.md --testLevel production` - Generate tasks.md with production-ready coverage guidance (unit + integration + e2e + property tests + operational checks)

**Flag:**
- `--includeLegacyTestStep`: Include the legacy “Run checks and tests” verification section after each main task. This step existed in essentially all `tasks.md` files before we created `/implement-g` (which includes checks as part of implementation). Prefer using `/implement-g` instead of generating this legacy step.
- `--testAtEnd`: Use “tests toward the end” task style (Option 2) instead of “tests alongside the step that introduced the behavior” (Option 1, default).
- `--testLevel <minimal|medium|production>`: Controls how much test coverage guidance is generated.
  - `minimal` (default): only call out essential tests/property tests for risky or complex logic
  - `medium`: unit + e2e expectations for most user-visible behavior (plus targeted property tests)
  - `production`: production-ready test guidance (unit + integration + e2e + property + regression/ops checks where applicable)

## Process

### Step 1: Read and Analyze Inputs (Required)
1. Fully read `requirements.md` from the specified path.
2. Fully read `design.md` from the same directory as `requirements.md`.
   - If `design.md` is missing, or its location is unclear, **STOP and ask for clarification** before generating tasks.
3. Treat `requirements.md` + `design.md` as the **source of truth**. The task plan must stick closely to them:
   - Do **not** invent scope, endpoints, schemas, UI behaviors, or file locations that aren’t supported by those documents.
   - If there is a mismatch between the documents, **STOP and ask for clarification** (do not guess which is correct).
4. Identify all numbered requirements (e.g., "Requirement 1", "Requirement 2") and acceptance criteria.
5. Extract implementation-relevant details from `design.md` (architecture, modules, flows, data shapes, boundaries, constraints).
6. Identify glossary terms and technical context.
7. Understand the project structure and technology stack (only as needed to map design/requirements to concrete tasks).

### Step 2: Generate Task Structure
Create a task file with the following structure:

1. **Main Tasks**: Group related requirements into logical implementation phases
   - Each main task should represent a cohesive unit of work
   - Number tasks sequentially (1, 2, 3, ...)
   - Start with unchecked checkboxes: `- [ ]`

2. **Subtasks**: Break down each main task into specific implementation steps
   - Number subtasks hierarchically (1.1, 1.2, 1.3, ...)
   - Each subtask should be a single, actionable item
   - Include specific file paths, function names, or implementation details when mentioned in requirements
   - Start with unchecked checkboxes: `- [ ]`

3. **Implementation Details**: For each subtask, include:
   - Specific implementation steps (bulleted list)
   - File paths to modify/create
   - Function/component names
   - Configuration changes
   - Database changes (if applicable)

3.1 **Human Input Required (External Setup)**:
   - If any subtask requires setup outside the repo or user action (e.g., accounts, credentials, system settings, third-party dashboards), add a heading:
     - `**human input required**`
   - Place this heading directly above the step(s) that require the external action.
   - Keep the associated subtask checkbox unchecked.

4. **Requirements References**: For each subtask, include:
   - `_Requirements: X.Y, X.Z_` format
   - Reference the requirement number and acceptance criteria numbers that the subtask addresses

5. **Property Tests**: Mark test tasks with `*`:
   - Format: `- [ ]* X.Y Write property test for [description]`
   - Include: **Property N: [Name]** and **Validates: Requirements X.Y, X.Z**

6. **Legacy Verification Step (Optional)**: **ONLY IF `--includeLegacyTestStep` FLAG IS PROVIDED**
   - After each main task (or logical grouping), include the legacy “Run checks and tests” section
   - Include standard verification steps (type checking, linting, tests, build)
   - Include exit criteria
   - **If `--includeLegacyTestStep` flag is NOT provided**: Omit these legacy verification sections. Testing and checks will be handled by `/implement-g` as part of implementation.

### Step 3: Task Organization Principles

**Grouping Strategy:**
- Group by technical layer (database → backend → frontend → UI)
- Group by feature area (e.g., all theme-related tasks together)
- Group by dependency order (prerequisites first)
- Consider logical workflow (setup → implementation → integration → testing)

**Task Granularity:**
- Each subtask should be completable in 1-4 hours
- Each subtask should have clear, testable outcomes
- Avoid tasks that are too large or too small
- Break complex tasks into multiple subtasks

**Naming Conventions:**
- Use action verbs: "Create", "Update", "Implement", "Add", "Remove"
- Be specific: "Update PitchDeckViewer to read deck parameter" not "Update component"
- Include context: "Add deckSlug parameter to TrackEventParams interface"

### Step 4: Legacy Verification Section (Conditional)

**ONLY include this section if the `--includeLegacyTestStep` flag is provided.**

This is a legacy checklist step that used to be included inside most `tasks.md` files, before we created `/implement-g` (which already includes checks and tests as part of implementation). Use this only when you explicitly want the task file itself to carry the checklist.

For each main task, include a "Run checks and tests" section with:

```markdown
- [ ] (Legacy) Run checks and tests (prefer `/implement-g`)
  - **Order matters**: Run checks from fastest to slowest for quick feedback
  - [ ] Double check all the steps above (tasks X.Y, X.Z) have actually been implemented in code.
  - [ ] Type checking: Run `npx tsc --noEmit` (or check if build includes type checking)
    - If failures: Fix type errors in code. Iterate until pass.
    - If no tsc available: Type checking will happen during build step
  - [ ] Linting: Run `npm run lint`
    - If failures: Fix linting errors in code. Iterate until pass.
    - If auto-fixable: Consider running with `--fix` flag first
  - [ ] Tests: Run `npm test` (specifically verify task X.Y property test passes)
    - If failures: Analyze test output to determine if issue is in code or test
    - Fix code if test expectations are correct, or fix test if expectations are wrong
    - **If code was fixed**: Re-run Type Check and Lint to ensure fixes are valid, then re-run Tests
    - Iterate until all tests pass
  - [ ] Build: Run `npm run build`
    - If failures: Fix build errors (usually TypeScript or import issues)
    - **If code was fixed**: Re-run Type Check and Lint to ensure fixes are valid, then re-run Tests, before running Build again
    - Iterate until build succeeds
  - [ ] Once done, mark all checkboxes in this step (Type checking, Linting, Tests, Build) as done `[x]`
  - **Exit criteria**: All checks pass without errors or warnings (unless warnings are expected/acceptable)
```

For tasks that should be committed after completion, add:
```markdown
  - [ ] **CRITICAL FINAL STEP**: Once all checks pass, you MUST:
    1. Mark all checkboxes in this step (Type checking, Linting, Tests, Build) as done `[x]`
    2. Stage all changes: Run `git add .` (or `git add -A`)
    3. Commit all changes: Run `git commit -m "Complete task X: [task description]"`
  - **Exit criteria**: 
    - ✅ All checks pass without errors or warnings (unless warnings are expected/acceptable)
    - ✅ All checkboxes in this step are marked as done `[x]`
    - ✅ All changes have been staged with `git add`
    - ✅ All changes have been committed with `git commit`
```

### Step 5: Special Task Types

**Database Migrations:**
- Include migration file naming convention (e.g., `[timestamp]_description.sql`)
- Include verification steps (run migrations, verify tables/columns exist)
- Reference specific table/column names from requirements

**Analytics/Event Tracking:**
- Include event type additions to enums/interfaces
- Include edge function updates
- Include helper function creation
- Include integration points in components

**Component Creation:**
- Include file path for new component
- Include props/interface definitions
- Include integration points (where component is used)
- Include accessibility requirements (ARIA labels, keyboard navigation)

**Styling/CSS Updates:**
- Include specific CSS variable names
- Include color values and design tokens
- Include class names and selectors
- Include transition/animation specifications

### Step 6: Property Test Identification

Identify requirements that need property tests:
- Complex logic with multiple conditions
- State management (preferences, defaults, fallbacks)
- Data transformations
- Integration points between systems
- Backward compatibility requirements

Also decide how tests should be laid out in the generated `tasks.md`. There are two main styles:

- **Option 1 (default)**: Tests alongside the step that introduced the behavior
  - Break down `design.md` into multiple implementation steps; for each step, if that step requires a test, add the relevant test task(s) immediately after that step.
  - When a step creates or changes behavior (component, service, transform, endpoint), add the relevant test task(s) immediately after that step.
  - This is especially recommended for **property tests**: keep them next to the risky logic they validate.
  - Use `--testLevel` to decide how many tests to add next to each step.

- **Option 2 (`--testAtEnd`)**: Tests grouped toward the end
  - Keep early steps focused on implementation, then add 1–N testing tasks near the end of the feature.
  - Tests should still be broken down (unit / e2e / property) as separate subtasks, and must reference the requirements they validate.

### Step 6.1: Testing Level Flags

Use `--testLevel` to control how much testing guidance is generated:

- **`minimal` (default)**:
  - Add tests only when risk is high: complex logic, state, transformations, integration boundaries, backward compatibility.
  - Prefer property tests for invariant-heavy logic; otherwise 1–2 focused unit tests.
- **`medium`**:
  - Expect unit tests for most non-trivial logic and key UI behavior.
  - Add at least one e2e test for critical user flows.
  - Add property tests for invariants (determinism, formatting, idempotency, schema shape, etc.).
- **`production`**:
  - Add unit + integration coverage for core modules and boundaries.
  - Add e2e coverage for all critical flows and regressions.
  - Add property tests for invariants and edge cases.
  - Add operational checks where relevant (logging/metrics, error contracts, performance smoke checks, accessibility checks).

Format property tests as:
```markdown
- [ ]* X.Y Write property test for [specific behavior]
  - **Property N: [Descriptive Name]**
  - **Validates: Requirements X.Y, X.Z**
```

### Step 7: Final Tasks

Include final verification/maintenance tasks:
- Backward compatibility verification
- Documentation tasks
- Manual testing checklists
- Performance verification
- Accessibility verification

## When to Stop and Ask Clarifying Questions (Mandatory)

If any of the following are true, **STOP and ask for clarification** before generating tasks:
- `design.md` cannot be found or you are not confident you’ve fully read it.
- `requirements.md` is unclear, incomplete, or missing acceptance criteria that you need to write actionable tasks.
- `design.md` and `requirements.md` conflict (scope, terminology, flows, constraints, acceptance criteria).
- A key implementation decision is underspecified (e.g., API shape, data model, error handling, auth, ownership boundaries) and making an assumption would materially change the tasks.

## Output Format

The generated file should:
1. Start with `# Implementation Plan` header
2. Use consistent checkbox formatting: `- [ ]` for unchecked, `- [x]` for checked
3. Use proper markdown indentation (2 spaces per level)
4. Include requirement references in italics: `_Requirements: X.Y, X.Z_`
5. Use bold for emphasis: `**Property N:**`, `**Validates:**`, `**Order matters:**`
6. Include clear exit criteria for each verification section

## Example Task Structure

**Default (Option 1, no legacy verification step):**
```markdown
# Implementation Plan

- [ ] 1. [Main Task Name]
  - [ ] 1.1 [Subtask description]
    - Specific implementation step 1
    - Specific implementation step 2
    - Update `path/to/file.ts`
    - _Requirements: 1.1, 1.2_
  - [ ]* 1.2 Write property test for [behavior]
    - **Property 1: [Test Name]**
    - **Validates: Requirements 1.1, 1.2**
```

**With `--includeLegacyTestStep` (legacy checklist embedded in tasks):**
```markdown
# Implementation Plan

- [ ] 1. [Main Task Name]
  - [ ] 1.1 [Subtask description]
    - Specific implementation step 1
    - Specific implementation step 2
    - Update `path/to/file.ts`
    - _Requirements: 1.1, 1.2_
  - [ ]* 1.2 Write property test for [behavior]
    - **Property 1: [Test Name]**
    - **Validates: Requirements 1.1, 1.2**
  - [ ] (Legacy) Run checks and tests (prefer `/implement-g`)
    - [Standard verification steps]
```

## Important Notes

- **Fully read BOTH `requirements.md` and `design.md`** before generating tasks
- **Stick closely to `requirements.md` and `design.md`**; they are the source of truth
- **If you are not sure, stop and ask for clarification** rather than guessing
- **Group related requirements** into logical implementation phases
- **Break down complex requirements** into multiple subtasks
- **Include all acceptance criteria** in the task breakdown
- **Reference requirements** in every subtask that addresses them
- **Consider dependencies** between tasks (order matters)
- **Include the legacy verification step ONLY if `--includeLegacyTestStep` flag is provided** - otherwise omit it (use `/implement-g` for checks/tests)
- **Make tasks actionable** - each subtask should be clear and specific
- **Adapt to project structure** - use actual file paths and conventions from the codebase
- **Include property tests** for complex logic and state management
- **Follow existing patterns** - look at example task files for formatting consistency
- **Default behavior**: Generate tasks without legacy verification sections, as `/implement-g` provides checks/tests during implementation

## Exit Criteria

- ✅ Task file generated at specified output path
- ✅ All requirements mapped to tasks
- ✅ All acceptance criteria addressed
- ✅ Tasks are logically grouped and ordered
- ✅ Each subtask has requirement references
- ✅ Legacy verification sections included **ONLY if `--includeLegacyTestStep` flag provided**, otherwise omitted
- ✅ Property tests identified and marked
- ✅ File follows standard markdown formatting

