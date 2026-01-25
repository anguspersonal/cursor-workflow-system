# Project Learnings

Capture insights from active development here. Feed valuable patterns back into `global/` or `templates/`.

## Template for New Insights

### [Date] - [Project Name] - [Insight Title]

**Context:** What was the situation?

**Problem:** What issue did you encounter?

**Solution:** What worked?

**Pattern:** What reusable pattern emerged?

**Action:** Where should this go?
- [ ] Add to `global/` (applies everywhere)
- [ ] Add to `templates/` (reusable for some projects)
- [ ] Document in `examples/best-practices.md`
- [ ] Create new command/rule/skill/agent

---

## Example Entry

### 2026-01-25 - my-cursor - Command Workflow Discovery

**Context:** Setting up my-cursor repo and reviewing existing commands

**Problem:** Had 10 sophisticated commands but no documentation of how they work together

**Solution:** Mapped out the complete workflow from `/discuss` → `/implement-g`

**Pattern:** Human-in-the-loop development workflow:
1. Debate (discuss)
2. Requirements (mk-req)
3. Design (gen-design)
4. Tasks (gen-tasks)
5. Implementation (implement-g)
6. Review (code-review)
7. Fix (fix)

**Action:**
- [x] Documented in `examples/best-practices.md`
- [ ] Consider creating a `/workflow` command that explains the full flow

---

## Your Insights

### 2026-01-25 - Multiple Projects - Test Hanging & Database Workflow

**Context:** Experienced recurring issues with tests hanging indefinitely and database migration workflows across multiple projects using Vitest, React Testing Library, Framer Motion, and Supabase.

**Problem:** 
1. Tests would hang indefinitely instead of exiting cleanly
2. Animation libraries created timers that kept tests alive
3. Vitest worker pools created IPC handles that prevented process exit
4. Database migrations were being automatically run when they should be manual
5. Cleanup hooks with async operations caused hanging

**Solution:** 
1. Always use `--run --no-watch` flags for test commands
2. Add proper cleanup in `afterEach` and `afterAll` hooks
3. Clear timers explicitly when using animation libraries
4. Track active handles with `process._getActiveHandles()` for debugging
5. Use `globalThis` for state that must persist across test file re-imports
6. Avoid `fetch()` and file I/O in cleanup hooks
7. Provide manual database migration instructions instead of auto-running

**Pattern:** Test execution and cleanup best practices for Vitest + React + Animation libraries.

**Action:**
- [x] Added to `global/user-rules.md` (database workflow preference)
- [x] Added comprehensive testing section to `examples/best-practices.md`
- [x] Updated `/fix` command with proper test execution flags
- [x] Updated `/implement-g` command with test hanging prevention
- [x] Created `templates/rules/testing-guidelines.mdc` for project use

**Impact:** This prevents hours of debugging hanging tests and ensures consistent database workflow across all projects.

---

(Add new entries below this line)
