# review-docs

Review documentation files for quality, clarity, completeness, consistency, and alignment with project standards. This command analyzes markdown documentation for structure, accuracy, readability, and adherence to documentation best practices, then either provides feedback (default) or suggests improvements (with `--suggest-fixes` flag).

## Usage

`/review-docs <path(s)> [--suggest-fixes] [--check-code-alignment] [--check-consistency]`

**Examples:**
- `/review-docs docs/architecture.md` - Review a specific documentation file
- `/review-docs docs/` - Review all markdown files in a directory
- `/review-docs docs/architecture.md docs/vision.md` - Review multiple specific documents
- `/review-docs docs/ --suggest-fixes` - Review entire docs directory and suggest improvements
- `/review-docs docs/architecture.md --check-code-alignment` - Review documentation against actual codebase
- `/review-docs docs/ --check-consistency` - Review consistency across multiple documents

**Flags:**
- `--suggest-fixes`: Provide specific documentation suggestions and improvements. When this flag is set, the command will suggest concrete edits, restructuring, and enhancements.
- `--check-code-alignment`: Verify that documentation accurately reflects the current codebase. Checks for outdated information, missing features, and discrepancies between docs and code.
- `--check-consistency`: Review consistency across multiple documents. Checks for terminology, cross-references, and alignment between related documents.

## Process

### Step 1: Identify Documents to Review

1. **If path is a file**:
   - Review the specified file
   - Validate file exists and is readable
   - Determine document type (architecture, vision, ADR, README, etc.) by filename, path, or content

2. **If path is a directory**:
   - Recursively find all markdown files (`.md`, `.markdown`)
   - Exclude `node_modules`, `.git`, build directories
   - Review all found documentation files

3. **If multiple paths provided**:
   - Review each specified file/directory
   - Maintain context across related documents

### Step 2: Analyze Document Structure

For each document, analyze:
- **Document type**: Architecture, vision, ADR, requirements, design, README, etc.
- **Structure**: Headers, sections, organization, hierarchy
- **Formatting**: Markdown syntax, code blocks, lists, tables
- **Cross-references**: Links to other docs, code, or external resources

### Step 3: Review Documentation Quality

Focus on documentation-specific quality metrics and best practices.

#### 3.1 Clarity and Readability

1. **Language and Tone**:
   - Clear, concise language appropriate for audience
   - Technical jargon explained or linked to definitions
   - Consistent voice and tone throughout
   - No ambiguous statements or unclear references

2. **Structure and Organization**:
   - Logical flow and organization
   - Clear section hierarchy (H1 → H2 → H3)
   - Table of contents for long documents (>500 lines)
   - Related information grouped together

3. **Examples and Illustrations**:
   - Code examples are accurate and complete
   - Diagrams or visual aids are described in text
   - Examples match current implementation
   - Complex concepts have concrete examples

#### 3.2 Completeness

1. **Coverage**:
   - All major topics addressed for document type
   - No obvious gaps in information
   - Edge cases and exceptions documented
   - Migration or upgrade paths documented (if applicable)

2. **Required Sections** (based on document type):
   - **Architecture docs**: Overview, components, data flow, dependencies, deployment
   - **Vision docs**: Purpose, goals, principles, success metrics
   - **ADRs**: Context, decision, consequences
   - **Requirements**: Acceptance criteria, glossary, assumptions
   - **Design docs**: Architecture, components, interfaces, implementation details
   - **README**: Setup, usage, contributing, license

3. **Missing Information**:
   - Incomplete sections or TODOs
   - Broken links or references
   - Outdated information marked but not updated

#### 3.3 Accuracy and Currency

1. **Factual Accuracy**:
   - Technical details are correct
   - Code examples work as written
   - Version numbers and dependencies are current
   - API endpoints and configurations are accurate

2. **Currency**:
   - Information reflects current state of codebase
   - Deprecated features are marked
   - Recent changes are documented
   - No references to removed or renamed components

3. **Consistency with Code** (if `--check-code-alignment` flag is set):
   - Component names match actual code
   - File paths and structures are accurate
   - API contracts match implementation
   - Configuration examples work

#### 3.4 Consistency

