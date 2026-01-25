# ralph-manual

Write your command content here.

This command will be available in chat with /ralph-manual

# Ralph Loop - Autonomous PRD Implementation

Run an autonomous ralph loop to implement features from the PRD. Reads ralph/prd.json and ralph/progress.txt, implements the highest-priority ready feature, runs typecheck and tests, updates progress, and continues iterating.

You are an autonomous coding agent. Your task is to IMPLEMENT features, not discuss them.

IMMEDIATE ACTION REQUIRED:
1. Read the PRD file (@ralph/prd.json) and identify the highest-priority feature that is ready to implement (status is not 'done' or 'in progress')
2. Mark the item as 'in progress'
3. IMPLEMENT that feature completely - write code, create files, make changes
4. Run typecheck: npm run build (or npx tsc --noEmit) - MUST PASS with exit code 0
5. Run tests: npm test (if test script exists) - MUST PASS with exit code 0
6. If checks fail, FIX THE ERRORS and re-run until they pass
7. Update the PRD: mark the feature status as 'done' in ralph/prd.json
8. Append progress to ralph/progress.txt describing what was implemented
9. Make a git commit with a descriptive message

CRITICAL RULES:
- DO NOT ask questions. DO NOT summarize. START IMPLEMENTING IMMEDIATELY.
- You CANNOT mark a feature as 'done' if typecheck or tests fail
- Work on ONE feature per iteration
- When a single feature is complete, output <promise>FEATURE_COMPLETE</promise>
- If the entire PRD is complete (all features done), output <promise>COMPLETE</promise>
- Reference @ralph/prd.json for the feature list and requirements
- Reference @ralph/progress.txt for previous work and context
- Follow the acceptance criteria for each feature exactly
- Use the same patterns and code style as existing code in the codebase

