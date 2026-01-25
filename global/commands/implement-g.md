# implement-g

Complete implementation of specified tasks with quality checks before committing.

**Global command** - Works across different project types (monorepos, single packages, etc.). Adapts to project structure automatically.

## Usage
`/implement-g [--require-previous-success | -rps] <task description or task IDs>`

**Flags:**
- `--require-previous-success` or `-rps` - Only execute if the previous `/implement-g` command in the conversation succeeded. If previous command failed or didn't complete, exit immediately without implementing.

**Examples:**
- `/implement-g task 4.1, 4.2, 4.3` - Implement specific task IDs from a task file
- `/implement-g add user authentication` - Implement a feature description
- `/implement-g docs/create-derived-artifact/tasks.md` - Implement all tasks from a task file
- `/implement-g -rps task 4.4, 4.5` - Implement tasks only if previous command succeeded
- `/implement-g --require-previous-success task 4.6, 4.7` - Same as above, using long form

## Task Sources

Tasks may come from:
- Task markdown files (e.g., `docs/*/tasks.md`, `tasks.md`) with checkbox lists
- Backlog items (e.g., `.cursor/Backlog.md`, project-specific backlog systems)
- Feature documentation (e.g., `docs/feat_*_IMPL.md`, `FEATURES.md`)
- Direct task descriptions from the user

## Process

### Step 0: Check Previous Command Success (if flag provided)

**If `--require-previous-success` or `-rps` flag is present:**

1. **Check conversation history:**
   - Look for the most recent `/implement-g` command before this one
   - If no previous `/implement-g` command exists, proceed normally (first command in chain)

2. **Verify previous command succeeded:**
   - Check git log for the most recent commit with message pattern `"Implement: ..."`
   - Verify the commit exists and was created after the previous `/implement-g` command
   - Alternative: Check if previous command's exit criteria were met (all checks passed, commit was made)

3. **If previous command failed or didn't complete:**
   - Exit immediately with message: "Previous /implement-g command did not succeed. Skipping execution."
   - **DO NOT** proceed with implementation, quality checks, or any other steps
   - **DO NOT** make any changes to code or files

4. **If previous command succeeded (or no previous command found):**
   - Continue with normal execution (proceed to Step 1)

### Step 1: Understand and Implement Tasks

1. **Locate task requirements:**
   - If task IDs provided, find the corresponding task file
   - If task description provided, clarify scope with user if needed
   - Review existing code patterns in the relevant directory/workspace

2. **Implement all specified tasks:**
   - Follow existing code patterns and conventions in the project
   - For monorepos, maintain consistency with workspace structure
   - Ensure all code changes are complete and functional
   - If tasks include manual steps or external setup (e.g., accounts, credentials, system settings, third-party dashboards):
     - **Leave those steps unchecked**
     - **Flag the manual step(s) to the user** and explain what needs human input

3. **Adapt to project structure:**
   - Check for monorepo indicators (e.g., `turbo.json`, `pnpm-workspace.yaml`, `lerna.json`)
   - Review project documentation for architecture patterns
   - Follow existing file organization and naming conventions

### Step 2: Run Quality Checks (Order Matters)

Run checks from fastest to slowest for quick feedback. **ENSURE TESTS DO NOT RUN FOREVER OR TIMEOUT:**

**Detect project type first:**
- Check for `turbo.json` → Use turbo commands (e.g., `turbo run lint`)
- Check for `package.json` scripts → Use npm scripts (e.g., `npm run lint`)
- Check for other build tools (pnpm, yarn, etc.) → Use appropriate commands

1. **Type Checking**:
   - If `npm run check:types` exists → Use it
   - Otherwise → Run `npx tsc --noEmit` (if TypeScript project)
   - If failures: Fix type errors in code. Iterate until pass.

2. **Linting**:
   - **Monorepo (turbo)**: Run `npm run lint` (which may use `turbo run lint`)
   - **Single package**: Run `npm run lint`
   - If failures: Fix linting errors in code. Iterate until pass.
   - If auto-fixable: Consider running with `--fix` flag

3. **Tests**:
   - **Monorepo (turbo)**: Run `npm test` (which may use `turbo run test`)
   - **Single package**: Run `npm test`
   - **CRITICAL: ENSURE TESTS DO NOT RUN FOREVER OR TIMEOUT:**
     - Always use `--run --no-watch` flags: `npm test -- --run --no-watch`
     - Include explicit timeouts: `--testTimeout=30000` (30 seconds default)
     - Verify test cleanup hooks (afterEach/afterAll with cleanup())
     - Watch for common hanging issues:
       - Animation libraries (framer-motion, motion-dom) create timers
       - Vitest worker pools create IPC handles
       - Unclosed network connections or file handles
       - State persisting across test files (use globalThis if needed)
   - If failures: Analyze test output to determine if issue is in code or test
   - Fix code if test expectations are correct, or fix test if expectations are wrong
   - **If code was fixed**: Re-run Type Check and Lint to ensure fixes are valid, then re-run Tests
   - **If tests hang**: Check `process._getActiveHandles()` to identify what's keeping event loop alive
   - Iterate until all tests pass

4. **Build**:
   - **Monorepo (turbo)**: Run `npm run build` (which may use `turbo run build`)
   - **Single package**: Run `npm run build`
   - If failures: Fix build errors (usually TypeScript or import issues)
   - **If code was fixed**: Re-run Type Check and Lint to ensure fixes are valid, then re-run Tests, before running Build again
   - Iterate until build succeeds

### Step 3: Finalize

Once all checks pass, you MUST:

1. **Stage all changes**: Run `git add .` (or `git add -A`)
2. **Commit all changes**: Run `git commit -m "Implement: <task description>"`

Use descriptive commit messages that summarize what was implemented. Follow project commit conventions if they exist.

## Exit Criteria

- ✅ All checks pass without errors or warnings (unless warnings are expected/acceptable)
- ✅ All changes have been staged with `git add`
- ✅ All changes have been committed with `git commit`

## Important Notes

- **DO NOT skip any check steps** - all must pass before committing
- **DO NOT commit if any check fails** - fix errors first
- **Mark md file tasks as done when complete.** - `[ ]` to `[x]`
- **Do not check off manual/external steps.** Leave them unchecked and call them out to the user.
- If you fix code after a check fails, re-run all previous checks to ensure nothing broke
- **Adapt to project structure**: Detect monorepo vs single package and use appropriate commands
- **Turbo specification**: If `turbo.json` exists, commands typically run via turbo across workspaces
- For workspace-specific commands in monorepos, use `npm run <command> --workspace=<package-name>`
- Check project documentation (e.g., `README.md`, `docs/`) for project-specific patterns or requirements
