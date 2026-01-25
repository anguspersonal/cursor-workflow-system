# Best Practices

Patterns and insights that have proven valuable across projects.

## Command Workflows

### Feature Development Workflow

The complete workflow from idea to implementation:

```mermaid
graph LR
    A[/discuss] --> B[/mk-req]
    B --> C[/gen-design]
    C --> D[/gen-tasks]
    D --> E[/implement-g]
    E --> F[/code-review]
    F --> G[/fix]
```

1. **`/discuss`** - Debate feature desirability and feasibility
   - Use when: You have a feature idea that needs validation
   - Output: Decision (proceed/defer/reject) and scope statement

2. **`/mk-req`** - Create requirements document
   - Use when: Feature is approved from `/discuss`
   - Output: `requirements.md` with acceptance criteria

3. **`/gen-design`** - Generate design document
   - Use when: Requirements are finalized
   - Output: `design.md` with architecture and technical design

4. **`/gen-tasks`** - Generate implementation task file
   - Use when: Design is complete
   - Output: `tasks.md` with structured checklist

5. **`/implement-g`** - Implement tasks with quality checks
   - Use when: Tasks are defined
   - Flags: `--require-previous-success` to chain implementations
   - Output: Working code + passing tests + git commit

6. **`/code-review`** - Review code quality
   - Use when: Implementation is complete
   - Flags: `--suggest-fixes`, `--check-tests`, `--check-requirements`
   - Output: Review report with prioritized issues

7. **`/fix`** - Fix stale tests and quality checks
   - Use when: Tests haven't been run recently
   - Flags: `-<number>` to specify how many tests to fix
   - Output: Updated `testlog.json` and passing tests

### Quick Iterations

For quick changes without full workflow:

- **`/implement-g`** - Direct implementation with built-in checks
- **`/code-review --suggest-fixes`** - Quick review with fixes
- **`/fix -5`** - Fix 5 stale tests

---

## When to Use What

### `/discuss` vs Direct Implementation

Use `/discuss` when:
- Feature scope is unclear
- Multiple approaches exist
- Need to validate desirability/feasibility
- Opportunity cost matters

Skip `/discuss` when:
- Bug fix with clear solution
- Minor refactor
- Documentation update
- Obvious improvement

### Task Generation Options

**`/gen-tasks` flags:**
- Default (no flags): Minimal test coverage, tests alongside implementation
- `--testAtEnd`: Tests grouped at end of task list
- `--testLevel minimal`: Only essential tests (default)
- `--testLevel medium`: Unit + E2E for user-visible behavior
- `--testLevel production`: Full coverage (unit + integration + E2E + property + ops)
- `--includeLegacyTestStep`: Include old-style verification checklist (prefer `/implement-g` instead)

### `/implement-g` Chaining

Use `--require-previous-success` (or `-rps`) to chain implementations:

```bash
/implement-g task 1.1
/implement-g -rps task 1.2
/implement-g -rps task 1.3
```

If any task fails, the chain stops. This prevents building on broken foundations.

---

## Code Review Priority Classification

From `/code-review` command:

**Critical** - Prevents compilation, causes crashes, security breaches, data loss
**High** - Likely causes bugs, failures, or significant UX degradation
**Medium** - Affects code quality, maintainability, or causes minor performance issues
**Low** - Minor improvements with no measurable impact

**Decision Rule:** When uncertain between two priority levels, always classify lower.

---

## Test Maintenance Strategy

From `/fix` command:

**Test Staleness Tracking:**
- Maintains `testlog.json` with timestamps for each test file
- Tests marked as `"never"` have highest priority
- Tests sorted by age (oldest first)

**Usage:**
- `/fix` - Fix 1 stale test
- `/fix -5` - Fix 5 stale tests
- Run regularly to prevent test decay

---

## Testing Best Practices

### Test Execution

**Always use proper flags to prevent hanging:**
```bash
npm test -- --run --no-watch
vitest run --no-watch
```

**Why:** Test runners in watch mode keep the process alive indefinitely. Always use flags that ensure tests run once and exit.

### Test Cleanup

**Critical:** Add cleanup between test iterations to prevent resource leaks:

```typescript
afterEach(() => {
  cleanup(); // React Testing Library cleanup
  vi.clearAllTimers(); // Clear any pending timers
});

afterAll(() => {
  // Clear all intervals and timeouts
  vi.clearAllTimers();
  
  // If using animation libraries (framer-motion, motion-dom):
  // They create timers via requestAnimationFrame that can hang tests
  // Track and clear all timers explicitly
});
```

### Common Test Hanging Issues

#### 1. Animation Libraries
**Problem:** `framer-motion` and `motion-dom` create timers via `requestAnimationFrame` that keep tests alive.

**Solution:** Track and clear `setTimeout`/`setInterval` in `afterAll`:
```typescript
afterAll(() => {
  vi.clearAllTimers();
  vi.useRealTimers(); // Reset to real timers after mocking
});
```

#### 2. Vitest Worker Pools
**Problem:** Vitest worker pools (threads/forks) create IPC handles (MessagePort/Pipe) that keep the process alive.

**Solution:** May need to `unref()` these handles after ALL test files complete. This is usually handled by Vitest, but if tests still hang, check Vitest config.

#### 3. State Persistence Across Test Files
**Problem:** Module-level variables reset per file in Vitest.

**Solution:** If state must persist across test file re-imports, store it on `globalThis`:
```typescript
// Instead of:
let sharedState = {};

// Use:
globalThis.sharedState = globalThis.sharedState || {};
```

#### 4. Fetch and File I/O in Cleanup
**Problem:** `fetch()` or file I/O in test cleanup hooks create handles that prevent exit.

**Solution:** Avoid async operations in cleanup hooks. If necessary, ensure promises are properly resolved/rejected:
```typescript
// BAD - can hang
afterAll(async () => {
  await fetch('/cleanup'); // Might not complete
});

// GOOD - synchronous cleanup
afterAll(() => {
  mockServer.close(); // Synchronous close
});
```

### Debugging Hanging Tests

If tests hang, identify what's keeping the event loop alive:

**Node.js:**
```javascript
console.log(process._getActiveHandles());
console.log(process._getActiveRequests());
```

**Look for:**
- Timers (setTimeout/setInterval)
- Network connections (fetch, WebSocket)
- File handles (fs operations)
- IPC handles (worker threads, MessagePort)

### Test Configuration

**Include explicit timeouts in test commands:**
```bash
vitest run --testTimeout=30000  # 30 second timeout per test
```

**In vitest.config.ts:**
```typescript
export default defineConfig({
  test: {
    testTimeout: 30000,
    hookTimeout: 10000,
    teardownTimeout: 5000,
  },
});
```

---

## Notes

- These patterns emerge from real project experience
- Update this file when you discover new insights
- Command details may evolve - check actual command files for latest
- Testing best practices discovered through debugging Vitest + React Testing Library + Framer Motion hanging issues
