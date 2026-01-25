# discuss

Write your command content here.

This command will be available in chat with /discuss

# discuss
#
# This command will be available in chat with /discuss
#

## Discuss (Debate) a Feature Before Building It

Use this command to run a **conversational, multi-turn debate** about a proposed feature/change focused on:
- **Desirability** (should we do it? for whom? why now?)
- **Feasibility** (is it realistically doable within current constraints?)

**Non-goal:** This is *not* an implementation-planning session. Avoid code-level design, file-by-file changes, or detailed technical architecture unless needed only to judge feasibility at a high level.

**Problem solved:** Avoid over-engineering and undesirable features by stress-testing intent and constraints early.

**Typical handoff:** If the idea is worth doing, this discussion usually hands over to `/mk-req` to formalize a requirements document. Otherwise, the outcome is typically **defer** or **reject**.

---

## Usage

- `/discuss <topic / brief idea>` (defaults to chat mode)
- `/discuss --chat <topic / brief idea>`
- `/discuss --doc <topic / brief idea>`

Examples:
- `/discuss smarter capture validation`
- `/discuss --chat "new onboarding wizard"`
- `/discuss --doc @docs/upload-flow-refactor "refactor upload flow to reduce errors"`
- `/discuss --doc @docs/upload-flow-refactor`
- `/discuss --doc @docs/upload-flow-refactor/discussion.md`

---

## Modes

### Chat mode (default)
- Conduct the debate entirely in chat.
- Keep the conversation **multi-turn**: ask questions when intent/constraints are unclear, then iterate.

### Doc mode (`--doc`)
- Run the same debate, **but also capture it in a `discussion.md`** so it’s durable and reviewable.
- Treat the doc as a living discussion log with updates per turn (short, structured entries).

---

## Doc mode: file selection rules

When `--doc` is set, determine the target `discussion.md` like this:

1. **If the user references a `discussion.md` file** (e.g. `@docs/foo/discussion.md`):
   - Use that file.
2. **Else if the user references a folder** (e.g. `@docs/upload-flow-refactor`):
   - Treat that folder as the working directory.
   - Use `@<folder>/discussion.md`.
3. **Else (no folder or file referenced)**:
   - If the feature/topic name is clear, create:
     - `docs/<kebab-case-topic>/discussion.md`
   - If the topic is unclear, ask 2–4 short questions first, then create the folder+file once a reasonable name emerges.

**Creation behavior:**
- If the referenced folder does not exist, create it.
- If `discussion.md` does not exist, create it.
- If `discussion.md` exists but is empty, initialize it with the template below before appending entries.

---

## Debate process (both modes)

### Step 1: Establish context (ask questions if needed)

If user intent is missing/ambiguous, ask a small set of high-signal questions (2–6), for example:
- Who is the user and what pain does this solve?
- What does success look like (measurable outcome)?
- What is the current workaround?
- What constraints matter (time, complexity, privacy, cost, reliability)?
- What’s explicitly out of scope?
- What would make this a “no”?

### Step 2: Summarize the proposal

Restate the proposal in 3–6 bullet points:
- Goals
- Non-goals
- Assumptions
- Open questions

### Step 3: Debate desirability

Cover:
- Primary user value and frequency of use
- Opportunity cost (what won’t be built)
- Potential negative incentives / UX harm
- “Simpler alternative” options

### Step 4: Debate feasibility (high-level only)

Cover:
- Complexity drivers (dependencies, data flows, operational risk)
- Risk areas (security, privacy, reliability, performance)
- Compatibility with current architecture constraints (at a conceptual level)
- Rough sizing (S/M/L) and “unknowns”

### Step 5: Recommendation + decision options

Provide a clear recommendation with 2–4 options, for example:
- **Do now (MVP)**: narrow scope to reduce risk
- **Do later**: prerequisites needed first
- **Do never**: not worth the complexity
- **Alternative**: different approach that solves the core problem

Always include:
- A concise rationale
- The top 3 risks
- The smallest next step to validate the idea (e.g., UX spike, user interview, quick prototype) — still not implementation detail

### Step 6: Close with a clear outcome

End the discussion with exactly one of:
- **Proceed to requirements**: hand off to `/mk-req` (or `/makeReqs`) with a crisp scope statement and any key constraints/decisions.
- **Defer**: capture what would need to change to revisit (signals, prerequisites, timing).
- **Reject**: capture the primary reason(s) and any better alternative.

---

## `discussion.md` template (doc mode initialization)

```markdown
# Discussion: <Topic>

**Status:** Open
**Created:** <ISO timestamp>
**Last Updated:** <ISO timestamp>

## Context
- <why this is being considered>

## Goals
- <goal 1>

## Non-Goals
- <non-goal 1>

## Assumptions
- <assumption 1>

## Open Questions
1. <question>

## Options Considered
### Option A: <name>
- **Pros:** ...
- **Cons:** ...

### Option B: <name>
- **Pros:** ...
- **Cons:** ...

## Desirability Notes
- <user value, who benefits, how often>

## Feasibility Notes (High-level)
- <constraints, risks, unknowns>

## Recommendation
- <recommended option + why>

## Handoff
- **Next command (if proceeding):** `/mk-req <feature/module name> [brief description]`
- **Scope statement:** <what will be in / out>
- **Key constraints:** <time, privacy, cost, reliability, etc.>

## Decision Log
### <ISO timestamp>
- **Decision:** <open / proceed / defer / reject>
- **Reasoning:** <short>
- **Next step:** <smallest validation step OR run /mk-req>
```

---

## Guardrails

- Keep the debate about **what to build and whether to build it**, not detailed implementation.
- Prefer the **simplest** solution that achieves the goal; call out “nice-to-haves” explicitly.
- If the feature risks scope creep, propose an **MVP boundary** and defer the rest.
- If feasibility is unclear, focus on identifying unknowns and the smallest validation step.