1. **Terminology**:
   - Consistent use of technical terms
   - Glossary terms used correctly
   - Abbreviations defined on first use
   - Naming conventions match codebase

2. **Formatting**:
   - Consistent markdown formatting
   - Uniform code block languages
   - Consistent list styles
   - Uniform date/time formats

3. **Cross-Document Consistency** (if `--check-consistency` flag is set):
   - Terminology matches across related docs
   - Cross-references are valid and accurate
   - No contradictions between documents
   - Related information is aligned

#### 3.5 Best Practices

1. **Documentation Standards**:
   - Follows project documentation conventions
   - Appropriate level of detail for audience
   - Links to related documentation
   - Version history or changelog (if applicable)

2. **Accessibility**:
   - Alt text for images (if applicable)
   - Clear headings for screen readers
   - Code examples are accessible
   - Language is inclusive

3. **Maintainability**:
   - Document is easy to update
   - Clear ownership or maintenance notes
   - Outdated sections are marked
   - Related docs are linked

### Step 4: Review Code Alignment (if `--check-code-alignment` flag is set)

1. **Component and File References**:
   - Verify referenced files and components exist
   - Check file paths are correct
   - Validate import statements in examples
   - Confirm component names match codebase

2. **API and Interface Accuracy**:
   - API endpoints match actual implementation
   - Function signatures are correct
   - Configuration options are accurate
   - Environment variables are current

3. **Architecture Accuracy**:
   - System diagrams reflect actual structure
   - Data flow matches implementation
   - Dependencies are accurate
   - Deployment process is current

4. **Code Examples**:
   - Examples compile and run
   - Code snippets are syntactically correct
   - Examples use current APIs
   - No deprecated patterns in examples

### Step 5: Review Cross-Document Consistency (if `--check-consistency` flag is set)

1. **Terminology Consistency**:
   - Same terms used across related docs
   - Glossary terms are consistent
   - Abbreviations match
   - Naming conventions align

2. **Content Alignment**:
   - No contradictions between documents
   - Related information is consistent
   - Cross-references are accurate
   - Version information aligns

3. **Reference Integrity**:
   - All internal links work
   - External links are valid (if checkable)
   - File paths in references are correct
   - Code references match actual code

### Step 6: Generate Review Report

**Default Mode (Feedback Only)**:
Create a comprehensive review report with:
- Summary of findings
- Issues organized by category (Clarity, Completeness, Accuracy, Consistency, Best Practices)
- Specific examples with line numbers or sections
- Recommendations for improvement
- Priority levels (Critical, High, Medium, Low)

**Suggest Fixes Mode** (`--suggest-fixes` flag):
- All of the above, plus:
- Specific documentation suggestions with before/after examples
- Restructuring recommendations
- Concrete improvements to implement

## Review Output Format

### Default Feedback Mode:

```markdown
# Documentation Review: [File/Directory Path]

## Summary
[Overall assessment, document count, issue count by severity]

## Documents Reviewed
- `path/to/doc1.md` - [Document type, brief assessment]
- `path/to/doc2.md` - [Document type, brief assessment]

## Issues by Category

### 🔴 Critical Issues
- **[File:Section/Line] Issue Title**
  - Description of issue
  - Impact: [What problems this causes]
  - Recommendation: [How to fix]

### 🟠 High Priority Issues
- **[File:Section/Line] Issue Title**
  - Description
  - Recommendation

### 🟡 Medium Priority Issues
- **[File:Section/Line] Issue Title**
  - Description
  - Recommendation

### 🟢 Low Priority / Suggestions
- **[File:Section/Line] Issue Title**
  - Description
  - Recommendation

## Clarity and Readability Review
- [Language issues]
- [Structure problems]
- [Missing examples]

## Completeness Review
- [Missing sections]
- [Incomplete information]
- [Gaps in coverage]

## Accuracy Review
- [Outdated information]
- [Incorrect technical details]
- [Code alignment issues]

## Consistency Review
- [Terminology inconsistencies]
- [Formatting issues]
- [Cross-document alignment]

## Best Practices Review
- [Documentation standards]
- [Accessibility concerns]
- [Maintainability issues]

## Code Alignment (if --check-code-alignment)
- [Outdated code references]
- [Incorrect API documentation]
- [Mismatched architecture]

## Cross-Document Consistency (if --check-consistency)
- [Terminology mismatches]
- [Content contradictions]
- [Broken references]
```

