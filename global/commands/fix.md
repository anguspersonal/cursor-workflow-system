# fix

Write your command content here.

This command will be available in chat with /fix

# Fix Tests - Run and Fix Stale Tests, TypeChecks, and Builds

Run and fix the most stale unit tests in the repository, prioritizing tests that haven't been run recently.

## Usage
`/fix [-<number>]`

Examples:
- `/fix` - Run and fix 1 test (default)
- `/fix -5` - Run and fix 5 tests
- `/fix -10` - Run and fix 10 tests

## Process

### Step 1: Review Testing Patterns
- Review the testing framework and patterns used in the repository
- Understand test file naming conventions (e.g., `*.test.ts`, `*.test.tsx`)
- Identify test execution commands and patterns
- Note any test utilities, helpers, or fixtures used

### Step 2: Audit Test Log
- Read `testlog.json` to see which tests have been tracked.
- The log should contain test file paths with either:
  - A timestamp (ISO 8601 format) indicating the last time the test was run
  - The string `"never"` indicating the test has never been run
- If `testlog.json` is empty or malformed, initialize it as an empty object `{}`

### Step 3: Discover All Tests
- Find all unit test files in the repository using glob patterns:
  - `**/*.test.{ts,tsx}` (co-located component/unit tests)
  - Include E2E tests (typically in `tests/` directory with `.spec.ts` extension)
  - Include test setup files and test utilities
- For each test file found:
  - If not in `testlog.json`, add it with `"never"` as the value
  - If already in `testlog.json`, keep the existing timestamp or `"never"` value
- General tests:
  - Ideally, regardless of project, all testlog.json files include these commands (not actual tests but quality checks):
    - "npm run lint": "[timestamp/never]",
    - "npm run typecheck": "[timestamp/never]",
    - "npm run test:unit": "[timestamp/never]", --IF APPLICABLE (NOT ALL REPOS HAVE OR NEED UNIT TESTS)
    - "npm run test:integration": "[timestamp/never]", --IF APPLICABLE (NOT ALL REPOS HAVE  OR NEED INTEGRATION TESTS)
    - "npm run test:e2e": "[timestamp/never]", --IF APPLICABLE (NOT ALL REPOS HAVE  OR NEED E2E TESTS)
    - "npm run build": "[timestamp/never]",
  - If these are not included, ADD THEM.

### Step 4: Select and Run Stale Test
- Sort all tests by staleness:
  - Tests with `"never"` are considered most stale (highest priority)
  - Tests with timestamps are sorted by date (oldest first)
- Select the most stale test (first in sorted list)
- Run the selected test with a timeout to prevent hanging:
  - Use `npx vitest run <test-file-path> --run --no-watch --testTimeout=<timeout-ms>`
  - Default timeout: 30000ms (30 seconds)
  - **Critical flags:** `--run --no-watch` ensure test runs once and exits (prevents hanging)
  - If test file path contains spaces or special characters, ensure proper quoting
  - Capture both stdout and stderr for analysis
  - If test hangs, check for:
    - Animation library timers (framer-motion, motion-dom)
    - Vitest worker pool IPC handles
    - Unclosed fetch/network connections
    - File handles in cleanup hooks

### Step 5: Fix Failing Tests
- If the test **fails**:
  - Analyze the test output to understand the failure
  - Determine if the issue is in:
    - The test code itself (incorrect expectations, outdated mocks, etc.)
    - The implementation code (bug in the code being tested)
  - Fix the issue iteratively:
    - Make code changes to fix the problem
    - Re-run the test to verify the fix
    - If still failing, analyze and fix again
    - Continue until the test passes
  - **Important**: After fixing code, ensure the fix doesn't break other tests or introduce new issues
- If the test **passes**:
  - Update `testlog.json` with today's date as timestamp (ISO 8601 format: `YYYY-MM-DDTHH:mm:ss.sssZ`)
  - Move to next iteration

### Step 6: Repeat
- If more tests need to be fixed (based on the `-<number>` parameter):
  - Go back to Step 4
  - Select the next most stale test
  - Continue until the specified number of tests have been processed

## Test Execution Details

### Running Individual Tests
- Use Vitest's file path filtering: `npx vitest run <relative-path-to-test-file>`
- Example: `npx vitest run app/chat/Bubble.test.tsx`
- Ensure the command runs in non-watch mode (`--run` flag is implicit with file path)

### Timeout Configuration
- Set test timeout to prevent hanging: `--testTimeout=30000` (30 seconds default)
- If a test legitimately needs more time, increase timeout appropriately
- If a test hangs, investigate and fix the root cause (infinite loops, unresolved promises, etc.)

### Test Output Analysis
- Parse test output to determine:
  - Test pass/fail status
  - Error messages and stack traces
  - Number of tests run vs passed/failed
- Use exit codes: 0 = success, non-zero = failure

## Test Log Format

The `testlog.json` file should follow this structure:

```json
{
  "app/chat/Bubble.test.tsx": "2025-01-15T10:30:00.000Z",
  "app/chat/Chat.test.tsx": "never",
  "lib/chat/moderation.test.ts": "2025-01-10T14:20:00.000Z"
}
```

- Keys are relative file paths from the repository root
- Values are either ISO 8601 timestamps or the string `"never"`

## Exit Criteria
- ✅ Specified number of tests have been processed
- ✅ All processed tests are now passing
- ✅ `testlog.json` has been updated with current timestamps for all processed tests
- ✅ No tests are hanging or timing out

## Important Notes
- **DO NOT skip tests** - fix all failures before marking as tested
- **DO NOT mark tests as tested if they fail** - only update timestamp when test passes
- **DO NOT run tests indefinitely** - always use timeouts and ensure tests complete
- **Prioritize stale tests** - always select the most stale test first
- **Update test log immediately** - mark tests as tested as soon as they pass
- If a test cannot be fixed after reasonable attempts, document the issue but still update the log with a note

