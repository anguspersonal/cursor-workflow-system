# code-review

Review code files for quality, correctness, best practices, and alignment with requirements/design documents. This command analyzes code for bugs, performance issues, type safety, test coverage, and adherence to project conventions, then either provides feedback (default) or suggests improvements (with `--suggest-fixes` flag).

## Usage

`/code-review <path(s)> [--suggest-fixes] [--check-tests] [--check-requirements]`

**Examples:**
- `/code-review src/pages/SendInvites.tsx` - Review a specific file
- `/code-review src/services/` - Review all files in a directory
- `/code-review src/pages/SendInvites.tsx src/components/PersonalizedGreeting.tsx` - Review multiple files
- `/code-review src/ --suggest-fixes` - Review entire src directory and suggest code improvements
- `/code-review src/services/guestData.ts --check-requirements docs/personal-invites/requirements.md` - Review code against requirements
- `/code-review src/pages/ --check-tests` - Review code and verify test coverage

**Flags:**
- `--suggest-fixes`: Provide specific code suggestions and improvements. When this flag is set, the command will suggest concrete code changes, refactorings, and optimizations.
- `--check-tests`: Verify that reviewed code has corresponding test files and adequate test coverage. Checks for unit tests, property tests, and integration tests as appropriate.
- `--check-requirements`: Review code alignment with requirements and design documents. Requires path to requirements.md or design.md file(s) to compare against.

## Process

### Step 1: Identify Files to Review

1. **If path is a file**:
   - Review the specified file
   - Validate file exists and is readable
   - Determine file type (TypeScript, TSX, etc.)

2. **If path is a directory**:
   - Recursively find all code files (`.ts`, `.tsx`, `.js`, `.jsx`)
   - Exclude test files unless explicitly included
   - Exclude `node_modules`, `dist`, build directories
   - Review all found files

3. **If multiple paths provided**:
   - Review each specified file/directory
   - Maintain context across related files

### Step 2: Analyze Code Structure

For each file, analyze:
- **File organization**: Imports, exports, structure
- **Type definitions**: Interfaces, types, type safety
- **Component/function structure**: Organization, separation of concerns
- **Dependencies**: External imports, internal dependencies

### Step 3: Review Code Quality

Focus on project-specific patterns and high-impact issues. Reference project conventions from `AGENTS.md`, `.cursorrules`, and testing patterns from `packages/worker/__tests__/`.

#### 3.1 TypeScript and Type Safety

1. **Type Coverage**:
   - All function parameters typed (no implicit `any`)
   - Explicit return types on exported functions
   - Use `unknown` instead of `any` for type-safe handling
   - Safe type assertions with validation
   - Generic type constraints where needed

2. **Type Errors**:
   - Check `tsc --noEmit` output
   - Identify compilation-blocking errors (Critical priority)
   - Flag unsafe `any` usage in critical paths (High priority)

#### 3.2 React Patterns and Best Practices

1. **Hooks Compliance**:
   - No conditional hook calls (Rules of Hooks violations = High priority)
   - Missing dependencies in `useEffect`, `useMemo`, `useCallback` arrays
   - Cleanup functions in `useEffect` for timers, subscriptions, listeners
   - Custom hooks follow `use*` naming convention

2. **Performance Issues**:
   - Unnecessary re-renders (missing `React.memo`, `useMemo`, `useCallback`)
   - Missing key props in lists
   - Expensive computations in render (should be memoized)
   - Memory leaks from uncleaned subscriptions

3. **State Management**:
   - State updater functions for state-dependent updates
   - Avoid storing derived state
   - Proper async state handling (loading/error states)

#### 3.3 Code Correctness

1. **Error Handling**:
   - Try-catch blocks for async operations
   - Error logging with context
   - Error boundaries for component trees
   - No silent failures in user-facing code (High priority)

2. **Async/Await**:
   - All promises have rejection handlers
   - Race conditions in concurrent operations
   - Cleanup of pending async operations on unmount

3. **Null/Undefined Safety**:
   - Optional chaining (`?.`) and nullish coalescing (`??`) used correctly
   - Validated assumptions about data shape
   - Edge cases handled (empty arrays, null responses, etc.)

#### 3.4 Code Style and Conventions

