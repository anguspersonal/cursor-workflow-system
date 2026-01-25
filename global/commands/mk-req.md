# mk-req

Write your command content here.

This command will be available in chat with /mk-req

# Make Requirements Document

Generate a comprehensive requirements document for a feature, module, or system component following a standardized format that ensures clarity, testability, and implementation readiness.

## Usage
`/makeReqs <feature/module name> [optional: brief description]`

Example: `/makeReqs slide variant management` or `/makeReqs user authentication system`

## Process

### Step 1: Understand the Context
- Read relevant documentation, design files, or existing requirements in the project
- Review related code files to understand current implementation
- Identify stakeholders, user personas, and use cases
- Understand the project's architecture and technical constraints
- Review example requirements documents (e.g., `docs/styling/requirements.md`, `docs/slideVariantMgmt/requirements.md`) to match format

### Step 2: Gather Information
If the user provides a feature name or description:
- Search the codebase for related implementations
- Check for existing design documents, ADRs, or specifications
- Review similar requirements documents in the project (if any) to match format
- Identify dependencies and integration points
- Determine the system/component name that will be used in acceptance criteria (e.g., `Styling_System`, `Slide_Variant_System`)

### Step 3: Create Requirements Document Structure

First look for a directory. (typically `docs/<feature-name>` E.g. for the feature personal invites, the directory would be docs/personal-invites). If no directory, make one. If no docs/ directory, make one. Then create a markdown file in the appropriate location  with the following structure:

#### 1. Introduction Section
```markdown
## Introduction

This document specifies the requirements for [feature name] in the [application/project name]. [Brief description of what the system enables]. [Implementation approach or key principles]. [Priority or key goals].
```
- Provide a clear overview of what the feature/module does
- Explain its purpose within the larger system
- Describe the problem it solves or value it provides
- Include any relevant background or context
- Mention implementation approach if relevant (e.g., "code-first", "database-driven")

#### 2. Glossary Section
```markdown
## Glossary

- **Term Name**: Clear definition with technical details, examples, or constraints
- **Another Term**: Definition with specific values, formats, or references
```
- Define all domain-specific terms, acronyms, and technical concepts
- Use clear, concise definitions
- Include terms that might be ambiguous or project-specific
- Format as a bulleted list with **bold terms** followed by definitions
- Include specific values, formats, or constraints when relevant (e.g., localStorage keys, database table names, color codes)

#### 3. Requirements Section
For each requirement, use this exact structure:

```markdown
### Requirement N: [Descriptive Title]

**User Story:** As a [user type], I want [goal], so that [benefit].

#### Acceptance Criteria

1. WHEN [condition/trigger] [AND/OR additional conditions] THEN the [System_Name] SHALL [expected behavior/outcome]
2. WHEN [condition] THEN the [System_Name] SHALL [expected behavior]
...
```

**Key Formatting Rules:**
- **Requirement Number and Title**: Use "Requirement N: [Clear, descriptive title]"
- **User Story**: Format: "As a [user type], I want [goal], so that [benefit]"
- **Acceptance Criteria**: 
  - Numbered list (1., 2., 3., ...)
  - Use "WHEN...THEN...SHALL" format
  - Use `System_Name` (e.g., `Styling_System`, `Auth_System`) consistently throughout acceptance criteria
  - Use AND/OR for compound conditions
  - Include specific technical details (keys, values, formats, table names, etc.)
  - Cover edge cases, error scenarios, and fallback behaviors
  - Specify data formats, validation rules, and constraints
  - Include performance, security, and accessibility requirements where relevant

**System Name Convention:**
- Derive from feature name: "styling" → `Styling_System`, "slide variant" → `Slide_Variant_System`
- Use consistent naming throughout all acceptance criteria in the document
- Use underscores (e.g., `System_Name`) not hyphens or spaces

#### 4. Document Revision Notes (Optional but Recommended)
```markdown
## Document Revision Notes

### Key Clarifications Made

This section documents ambiguities that were identified and resolved during the requirements review:

1. **Clarification Title**: Description of what was clarified and why. This resolves conflicts between Requirements X, Y, and Z.
2. **Another Clarification**: Description...
```
- Document any ambiguities that were identified and resolved
- Note key decisions or clarifications made during requirements gathering
- Reference which requirements were affected by each clarification
- Include any assumptions or constraints that were made explicit

### Step 4: Requirements Quality Checklist

Ensure each requirement:
- ✅ Is specific and unambiguous
- ✅ Is testable and verifiable
- ✅ Uses clear, consistent terminology (from glossary)
- ✅ Uses consistent `System_Name` in all acceptance criteria
- ✅ Includes acceptance criteria with WHEN/THEN/SHALL format
- ✅ Has a user story (when applicable)
- ✅ Covers edge cases and error handling
- ✅ Specifies exact data formats, keys, values, and validation rules
- ✅ Includes non-functional requirements (performance, security, accessibility) where relevant
- ✅ Is independent and can be implemented separately (when possible)
- ✅ Includes specific technical details (localStorage keys, database tables, API endpoints, etc.)

### Step 5: Review and Refine
- Ensure consistency in terminology throughout the document
- Verify all acceptance criteria use the same `System_Name` format
- Verify all acceptance criteria are measurable and testable
- Check that requirements don't conflict with each other
- Ensure requirements align with project architecture and constraints
- Validate that the document follows the project's existing requirements format
- Ensure technical details (keys, values, formats) are specified exactly

## Document Location

Place the requirements document in:
- `docs/<feature-name>/requirements.md` (if feature has its own folder)
- `docs/requirements/<feature-name>.md` (if using a requirements folder)
- `docs/<feature-name>_requirements.md` (if flat structure)

Match the existing project structure and naming conventions. Check existing requirements documents to determine the pattern.

## Exit Criteria
- ✅ Requirements document created with all required sections
- ✅ All requirements have user stories and acceptance criteria
- ✅ All acceptance criteria use consistent `System_Name` format with WHEN/THEN/SHALL
- ✅ Glossary includes all domain-specific terms with specific values/formats where relevant
- ✅ Document follows project's existing format/style (matching example requirements)
- ✅ Requirements are specific, testable, and unambiguous
- ✅ Technical details are specified exactly (keys, values, formats, table names, etc.)
- ✅ Document is saved in the appropriate location

## Important Notes
- **Be thorough**: Requirements should be comprehensive enough for implementation without ambiguity
- **Use project terminology**: Match existing glossary terms and naming conventions from the codebase
- **Follow existing patterns**: Match the format and style of example requirements documents exactly
- **System Name**: Use a consistent `System_Name` (with underscores) throughout all acceptance criteria
- **Technical Specificity**: Include exact values, keys, formats, table names, API endpoints, etc.
- **WHEN/THEN/SHALL Format**: Always use this format for acceptance criteria - it ensures clarity and testability
- **Consider dependencies**: Note any dependencies on other features or systems
- **Include non-functional requirements**: Performance, security, accessibility, and usability requirements are important
- **Make it testable**: Every acceptance criterion should be verifiable through testing or inspection
- **User-focused**: Requirements should emphasize user value and business outcomes
- **Document clarifications**: Use the Document Revision Notes section to record any ambiguities that were resolved

