# User Rules

These are my personal User Rules that apply across all projects in Cursor.

**To apply these:** Copy the rules below and paste them into **Cursor Settings → Rules**

---

## General Development Preferences

### Database & Migrations
- I work with remote databases accessed via Supabase (`supabase db push`), not local databases
- Never automatically run database migrations - provide instructions for me to run them manually
- When migrations are needed, list the exact commands I need to run

### Testing Execution
- Always use `--run --no-watch` flags for test commands to ensure they exit gracefully
- Include explicit timeouts in test commands to prevent hanging
- If tests don't exit cleanly, investigate event loop handles rather than forcing process exit

---

## Communication Style

- Provide clear, actionable instructions
- When suggesting code changes, explain the reasoning
- If multiple approaches exist, present options with trade-offs

---

## Project-Specific Patterns

- Follow existing code patterns in the project
- Maintain consistency with project's testing framework
- Respect project's architecture decisions

---

## Notes

- User Rules are global and apply to all projects
- They are NOT version-controlled by Cursor (that's why we document them here)
- When you update rules in Cursor Settings, also update this file
- Keep this in sync with your actual Cursor Settings
