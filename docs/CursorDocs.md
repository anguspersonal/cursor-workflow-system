# Cursor Documentation Reference

A comprehensive guide to Cursor's configuration system, covering Rules, Commands, Skills, Subagents, and MCP integration.

**Source:** [Cursor Official Documentation](https://cursor.com/docs)  
**Extracted:** January 25, 2026  
**Compiled by:** Angus

> **Note:** This is a consolidated reference compiled from Cursor's official documentation. For the most up-to-date information, please refer to the [official Cursor docs](https://cursor.com/docs).

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Core Concepts](#core-concepts)
3. [Rules](#rules)
   - [User Rules](#user-rules)
   - [Project Rules](#project-rules)
   - [Team Rules](#team-rules)
   - [AGENTS.md](#agentsmd)
4. [Commands](#commands)
5. [Agent Skills](#agent-skills)
6. [Subagents](#subagents)
7. [Model Context Protocol (MCP)](#model-context-protocol-mcp)
8. [Best Practices](#best-practices)
9. [FAQ](#faq)

---

## Quick Reference

### Configuration Types at a Glance

| Feature | Scope | Location | Complexity | Version Control |
|---------|-------|----------|------------|-----------------|
| **User Rules** | All projects (personal) | Cursor Settings | Simple | No |
| **Project Rules** | Single project | `.cursor/rules/` | Advanced (metadata, globs) | Yes |
| **Team Rules** | All projects (team) | Cursor Dashboard | Simple | No |
| **AGENTS.md** | Single project | Project root or subdirs | Very simple | Yes |
| **Commands** | Project/Global/Team | `.cursor/commands/`, `~/.cursor/commands/`, Dashboard | Simple | Yes (local) |
| **Skills** | Project/Global | `.cursor/skills/`, `~/.cursor/skills/` | Medium (with scripts) | Yes |
| **Subagents** | Project/Global | `.cursor/agents/`, `~/.cursor/agents/` | Medium | Yes |

### File Locations Quick Guide

```
project-root/
├── .cursor/
│   ├── rules/              # Project Rules (.md or .mdc files)
│   ├── commands/           # Project Commands (.md files)
│   ├── skills/             # Agent Skills (folders with SKILL.md)
│   ├── agents/             # Subagents (.md files with frontmatter)
│   └── mcp.json           # MCP server configuration
├── AGENTS.md              # Simple agent instructions (alternative to rules)
└── .cursorrules           # Legacy format (still supported, deprecated)

~/.cursor/                  # User home directory
├── commands/              # Global commands
├── skills/                # Global skills
├── agents/                # Global subagents
└── mcp.json              # Global MCP configuration
```

### Precedence Order

When multiple rules apply, they're merged in this order:

**Team Rules → Project Rules → User Rules**

(Earlier sources take precedence when guidance conflicts)

---

## Core Concepts

### How Rules Work with LLMs

Large language models don't retain memory between completions. Rules provide **persistent, reusable context** at the prompt level.

When applied, rule contents are included at the start of the model context. This gives the AI consistent guidance for:
- Generating code
- Interpreting edits
- Helping with workflows

### When to Use What

| Use this... | When you need... |
|-------------|------------------|
| **User Rules** | Personal preferences across all projects |
| **Project Rules** | Domain-specific knowledge for a codebase |
| **Team Rules** | Organizational standards enforced team-wide |
| **AGENTS.md** | Simple, readable instructions without metadata |
| **Commands** | Reusable workflows triggered with `/` |
| **Skills** | Portable, executable domain-specific capabilities |
| **Subagents** | Context isolation for complex/parallel tasks |
| **MCP** | Integration with external tools and data sources |

---

## Rules

Rules provide system-level instructions to Agent. They bundle prompts, scripts, and more together, making it easy to manage and share workflows.

### User Rules

**Location:** Cursor Settings → Rules  
**Scope:** Global across ALL your projects  
**Used by:** Agent (Chat) only  

User Rules are personal preferences like communication style or coding conventions.

**Example:**

```
Please reply in a concise style. Avoid unnecessary repetition.
```

**When to use:**
- Personal coding style preferences
- Communication preferences
- Global conventions you follow across all projects

---

### Project Rules

**Location:** `.cursor/rules/` folder (version-controlled)  
**Scope:** Specific to the project/codebase  
**Used by:** Agent (Chat)

Project rules are scoped using path patterns, invoked manually, or included based on relevance.

#### Directory Structure

```
.cursor/rules/
  react-patterns.mdc       # Rule with frontmatter (description, globs)
  api-guidelines.md        # Simple markdown rule
  frontend/                # Organize rules in folders
    components.md
```

#### Rule Types

| Rule Type | Description |
|-----------|-------------|
| **Always Apply** | Apply to every chat session |
| **Apply Intelligently** | When Agent decides it's relevant based on description |
| **Apply to Specific Files** | When file matches a specified pattern |
| **Apply Manually** | When @-mentioned in chat (e.g., `@my-rule`) |

#### File Format

Rules can be `.md` (simple markdown) or `.mdc` (markdown with frontmatter).

**Simple Markdown (.md):**

```markdown
- Use our internal RPC pattern when defining services
- Always use snake_case for service names.
```

**With Frontmatter (.mdc):**

```markdown
---
description: "This rule provides standards for frontend components and API validation"
alwaysApply: false
globs:
  - "src/components/**/*.tsx"
  - "src/api/**/*.ts"
---

## Component Standards

- Use TypeScript for all components
- Prefer functional components with hooks
- Include PropTypes or TypeScript interfaces

## API Validation

- Validate all inputs
- Use Zod schemas for validation
- Return proper error codes
```

#### Frontmatter Fields

| Field | Type | Description |
|-------|------|-------------|
| `description` | string | What the rule does and when to use it (used by Agent for relevance) |
| `alwaysApply` | boolean | If `true`, apply to every chat. If `false`, Agent decides based on description |
| `globs` | array | File patterns to match (e.g., `["src/**/*.ts"]`) |

#### Creating Rules

1. Use the **New Cursor Rule** command
2. Or go to **Cursor Settings → Rules, Commands**
3. Or manually create files in `.cursor/rules/`

#### Best Practices

✅ **DO:**
- Keep rules under 500 lines
- Split large rules into multiple, composable rules
- Provide concrete examples or referenced files
- Write rules like clear internal docs
- Reference files instead of copying contents
- Check rules into git

❌ **DON'T:**
- Copy entire style guides (use a linter instead)
- Document every possible command (Agent knows common tools)
- Add instructions for rare edge cases
- Duplicate what's already in your codebase
- Over-optimize before understanding your patterns

**Start simple.** Add rules only when you notice Agent making the same mistake repeatedly.

---

### Team Rules

**Location:** Cursor Dashboard (Team/Enterprise plans)  
**Scope:** Team-wide (all team members, all projects)  
**Used by:** Agent (Chat)

Team Rules are managed by admins and can be enforced across the entire organization.

#### Features

- **Centralized management:** Update once, applies to all team members instantly
- **Enforcement:** Admins can make rules required (users can't disable them)
- **Plain text:** No frontmatter metadata or folder structure
- **Auto-sync:** Changes are immediately available to all team members

#### Creating Team Rules

1. Navigate to the **Cursor Dashboard**
2. Click to create a new Team Rule
3. Provide:
   - **Name:** Rule identifier
   - **Description:** What the rule does
   - **Content:** The rule instructions
4. **Enable this rule immediately:** Active as soon as created (or save as draft)
5. **Enforce this rule:** Required for all members (can't be disabled)

#### Format

Team Rules are plain text, no metadata support. They apply globally across all repositories when enabled.

---

### AGENTS.md

**Location:** Project root (or subdirectories)  
**Scope:** Project-specific  
**Used by:** Agent (Chat)  
**Format:** Plain markdown (no frontmatter)

AGENTS.md is a **simple alternative** to `.cursor/rules/` for straightforward use cases.

#### When to Use

- Simple, readable instructions without metadata overhead
- Projects that don't need complex rule scoping
- Quick setup without folder structure

#### File Structure

```
project/
  AGENTS.md              # Global instructions (ROOT)
  frontend/
    AGENTS.md            # Frontend-specific instructions
  backend/
    AGENTS.md            # Backend-specific instructions
```

#### Example

```markdown
# Project Instructions

## Code Style
- Use TypeScript for all new files
- Prefer functional components in React
- Use snake_case for database columns

## Architecture
- Follow the repository pattern
- Keep business logic in service layers
```

#### AGENTS.md vs Project Rules

| AGENTS.md | Project Rules |
|-----------|---------------|
| Single file | Multiple files in folder |
| No metadata | Frontmatter with globs, descriptions |
| Very simple | Advanced scoping and application |
| Good for small projects | Good for complex codebases |

---

### Legacy: .cursorrules

The `.cursorrules` file in your project root is still supported but **deprecated**.

**Recommendation:** Migrate to **Project Rules** or **AGENTS.md**.

---

## Commands

Custom commands allow you to create **reusable workflows** triggered with a `/` prefix in the chat input box.

### How Commands Work

Commands are plain Markdown files that define workflows. Type `/` in chat to see available commands.

**Example:**

```
/review-code and check for security vulnerabilities
```

### Command Locations

| Type | Location | Scope |
|------|----------|-------|
| **Project Commands** | `.cursor/commands/` | Current project only |
| **Global Commands** | `~/.cursor/commands/` | All projects for current user |
| **Team Commands** | Cursor Dashboard | All team members (Team/Enterprise plans) |

### Creating Commands

#### Local Commands (Project or Global)

1. Create a `.cursor/commands` directory in your project root (or `~/.cursor/commands` for global)
2. Add `.md` files with descriptive names (e.g., `review-code.md`, `write-tests.md`)
3. Write plain Markdown describing what the command should do

**Example Directory:**

```
.cursor/
└── commands/
    ├── address-github-pr-comments.md
    ├── code-review-checklist.md
    ├── create-pr.md
    ├── light-review-existing-diffs.md
    ├── onboard-new-developer.md
    ├── run-all-tests-and-fix.md
    ├── security-audit.md
    └── setup-new-feature.md
```

**Example Command File (`code-review-checklist.md`):**

```markdown
Review the current changes against this checklist:

1. **Code Quality**
   - Functions are single-purpose
   - Variable names are descriptive
   - No magic numbers or strings

2. **Testing**
   - New features have tests
   - Edge cases are covered
   - Tests are maintainable

3. **Security**
   - No hardcoded secrets
   - Input validation is present
   - Authentication/authorization is correct

4. **Documentation**
   - Public APIs are documented
   - Complex logic has comments
   - README is updated if needed

Report any issues found with severity level and file location.
```

#### Team Commands

1. Navigate to **Cursor Dashboard → Team Content**
2. Click **Create new command**
3. Provide:
   - **Name:** Command name (appears after `/`)
   - **Description (optional):** Context about what it does
   - **Content:** Markdown instructions
4. Save

Team commands automatically sync to all team members.

### Using Commands

**Basic usage:**

```
/review-code
```

**With parameters** (anything after the command name is included as context):

```
/commit and /pr these changes to address DX-523
```

### Example Commands

- **Code review checklist** - Standardized review process
- **Security audit** - Check for common vulnerabilities
- **Setup new feature** - Scaffold feature structure
- **Create pull request** - Generate PR with proper formatting
- **Run tests and fix failures** - Execute tests and address issues
- **Onboard new developer** - Setup instructions and context

---

## Agent Skills

**Agent Skills** is an open standard for extending AI agents with specialized, executable capabilities.

### What Are Skills?

Skills are **portable, version-controlled packages** that teach agents domain-specific tasks. They can include:
- Instructions
- Executable scripts (Bash, Python, JavaScript, etc.)
- Reference documentation
- Asset files

### Key Features

- **Portable:** Work across any agent supporting the Agent Skills standard
- **Version-controlled:** Stored as files, tracked in git
- **Executable:** Can include scripts agents execute
- **Progressive:** Resources loaded on demand for efficient context usage

### Skill Directories

Skills are auto-discovered from these locations:

| Location | Scope |
|----------|-------|
| `.cursor/skills/` | Project-level |
| `.claude/skills/` | Project-level (Claude compatibility) |
| `.codex/skills/` | Project-level (Codex compatibility) |
| `~/.cursor/skills/` | User-level (global) |
| `~/.claude/skills/` | User-level (Claude compatibility) |
| `~/.codex/skills/` | User-level (Codex compatibility) |

### Skill Structure

**Basic skill:**

```
.cursor/
└── skills/
    └── my-skill/
        └── SKILL.md
```

**Advanced skill with scripts:**

```
.cursor/
└── skills/
    └── deploy-app/
        ├── SKILL.md
        ├── scripts/
        │   ├── deploy.sh
        │   └── validate.py
        ├── references/
        │   └── REFERENCE.md
        └── assets/
            └── config-template.json
```

### SKILL.md Format

Each skill has a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: my-skill
description: Short description of what this skill does and when to use it.
license: MIT
compatibility: Requires Python 3.8+
disable-model-invocation: false
---

# My Skill

Detailed instructions for the agent.

## When to Use

- Use this skill when...
- This skill is helpful for...

## Instructions

- Step-by-step guidance for the agent
- Domain-specific conventions
- Best practices and patterns
- Use the ask questions tool if you need to clarify requirements
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier (lowercase, hyphens only). Must match folder name. |
| `description` | Yes | What the skill does and when to use it (Agent uses this for relevance) |
| `license` | No | License name or reference to bundled file |
| `compatibility` | No | Environment requirements |
| `metadata` | No | Arbitrary key-value pairs |
| `disable-model-invocation` | No | If `true`, skill is only used when explicitly invoked via `/skill-name` |

### Including Scripts in Skills

Reference scripts using relative paths:

```markdown
---
name: deploy-app
description: Deploy the application to staging or production environments. Use when deploying code or when the user mentions deployment, releases, or environments.
---

# Deploy App

Deploy the application using the provided scripts.

## Usage

Run the deployment script: `scripts/deploy.sh <environment>`

Where `<environment>` is either `staging` or `production`.

## Pre-deployment Validation

Before deploying, run: `python scripts/validate.py`
```

The agent reads these instructions and executes the scripts when invoked.

**Script best practices:**
- Self-contained
- Helpful error messages
- Handle edge cases gracefully
- Can be written in any language (Bash, Python, JavaScript, etc.)

### Optional Directories

| Directory | Purpose |
|-----------|---------|
| `scripts/` | Executable code agents can run |
| `references/` | Additional documentation (loaded on demand) |
| `assets/` | Static resources like templates, images, data files |

### Installing Skills from GitHub

1. Open **Cursor Settings → Rules**
2. In **Project Rules**, click **Add Rule**
3. Select **Remote Rule (Github)**
4. Enter the GitHub repository URL

### Migrating Rules/Commands to Skills

Cursor 2.4+ includes `/migrate-to-skills` which converts:

- **Dynamic rules** (Apply Intelligently) → Standard skills
- **Slash commands** → Skills with `disable-model-invocation: true`

**To migrate:**

```
/migrate-to-skills
```

Agent identifies eligible rules/commands and converts them. Review results in `.cursor/skills/`.

### Skills vs Commands vs Subagents

| Use Skills when... | Use Commands when... | Use Subagents when... |
|--------------------|----------------------|-----------------------|
| Task requires domain expertise | Quick, repeatable action | Need context isolation |
| Scripts need to be executed | Single-purpose task | Running parallel workstreams |
| Want portable, reusable capability | Don't need separate context | Task requires many steps |

---

## Subagents

**Subagents** are specialized AI assistants that Cursor's agent can delegate tasks to. Each operates in its own context window.

### Key Features

- **Context isolation:** Each subagent has its own context window
- **Parallel execution:** Launch multiple subagents simultaneously
- **Specialized expertise:** Configure with custom prompts, tools, and models
- **Reusability:** Define once, use across projects

### How Subagents Work

When Agent encounters a complex task, it can launch a subagent. The subagent:
1. Receives a prompt with necessary context
2. Works autonomously in its own context
3. Returns final results to parent agent

Subagents start with a **clean context** (no access to prior conversation history).

### Execution Modes

| Mode | Behavior | Best for |
|------|----------|----------|
| **Foreground** | Blocks until completion, returns immediately | Sequential tasks needing output |
| **Background** | Returns immediately, works independently | Long-running or parallel tasks |

### Built-in Subagents

Cursor includes three built-in subagents:

| Subagent | Purpose | Why it's a subagent |
|----------|---------|---------------------|
| **Explore** | Searches and analyzes codebases | Exploration generates large output. Uses faster model for parallel searches. |
| **Bash** | Runs series of shell commands | Command output is verbose. Isolation keeps parent focused. |
| **Browser** | Controls browser via MCP tools | Browser interactions produce noisy DOM snapshots. Filters to relevant results. |

These are used **automatically** when appropriate.

### Custom Subagents

Define custom subagents for specialized tasks.

#### File Locations

| Type | Location | Scope |
|------|----------|-------|
| **Project subagents** | `.cursor/agents/` | Current project only |
| | `.claude/agents/` | Current project (Claude compat) |
| | `.codex/agents/` | Current project (Codex compat) |
| **User subagents** | `~/.cursor/agents/` | All projects |
| | `~/.claude/agents/` | All projects (Claude compat) |
| | `~/.codex/agents/` | All projects (Codex compat) |

Project subagents take precedence over user subagents when names conflict.

#### File Format

Each subagent is a Markdown file with YAML frontmatter:

```markdown
---
name: security-auditor
description: Security specialist. Use when implementing auth, payments, or handling sensitive data.
model: inherit
readonly: false
is_background: false
---

You are a security expert auditing code for vulnerabilities.

When invoked:
1. Identify security-sensitive code paths
2. Check for common vulnerabilities (injection, XSS, auth bypass)
3. Verify secrets are not hardcoded
4. Review input validation and sanitization

Report findings by severity:
- Critical (must fix before deploy)
- High (fix soon)
- Medium (address when possible)
```

#### Configuration Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Unique identifier (lowercase, hyphens). Defaults to filename. |
| `description` | No | When to use this subagent (Agent reads this to decide delegation) |
| `model` | No | Model to use: `fast`, `inherit`, or specific model ID. Default: `inherit` |
| `readonly` | No | If `true`, runs with restricted write permissions |
| `is_background` | No | If `true`, runs in background without waiting |

### Using Subagents

#### Automatic Delegation

Agent proactively delegates based on:
- Task complexity and scope
- Subagent descriptions
- Current context

**Tip:** Include phrases like "use proactively" or "always use for" in your `description` field.

#### Explicit Invocation

Request specific subagents:

```
/verifier confirm the auth flow is complete
/debugger investigate this error
/security-auditor review the payment module
```

Or mention them naturally:

```
Use the verifier subagent to confirm the auth flow is complete
```

#### Parallel Execution

Launch multiple subagents concurrently:

```
Review the API changes and update the documentation in parallel
```

Agent sends multiple Task tool calls simultaneously.

#### Resuming Subagents

Each execution returns an agent ID. Resume with full context:

```
Resume agent abc123 and analyze the remaining test failures
```

### Common Patterns

#### Verification Agent

Independently validates completed work:

```markdown
---
name: verifier
description: Validates completed work. Use after tasks are marked done to confirm implementations are functional.
model: fast
---

You are a skeptical validator. Your job is to verify that work claimed as complete actually works.

When invoked:
1. Identify what was claimed to be completed
2. Check that the implementation exists and is functional
3. Run relevant tests or verification steps
4. Look for edge cases that may have been missed

Be thorough and skeptical. Report:
- What was verified and passed
- What was claimed but incomplete or broken
- Specific issues that need to be addressed

Do not accept claims at face value. Test everything.
```

**Use cases:**
- Validate features work end-to-end
- Catch partially implemented functionality
- Ensure tests actually pass

#### Orchestrator Pattern

For complex workflows, coordinate multiple specialist subagents:

1. **Planner** analyzes requirements → creates technical plan
2. **Implementer** builds feature based on plan
3. **Verifier** confirms implementation matches requirements

Each handoff includes structured output for clear context.

#### Example: Debugger Subagent

```markdown
---
name: debugger
description: Debugging specialist for errors and test failures. Use when encountering issues.
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach

Focus on fixing the underlying issue, not symptoms.
```

#### Example: Test Runner Subagent

```markdown
---
name: test-runner
description: Test automation expert. Use proactively to run tests and fix failures.
---

You are a test automation expert.

When you see code changes, proactively run appropriate tests.

If tests fail:
1. Analyze the failure output
2. Identify the root cause
3. Fix the issue while preserving test intent
4. Re-run to verify

Report test results with:
- Number of tests passed/failed
- Summary of any failures
- Changes made to fix issues
```

### Best Practices

✅ **DO:**
- Write focused subagents (single responsibility)
- Invest time in descriptions (determines when Agent delegates)
- Keep prompts concise and direct
- Add subagents to version control
- Start with Agent-generated agents, then customize

❌ **DON'T:**
- Create dozens of generic subagents
- Use vague descriptions like "helps with coding"
- Write overly long prompts (2,000+ words)
- Duplicate slash commands (use commands instead)
- Create too many (start with 2-3 focused ones)

### Performance and Cost

**Benefits:**
- Context isolation
- Parallel execution
- Specialized focus

**Trade-offs:**
- Startup overhead (each gathers own context)
- Higher token usage (multiple contexts simultaneously)
- May be slower for simple tasks

**Token considerations:**
- Each subagent uses tokens independently
- Five parallel subagents ≈ 5x token usage
- For quick tasks, main agent is often faster
- Subagents shine for complex, long-running, or parallel work

---

## Model Context Protocol (MCP)

**MCP** enables Cursor to connect to external tools and data sources.

### What is MCP?

[Model Context Protocol](https://modelcontextprotocol.io/introduction) is a standard protocol for connecting AI assistants to:
- External APIs
- Databases
- Web services
- Local tools
- Any system that can communicate via `stdout` or HTTP

### Why Use MCP?

Instead of explaining your project structure repeatedly, integrate directly with:
- Project management tools (Jira, Linear)
- Design tools (Figma)
- Documentation systems
- Cloud services
- Custom APIs

### Transport Methods

Cursor supports three transport methods:

| Transport | Execution | Deployment | Users | Input | Auth |
|-----------|-----------|------------|-------|-------|------|
| **stdio** | Local | Cursor manages | Single | Shell command | Manual |
| **SSE** | Local/Remote | Deploy as server | Multiple | URL to SSE endpoint | OAuth |
| **Streamable HTTP** | Local/Remote | Deploy as server | Multiple | URL to HTTP endpoint | OAuth |

### Protocol Support

| Feature | Support | Description |
|---------|---------|-------------|
| **Tools** | ✅ | Functions for AI to execute |
| **Prompts** | ✅ | Templated messages and workflows |
| **Resources** | ✅ | Structured data sources |
| **Roots** | ✅ | URI or filesystem boundary inquiries |
| **Elicitation** | ✅ | Server-initiated requests for info |

### Installing MCP Servers

#### One-Click Installation

Browse and install from [MCP directory](https://cursor.com/docs/context/mcp/directory).

Click **"Add to Cursor"** buttons to install with OAuth.

#### Using mcp.json

Configure custom MCP servers:

**CLI Server - Node.js:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "mcp-server"],
      "env": {
        "API_KEY": "value"
      }
    }
  }
}
```

**CLI Server - Python:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "python",
      "args": ["mcp-server.py"],
      "env": {
        "API_KEY": "value"
      }
    }
  }
}
```

**Remote Server (HTTP/SSE):**

```json
{
  "mcpServers": {
    "server-name": {
      "url": "http://localhost:3000/mcp",
      "headers": {
        "API_KEY": "value"
      }
    }
  }
}
```

#### Static OAuth for Remote Servers

For MCP servers with fixed OAuth credentials:

```json
{
  "mcpServers": {
    "oauth-server": {
      "url": "https://api.example.com/mcp",
      "auth": {
        "CLIENT_ID": "your-oauth-client-id",
        "CLIENT_SECRET": "your-client-secret",
        "scopes": ["read", "write"]
      }
    }
  }
}
```

**Cursor's OAuth redirect URL:**

```
cursor://anysphere.cursor-mcp/oauth/callback
```

Register this URL in your OAuth provider's allowed redirect URIs.

#### STDIO Server Configuration

For local command-line servers:

| Field | Required | Description | Examples |
|-------|----------|-------------|----------|
| `type` | Yes | Server connection type | `"stdio"` |
| `command` | Yes | Command to start server | `"npx"`, `"node"`, `"python"`, `"docker"` |
| `args` | No | Arguments array | `["server.py", "--port", "3000"]` |
| `env` | No | Environment variables | `{"API_KEY": "${env:api-key}"}` |
| `envFile` | No | Path to env file | `".env"`, `"${workspaceFolder}/.env"` |

**Note:** `envFile` is only for STDIO servers, not remote servers.

#### Configuration Locations

- **Project:** `.cursor/mcp.json` in project root
- **Global:** `~/.cursor/mcp.json` in home directory

#### Config Interpolation

Use variables in `mcp.json`:

**Supported syntax:**
- `${env:NAME}` - Environment variables
- `${userHome}` - Home folder path
- `${workspaceFolder}` - Project root
- `${workspaceFolderBasename}` - Project name
- `${pathSeparator}` or `${/}` - OS path separator

**Example:**

```json
{
  "mcpServers": {
    "local-server": {
      "command": "python",
      "args": ["${workspaceFolder}/tools/mcp_server.py"],
      "env": {
        "API_KEY": "${env:API_KEY}"
      }
    }
  }
}
```

### Using MCP in Chat

Agent automatically uses MCP tools when relevant (including Plan Mode).

#### Toggling Tools

Click tool names in the tools list to enable/disable them. Disabled tools won't be loaded.

#### Tool Approval

Agent asks for approval before using MCP tools by default. Click the arrow to see arguments.

**Auto-run:** Enable in settings for Agent to use tools without asking.

#### Images as Context

MCP servers can return images (screenshots, diagrams) as base64:

```javascript
const RED_CIRCLE_BASE64 = "/9j/4AAQSkZJRgABAgEASABIAAD/2w...";

server.tool("generate_image", async (params) => {
  return {
    content: [
      {
        type: "image",
        data: RED_CIRCLE_BASE64,
        mimeType: "image/jpeg",
      },
    ],
  };
});
```

Cursor attaches returned images to chat for model analysis.

### Security Considerations

When installing MCP servers:

- ✅ **Verify the source** - Only install from trusted developers/repositories
- ✅ **Review permissions** - Check what data/APIs the server accesses
- ✅ **Limit API keys** - Use restricted keys with minimal permissions
- ✅ **Audit code** - Review source for critical integrations
- ✅ **Use environment variables** - Never hardcode secrets
- ✅ **Run locally when possible** - Use `stdio` transport for sensitive data
- ✅ **Isolate environments** - Consider running servers in containers

MCP servers can access external services and execute code. Always understand what a server does before installation.

---

## Best Practices

### General Principles

1. **Start simple, iterate based on patterns**
   - Don't over-engineer before understanding your needs
   - Add configurations when you see repeated issues
   - Let pain points guide what to automate

2. **Use version control**
   - Check `.cursor/` directory into git
   - Share configurations with your team
   - Document why configurations exist

3. **Keep it focused**
   - Each rule/skill/subagent should have one clear purpose
   - Avoid creating "does everything" configurations
   - Split complex logic into composable pieces

4. **Write for humans first**
   - Clear descriptions help both AI and teammates
   - Include examples and context
   - Document edge cases and limitations

### When to Choose What

#### Rules vs AGENTS.md

**Use Project Rules when:**
- You need file-specific scoping (globs)
- Want intelligent application based on relevance
- Have multiple distinct rule sets
- Need manual invocation with @-mentions

**Use AGENTS.md when:**
- Project is simple with straightforward instructions
- You want a single, readable file
- No need for complex scoping or metadata
- Team prefers simplicity over flexibility

#### Commands vs Skills

**Use Commands when:**
- Workflow is single-purpose
- No scripts need to be executed
- Quick, repeatable action
- Human in the loop

**Use Skills when:**
- Task requires executable scripts
- Need portable capability across projects
- Domain-specific expertise is involved
- Want progressive resource loading

#### Skills vs Subagents

**Use Skills when:**
- Task is single-purpose (generate changelog, format code)
- Completes in one shot
- Don't need separate context window
- Want quick, repeatable action

**Use Subagents when:**
- Need context isolation for long research
- Running multiple workstreams in parallel
- Task requires specialized expertise across many steps
- Want independent verification of work

### Documentation Best Practices

**In Rules:**
- Reference files instead of copying code
- Keep under 500 lines
- Provide concrete examples
- Update when Agent makes mistakes

**In Skills:**
- Move detailed docs to `references/` folder
- Keep SKILL.md focused on instructions
- Make scripts self-contained with error messages

**In Subagents:**
- Invest time in descriptions (determines delegation)
- Keep prompts concise and direct
- Include "use proactively" or "always use for" to encourage auto-delegation

### Team Collaboration

1. **Document decisions** - Explain why rules/configs exist
2. **Use Team Rules** for organizational standards
3. **Check project configs into git**
4. **Create onboarding commands** for new team members
5. **Regular review** - Remove outdated configurations

### Cost and Performance

**To optimize:**
- Use faster models for subagents when appropriate (`model: fast`)
- Disable unused MCP tools
- Keep rule files under 500 lines
- Use context isolation (subagents) only when needed
- Leverage parallel execution for independent tasks

---

## FAQ

### General

**Q: Where should AGENTS.md be placed?**  
A: In your project root. You can also use nested AGENTS.md files in subdirectories (e.g., `frontend/AGENTS.md`, `backend/AGENTS.md`).

**Q: What's the difference between User Rules, Project Rules, and Team Rules?**  
A: **User Rules** are personal preferences across all projects. **Project Rules** are codebase-specific in `.cursor/rules/`. **Team Rules** are organization-wide, managed from the dashboard.

**Q: What's the precedence when rules conflict?**  
A: Team Rules → Project Rules → User Rules (earlier takes precedence).

**Q: Can I use multiple configuration types together?**  
A: Yes! They're complementary. Use User Rules for personal preferences, Project Rules for codebase specifics, Commands for workflows, Skills for executable capabilities, and Subagents for complex delegation.

### Rules

**Q: Should I use .md or .mdc for rules?**  
A: Use `.md` for simple rules. Use `.mdc` when you need frontmatter (description, globs, alwaysApply).

**Q: How do I make a rule apply only to specific files?**  
A: Use `.mdc` format with frontmatter and set `globs`:

```yaml
---
globs:
  - "src/**/*.tsx"
---
```

**Q: What's the difference between "Always Apply" and "Apply Intelligently"?**  
A: "Always Apply" (`alwaysApply: true`) includes the rule in every chat. "Apply Intelligently" (`alwaysApply: false`) lets Agent decide based on the `description` field.

**Q: Can I import rules from GitHub?**  
A: Yes! Go to Cursor Settings → Rules → Add Rule → Remote Rule (Github), then paste the repository URL.

### Commands

**Q: What's the difference between commands and slash commands?**  
A: They're the same thing. Commands are triggered with `/` prefix in chat.

**Q: Can I pass parameters to commands?**  
A: Yes, anything after the command name is included as context:  
`/commit and address DX-523`

**Q: Can commands execute code?**  
A: Commands are instructions for Agent. For executable code, use Skills (which can include scripts).

### Skills

**Q: What's the difference between Skills and Rules?**  
A: Skills are portable, executable packages that can include scripts. Rules are instructions without executable components. Skills follow the Agent Skills open standard.

**Q: Can skills include Python scripts?**  
A: Yes! Skills can include scripts in any language (Bash, Python, JavaScript, etc.).

**Q: How do I migrate existing rules to skills?**  
A: Use the `/migrate-to-skills` command in Cursor 2.4+.

**Q: What does `disable-model-invocation: true` do?**  
A: Makes the skill behave like a slash command - only invoked when you explicitly type `/skill-name`.

### Subagents

**Q: What are the built-in subagents?**  
A: **Explore** (codebase search), **Bash** (shell commands), **Browser** (web interaction via MCP).

**Q: Can subagents launch other subagents?**  
A: Yes, subagents can delegate to other subagents.

**Q: How do I see what a subagent is doing?**  
A: Foreground subagents show their progress in chat. Background subagents work independently.

**Q: What happens if a subagent fails?**  
A: The error is returned to the parent agent, which can retry or handle it differently.

**Q: Can I use MCP tools in subagents?**  
A: Yes, subagents have access to the same tools as the main agent.

**Q: How do I debug a misbehaving subagent?**  
A: Review the subagent's prompt and description. Check that the configuration fields are correct. Test with explicit invocation.

**Q: Why can't I use subagents on my plan?**  
A: On legacy request-based plans, you must enable **Max Mode**. Usage-based plans have subagents enabled by default.

**Q: Should I create many subagents?**  
A: No. Start with 2-3 focused subagents. Too many makes it hard for Agent to decide when to delegate.

### MCP

**Q: What's the point of MCP servers?**  
A: MCP connects Cursor to external tools and data sources (APIs, databases, web services) so Agent can work with your actual systems instead of just describing them.

**Q: How do I debug MCP server issues?**  
A: Check Cursor's logs, verify environment variables are set correctly, ensure the command/URL is accessible, and test the server independently.

**Q: Can I temporarily disable an MCP server?**  
A: Yes, click the tool name in the chat tools list to toggle it off.

**Q: What happens if an MCP server crashes or times out?**  
A: Agent receives an error and can retry or proceed without that tool.

**Q: How do I update an MCP server?**  
A: For `stdio` servers with `npx`, the `-y` flag auto-updates. For local scripts, update the code. For remote servers, deploy new version.

**Q: Can I use MCP servers with sensitive data?**  
A: Yes, but follow best practices: use environment variables, run locally with `stdio` transport, limit API permissions, review server code, and consider isolated environments.

---

## Additional Resources

- [Cursor Documentation](https://cursor.com/docs)
- [Model Context Protocol](https://modelcontextprotocol.io)
- [Agent Skills Specification](https://github.com/anthropics/agent-skills)
- [MCP Server Directory](https://cursor.com/docs/context/mcp/directory)
- [Community Rules Collections](https://github.com/topics/cursor-rules)

---

**Maintained by:** Angus  
**Repository:** [my-cursor](https://github.com/yourusername/my-cursor)  
**Last Updated:** January 25, 2026