Reference project-specific config:
- ESLint: `.eslintrc.js` or `eslint.config.js`
- TypeScript: `tsconfig.json`
- Style guides: `AGENTS.md`, `.cursorrules`

**Check:**
- Naming conventions (camelCase for functions/variables, PascalCase for components/types)
- Import organization (external → internal → relative)
- File naming matches conventions
- ESLint compliance (`npm run lint` or `eslint <files>`)

#### 3.5 Security and Best Practices

1. **Security** (Critical/High priority):
   - XSS prevention: No `dangerouslySetInnerHTML` with user input
   - Input validation on all user data
   - No exposed secrets (API keys, tokens) in code
   - Proper URL encoding for user-generated URLs
   - No `eval()` or unsafe innerHTML

2. **Accessibility** (High priority if blocking users):
   - Keyboard navigation functional
   - ARIA labels on interactive elements without visible text
   - Semantic HTML (`<button>` not `<div onClick>`)
   - Focus management in modals/dialogs

3. **Performance** (High if >2s, Medium if 100-500ms):
   - Unnecessary API calls or polling
   - Missing caching where appropriate
   - Lazy loading for large components/routes

### Step 4: Review Test Coverage (if `--check-tests` flag is set)

1. **Test File Existence**:
   - Corresponding test files in `__tests__` directories
   - Unit tests (`.test.ts`/`.test.tsx`) for business logic
   - Property tests (`.property.ts`/`.property.tsx`) for complex functions
   - Integration tests for workflows

2. **Test Coverage Analysis**:
   - Critical user paths have tests (High priority if missing)
   - Error handling tested (High priority for failure-prone operations)
   - Edge cases covered (Medium priority)
   - Refer to `packages/worker/__tests__/` for project test patterns

3. **Test Quality**:
   - Tests verify behavior, not implementation details
   - Proper setup/teardown (cleanup between tests)
   - Meaningful assertions, not just "does not throw"

### Step 5: Review Requirements Alignment (if `--check-requirements` flag is set)

1. **Requirements Mapping**:
   - Read specified requirements document(s)
   - Map code to acceptance criteria
   - Identify unimplemented requirements
   - Flag implementation beyond scope

2. **Design Alignment**:
   - Verify component structure matches design
   - Check data models match specifications
   - Identify deviations from design docs

3. **System Name Consistency**:
   - Code uses consistent naming with requirements
   - Terminology matches project glossary

### Step 6: Generate Review Report

**Default Mode (Feedback Only)**:
Create a comprehensive review report with:
- Summary of findings
- Issues organized by category (Type Safety, React Patterns, Correctness, Style, Security, Performance)
- Specific code examples with line numbers
- Recommendations for improvement
- Priority levels (Critical, High, Medium, Low)

**Suggest Fixes Mode** (`--suggest-fixes` flag):
- All of the above, plus:
- Specific code suggestions with before/after examples
- Refactoring recommendations
- Concrete improvements to implement

## Review Output Format

### Default Feedback Mode:

```markdown
# Code Review: [File/Directory Path]

## Summary
[Overall assessment, file count, issue count by severity]

## Files Reviewed
- `path/to/file1.tsx` - [Brief assessment]
- `path/to/file2.ts` - [Brief assessment]

## Issues by Category

### 🔴 Critical Issues
- **[File:Line] Issue Title**
  - Description of issue
  - Impact: [What could go wrong]
  - Recommendation: [How to fix]

### 🟠 High Priority Issues
- **[File:Line] Issue Title**
  - Description
  - Recommendation

### 🟡 Medium Priority Issues
- **[File:Line] Issue Title**
  - Description
  - Recommendation

### 🟢 Low Priority / Suggestions
- **[File:Line] Issue Title**
  - Description
  - Recommendation

## Type Safety Review
- [Type issues found]
- [Missing type annotations]
- [Unsafe type usage]

## React Patterns Review
- [Hook usage issues]
- [Component structure issues]
- [Performance concerns]

## Code Quality
- [Logic errors]
- [Error handling issues]
- [Code style issues]

## Test Coverage (if --check-tests)
- [Missing tests]
- [Test coverage gaps]
- [Test quality issues]

## Requirements Alignment (if --check-requirements)
- [Implemented requirements]
- [Missing requirements]
- [Deviations from design]
```

