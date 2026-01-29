# fix-failing-test

## Purpose
Systematically debug and fix failing tests by analyzing failures, forming hypotheses, and guiding the user through manual test execution to avoid test hang issues.

## Usage
```
/fix-failing-test @[test-file] [console output with test failure]
```

**Examples:**
- `/fix-failing-test @PitchDeckViewer.test.tsx` - Fix tests in a specific file
- `/fix-failing-test` with pasted console output showing failures

## Workflow

### Phase 1: Identify Failing Tests

1. **Parse the failure information** from either:
   - Referenced test file name(s)
   - Pasted console output from test runner
   - User description of which tests are failing

2. **Extract key failure details**:
   - Test file path(s)
   - Specific test name(s)
   - Error messages
   - Stack traces
   - Expected vs actual behavior

3. **Summarize findings** clearly:
   ```
   Failing Test: [test name]
   File: [path]
   Error: [error message]
   ```

### Phase 2: Understand Context

4. **Read the failing test file** to understand:
   - What the test is trying to verify
   - Test setup and teardown
   - Assertions being made
   - Dependencies and mocks

5. **Search for related implementation code**:
   - Use semantic search to find components/functions being tested
   - Read relevant source files
   - Check for recent changes that might have caused the failure

6. **Identify related patterns**:
   - Search for similar tests that might have the same issue
   - Check for known patterns from test documentation (e.g., `@docs/ADR09_test_suite_improvements_and_fixes.md`, `@docs/ADR10_test_hang_troubleshooting_playbook.md`)

### Phase 3: Form Hypothesis

7. **Analyze the failure** and create a specific hypothesis:
   - What is the most likely cause?
   - What assumptions might be wrong?
   - Are there timing issues, state issues, or logic errors?

8. **Explain the hypothesis** to the user:
   ```
   Hypothesis: [clear statement of what you think is wrong]
   
   Evidence:
   - [supporting evidence from code/error]
   - [supporting evidence from code/error]
   
   Expected fix:
   - [what needs to change]
   ```

### Phase 4: Implement Fix

9. **Make the necessary code changes**:
   - Fix the implementation code, OR
   - Fix the test itself (if the test is incorrect), OR
   - Both

10. **Explain what changed**:
    - Show before/after code snippets
    - Explain why this should fix the issue

### Phase 5: User Testing (CRITICAL)

11. **DO NOT run tests directly** - Instead, ask the user to run them:
    ```
    Please run the following command to verify the fix:
    
    npm test -- [specific-test-file]
    
    Or for a specific test:
    
    npm test -- [test-file] -t "[test-name-pattern]"
    
    Then paste the output here.
    ```

12. **Wait for user feedback** - Do not proceed until the user provides test results

### Phase 6: Iterate

13. **If tests still fail**:
    - Analyze the new error output
    - Revise hypothesis based on new information
    - Return to Phase 4 with updated understanding

14. **If tests pass**:
    - Confirm the fix is complete
    - Check for any related tests that might need similar fixes
    - Suggest running the full test suite if appropriate

15. **If tests hang or timeout**:
    - Review test cleanup (afterEach/afterAll)
    - Check for uncleared timers or event listeners
    - Refer to `@docs/ADR10_test_hang_troubleshooting_playbook.md`

## Important Constraints

### Never Run Tests Directly
This project has known test hang issues. **You must never execute test commands yourself.** Always ask the user to run tests and paste results.

### Focus on One Test at a Time
If multiple tests are failing, prioritize:
1. The first failing test
2. Tests that are blocking others
3. Tests with the clearest error messages

Once one test is fixed, move to the next.

### Keep Hypotheses Specific
Avoid vague statements like "something is wrong with the component." Instead:
- "The test expects `isActive` to be true, but the component initializes it as false"
- "The cleanup function isn't being called, leaving event listeners attached"

## Example Session

**User:** `/fix-failing-test` [pastes console showing "PitchDeckViewer should render correctly" failing]

**AI Response:**
```
Failing Test: "PitchDeckViewer should render correctly"
File: src/components/__tests__/PitchDeckViewer.test.tsx
Error: Expected element to have class "pitch-deck-viewer" but it was not found

Let me read the test and component to understand the issue...

[reads files]

Hypothesis: The component's root class name was recently changed from "pitch-deck-viewer" to "deck-viewer", but the test wasn't updated.

Evidence:
- Test expects class "pitch-deck-viewer" (line 42)
- Component now uses class "deck-viewer" (line 15 in PitchDeckViewer.tsx)

Expected fix: Update the test to expect the new class name.

[makes fix]

Please run this command to verify:

npm test -- PitchDeckViewer.test.tsx

Then paste the output here.
```

## Project-Specific Notes

This command is designed for this project's testing environment:
- Uses Vitest as test runner
- Test files are in `__tests__` directories or `.test.tsx` files
- Known test hang issues require manual test execution
- Relevant documentation: `@docs/ADR09_test_suite_improvements_and_fixes.md`, `@docs/ADR10_test_hang_troubleshooting_playbook.md`

## Success Criteria

A test fix is complete when:
1. The user confirms tests pass
2. The fix addresses the root cause (not just symptoms)
3. No new test failures are introduced
4. The solution is maintainable and clear
