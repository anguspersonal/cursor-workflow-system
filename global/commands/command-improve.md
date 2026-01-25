# command-improve

## Purpose
Review, improve, and optimize one or more Cursor commands according to best practices. This meta-command analyzes command files for clarity, actionability, scope, and composability.

## Usage
```
/command-improve @[command-file1] @[command-file2] ...
```

**Single Command Mode**: Apply best practices to optimize one command
**Multi-Command Mode**: Review command interactions and coherence, then optimize individually

## Analysis Framework

### Phase 1: Read and Understand
1. Read all provided command files completely
2. **Determine Command Scope**:
   - Identify if each command is **global** (in `~/.cursor/commands/`) or **local** (in project's `.cursor/commands/`)
   - Global commands should avoid project-specific references (test scripts, project paths, etc.)
   - Local commands can reference project-specific tools, scripts, and paths
   - If unclear, clarify with the user before making improvements
3. If multiple commands:
   - Identify overlapping responsibilities
   - Check for conflicting guidance
   - Assess whether commands are properly composable
   - Determine if commands should be merged or split
4. Extract the core intent of each command

### Phase 2: Best Practice Evaluation

Check each command against these criteria:

#### Structure & Clarity
- **Focus**: Does the command have a single, clear purpose?
- **Actionability**: Are instructions concrete and executable?
- **Length**: Is it under 500 lines? Should it be split?
- **Scope**: Is the scope well-defined and appropriate?

#### Content Quality
- **Vague Guidance**: Does it avoid generic advice like "write good code"?
- **File References**: Does it reference files instead of copying content?
- **Examples**: Are examples concrete and project-specific?
- **Scope Appropriateness**: 
  - For **global commands**: Does it avoid project-specific references (test scripts, project paths, package.json scripts, etc.)?
  - For **local commands**: Are project-specific references appropriate and accurate?
  - If a command mentions running tests or project-specific scripts, is it clear this only applies to the project where the command lives?
- **Assumptions**: Does it avoid documenting obvious tools (npm, git, pytest)?
- **Edge Cases**: Are instructions focused on frequent patterns, not rare scenarios?
- **Duplication**: Does it avoid copying what's already in the codebase?

#### Naming & Organization
- **Command Name**: Is the filename concise and semantically meaningful?
- **Kebab-case**: Does the filename follow kebab-case convention?
- **Descriptive**: Does the name clearly indicate the command's purpose?

#### Multi-Command Analysis (if applicable)
- **Overlap**: Do commands duplicate functionality?
- **Gaps**: Are there missing connections between related commands?
- **Composition**: Can commands be chained or referenced effectively?
- **Hierarchy**: Is there a clear relationship between commands?

### Phase 3: Issue Classification

Categorize identified issues by severity:

**HIGH** - Critical problems that prevent effective use:
- Command purpose is unclear or contradictory
- Instructions are impossible to follow
- Severe duplication across multiple commands
- File references or examples that don't exist
- Command exceeds 500 lines without good reason
- **Scope Mismatch**: Global command references project-specific scripts/paths, or local command scope is unclear

**MEDIUM** - Significant issues that reduce effectiveness:
- Vague or generic guidance that doesn't help
- Poor command naming (unclear purpose)
- Missing concrete examples
- Significant overlap between commands
- Mixing multiple distinct purposes
- Copying content instead of referencing files
- Documenting obvious tools extensively
- **Scope Ambiguity**: Command doesn't clarify whether project-specific instructions apply only to the current project or globally

**LOW** - Minor improvements that enhance quality:
- Formatting inconsistencies
- Could be more concise
- Examples could be more concrete
- Minor naming improvements
- Command could reference another command

### Phase 4: Fix and Improve

For each identified issue:
1. **Explain the problem** clearly
2. **Apply the fix** by rewriting the affected command(s)
3. **Verify the fix** resolves the issue

#### Common Fixes

**Too Long (>500 lines)**
- Split into multiple focused commands
- Remove duplicated content
- Replace copied content with file references

**Vague Guidance**
- Replace generic advice with concrete examples
- Add specific file paths or code patterns from the project
- Remove obvious tool documentation

**Poor Naming**
- Suggest concise, semantic alternatives
- Follow kebab-case convention
- Ensure name matches actual purpose

**Command Overlap**
- Merge redundant commands
- Split multi-purpose commands
- Create composition hierarchy

**Missing File References**
- Replace content copying with references
- Link to canonical examples in codebase
- Point to existing documentation

**Scope Mismatch or Ambiguity**
- For **global commands**: Remove or generalize project-specific references (test scripts, package.json paths, project-specific tools)
- For **local commands**: Add clear context that project-specific instructions (like test scripts) only apply to the project where the command is located
- Add explicit scope notes: "This command is project-specific" or "This command is global and works across all projects"
- When mentioning test scripts or project-specific commands, clarify: "Run tests using the project's test script (e.g., `npm test` in this project)" for local commands, or remove entirely for global commands

### Phase 5: Final Report

Provide a structured summary:

```markdown
## Command Improvement Report

### Commands Analyzed
- [List all commands reviewed]

### Issues Found

#### High Priority Issues
[List high severity issues or "None found"]

#### Medium Priority Issues
[List medium severity issues or "None found"]

#### Low Priority Issues
[List low severity issues or "None found"]

### Resolutions Applied

#### Fully Resolved
[List all issues that were completely fixed]

#### Partially Resolved
[List any issues with partial fixes and what remains]

#### Unresolved
[List any issues that couldn't be resolved and why]

### Recommended Actions

#### Name Changes
- `old-name.md` → `new-name.md` (Reason: ...)

#### Command Restructuring
[Any recommendations for splitting, merging, or reorganizing]

#### File References Needed
[Specific files that should be referenced instead of copied]

### Summary
[Brief overview of command quality and improvements made]
```

## Important Guidelines

1. **Be Honest**: Don't create high-priority issues where none exist
2. **Be Specific**: Reference exact line numbers and content when identifying issues
3. **Be Practical**: Focus on improvements that materially enhance usability
4. **Be Complete**: Aim to resolve all identified issues before reporting
5. **Be Concise**: Keep improved commands under 500 lines
6. **Preserve Intent**: Maintain the original purpose while improving execution

## Expected Outcome

After running this command:
- All commands should be focused, actionable, and well-scoped
- File references should replace content duplication
- Commands should compose well together
- Names should be clear and semantic
- Ideally, zero unresolved issues remain

## Notes

- This command should itself follow all best practices it enforces
- When improving multiple commands, address systemic issues first
- Always show the rewritten command content for user review
- If a command is already excellent, say so clearly