### Suggest Fixes Mode:

```markdown
# Code Review with Suggested Fixes: [File/Directory Path]

[All sections from feedback mode, plus:]

## Suggested Code Improvements

### [File:Line] Issue Title

**Current Code:**
```typescript
// Current implementation with issue
```

**Suggested Fix:**
```typescript
// Improved implementation
```

**Rationale:**
[Explanation of why this change improves the code]

## Refactoring Recommendations

### [Component/Function Name]

**Current Structure:**
[Description of current structure]

**Recommended Refactoring:**
[Description of improved structure]

**Benefits:**
- [Benefit 1]
- [Benefit 2]
```

## Priority Classification Guidelines

**Critical** - Prevents compilation, causes immediate crashes, security breaches, or data loss
- TypeScript compilation errors
- Runtime crashes in normal usage
- SQL injection, XSS vulnerabilities, exposed secrets
- Authentication bypass
- Data corruption in critical paths

**High** - Likely causes bugs, failures, or significant UX degradation in production
- Missing null checks causing runtime errors
- Unhandled promise rejections in user features
- Rules of Hooks violations
- Missing error boundaries
- User operations >2 seconds
- Keyboard navigation completely broken
- Missing tests for critical user paths

**Medium** - Affects code quality, maintainability, or causes minor performance issues
- Missing explicit return types
- Using `any` for non-critical functions
- Code duplication (>3 instances)
- Functions >50 lines
- Missing memoization causing 100-500ms delay
- Missing tests for edge cases

**Low** - Minor improvements with no measurable impact
- Code style improvements
- Micro-optimizations (<50ms)
- Optional better variable names
- Documentation for well-named code

**Decision Rule**: When uncertain between two priority levels, always classify lower.

**Quantifiable Thresholds**:
- Performance: >2s = High, 100-500ms = Medium, <50ms = Low
- Test coverage: Critical paths missing = High, edge cases missing = Medium
- Type safety: Prevents compilation = Critical, runtime risk = High, quality improvement = Medium

## Important Notes

- **Priority Classification**: Follow the guidelines above. When in doubt, classify lower. Don't inflate priority to justify findings.

- **Type Safety**: Distinguish between compilation-blocking errors (Critical), runtime risks from missing checks or `any` types (High), and quality improvements (Medium/Low).

- **Error Handling**: Crashes = Critical, silent failures in user-facing code = High, missing observability = Medium.

- **React Hooks**: Rules of Hooks violations are always High priority. Missing optimizations are Medium unless they cause >500ms lag (High).

- **Performance**: Use quantifiable thresholds: >2s = High, 100-500ms = Medium, <50ms = Low. Only flag as High if users experience noticeable delays.

- **Test Coverage**: When `--check-tests` is used:
  - Missing tests for critical user paths = High
  - Missing error case tests for failure-prone operations = High  
  - Missing tests for edge cases or non-critical code = Medium
  - Never classify missing tests as Critical

- **Security**: Direct vulnerabilities (SQL injection, XSS with user input, exposed secrets, auth bypass) = Critical. Security weaknesses (missing CSRF, weak passwords) = High.

- **Accessibility**: Issues that completely block users (broken keyboard navigation, missing critical alt text) = High. Minor improvements (ARIA labels on non-critical elements) = Medium.

- **Requirements Alignment**: When `--check-requirements` is used, missing required features can be Critical/High depending on whether they block core functionality.

- **Project Conventions**: Respect existing patterns. Reference project-specific config files:
  - ESLint config: `.eslintrc.js` or `eslint.config.js`
  - TypeScript config: `tsconfig.json`
  - Testing patterns: `packages/worker/__tests__/` for examples
  - Style guides: `AGENTS.md`, `.cursorrules`

## Integration with Other Commands

This command works well with:
- `/review` - Review documentation (requirements, design, tasks)
- `/implement` - Implement code changes based on review feedback
- Test commands - Verify fixes don't break tests

## Exit Criteria

- ✅ All specified files reviewed
- ✅ Issues identified and categorized by severity
- ✅ Feedback provided (default) or fixes suggested (`--suggest-fixes`)
- ✅ Test coverage verified (if `--check-tests` flag set)
- ✅ Requirements alignment checked (if `--check-requirements` flag set)
- ✅ Review report generated