### Suggest Fixes Mode:

```markdown
# Documentation Review with Suggested Fixes: [File/Directory Path]

[All sections from feedback mode, plus:]

## Suggested Documentation Improvements

### [File:Section/Line] Issue Title

**Current Content:**
```markdown
<!-- Current documentation with issue -->
```

**Suggested Fix:**
```markdown
<!-- Improved documentation -->
```

**Rationale:**
[Explanation of why this change improves the documentation]

## Restructuring Recommendations

### [Document Name]

**Current Structure:**
[Description of current structure]

**Recommended Structure:**
[Description of improved structure]

**Benefits:**
- [Benefit 1]
- [Benefit 2]
```

## Priority Classification Guidelines

**Critical** - Prevents understanding, causes implementation errors, or contains factually incorrect information
- Factually incorrect technical information that would cause bugs
- Broken code examples that don't compile/run
- Missing critical information that blocks implementation
- Contradictory information that creates confusion
- Security-sensitive information incorrectly documented

**High** - Significantly impacts understanding, maintainability, or causes confusion
- Outdated information that doesn't match current codebase
- Missing major sections for document type
- Unclear or ambiguous explanations of critical concepts
- Broken internal links or references
- Terminology inconsistencies that cause confusion
- Code examples that use deprecated APIs

**Medium** - Affects documentation quality, readability, or minor accuracy issues
- Missing examples for complex concepts
- Inconsistent formatting that affects readability
- Minor inaccuracies that don't block understanding
- Missing cross-references
- Incomplete sections that don't block core understanding
- Minor terminology inconsistencies

**Low** - Minor improvements with no significant impact
- Style improvements
- Minor formatting inconsistencies
- Optional additional examples
- Nice-to-have clarifications
- Minor organizational improvements

**Decision Rule**: When uncertain between two priority levels, always classify lower.

**Quantifiable Thresholds**:
- Accuracy: Causes bugs/errors = Critical, blocks understanding = High, minor inaccuracy = Medium
- Completeness: Missing critical section = High, missing optional section = Medium
- Consistency: Causes confusion = High, minor inconsistency = Medium

## Important Notes

- **Priority Classification**: Follow the guidelines above. When in doubt, classify lower. Don't inflate priority to justify findings.

- **Document Type Awareness**: Different document types have different requirements. Architecture docs need technical accuracy, vision docs need clarity of purpose, ADRs need decision context.

- **Code Alignment**: When `--check-code-alignment` is used:
  - Outdated code that causes bugs = Critical
  - Outdated code that causes confusion = High
  - Minor inaccuracies = Medium
  - Always verify against actual codebase, not assumptions

- **Consistency**: When `--check-consistency` is used:
  - Contradictions that cause confusion = High
  - Terminology mismatches that don't block understanding = Medium
  - Minor formatting inconsistencies = Low

- **Clarity**: Ambiguous statements that block understanding = High. Minor clarity improvements = Medium/Low.

- **Completeness**: Missing critical sections = High. Missing optional sections = Medium. Nice-to-have additions = Low.

- **Project Conventions**: Respect existing documentation patterns. Reference:
  - Existing documentation structure
  - Project style guides
  - Documentation templates (if any)
  - Related documentation for consistency

## Integration with Other Commands

This command works well with:
- `/code-review` - Review code against documentation
- `/review-feature-docs` - Review specific feature documentation (requirements, design, tasks)
- `/implement` - Implement changes based on documentation
- `/mk-req`, `/gen-design`, `/gen-tasks` - Generate documentation that can be reviewed

## Exit Criteria

- ✅ All specified documents reviewed
- ✅ Issues identified and categorized by severity
- ✅ Feedback provided (default) or fixes suggested (`--suggest-fixes`)
- ✅ Code alignment verified (if `--check-code-alignment` flag set)
- ✅ Cross-document consistency checked (if `--check-consistency` flag set)
- ✅ Review report generated
