---
name: explore-codebase
description: Use when starting work in an unfamiliar codebase, onboarding to a new project, or needing a structural overview before planning. Triggers on "what does this project do", "understand the codebase", "project overview", "explore the repo".
---

# /havn:explore-codebase

Scope the codebase, then dispatch parallel Explore subagents sized to what you find. Synthesize their findings into a codebase overview.

Priority: accurate structure > actionable conventions > completeness.

## Step 1: Scope

Before dispatching, read the project root to determine codebase shape: `ls`, root `package.json` or equivalent, and any workspace config (turbo.json, pnpm-workspace.yaml, Cargo.toml workspace). Use this to decide how many subagents and what each covers.

Guidelines:
- **Single package**: 2 subagents may suffice (structure+conventions, changes+workflow)
- **Small monorepo (2-5 packages)**: 3-4 subagents — one per concern area
- **Large monorepo (6+ packages)**: Consider one subagent per package cluster plus shared concerns (CI, conventions, recent activity)
- Every dispatch must cover these concerns across the set: **project purpose, structure, dependencies, conventions, recent activity, build/test workflow**. How you partition them across subagents is up to you.

## Step 2: Dispatch

Use the Agent tool with `subagent_type: "Explore"` for each. Make all calls in a single response so they execute concurrently.

Each subagent prompt must include:

1. **Output contract** — the format to return (table rows, bulleted list, etc.)
2. **Black-box constraint** — describe public contracts only (exports, CLI commands, tool APIs, entry points). Internal implementation helps the subagent navigate but must not appear in the output. No algorithm names, no internal function signatures, no implementation details. The goal is an overview, not a codebase dump.

Examples:

- Structure agents: markdown table rows `| name | purpose | key dependencies |`. Purpose = what it does for consumers, not how it works internally.
- Workflow agents: a "Development Workflow" section with exact commands
- Convention agents: bulleted list of conventions that differ from common defaults. Skip anything already in CLAUDE.md — the agent has it as always-loaded context.
- Activity agents: summary of active areas, in-progress work, recent changes

## Step 3: Synthesize

Distill (do not concatenate) all results into this structure:

```
## Codebase Overview
**Project**: <name, one sentence describing the problem it solves>
**Stack**: <language, runtime, key frameworks>
**Layout**: <monorepo/single-package, key directories>

## Packages
| Package | Purpose | Stability | Key Dependencies |
|---------|---------|-----------|-----------------|
<Purpose = what it does for consumers. Stability = version + maturity signal.>

## Data Flow
<How data moves through the system at runtime. What produces, what consumes.
 Only include flows discovered from docs, entry points, or clear from structure.>

## Development Workflow
- **Build**: <command>
- **Test**: <command and conventions>
- **Lint/Format**: <command>
- **CI**: <description or "none detected">

## Key Conventions
<Bulleted, only things NOT already in CLAUDE.md that differ from defaults>

## Active Development
<2-3 sentences on current focus>

## Architecture Notes
<Key design principles and boundaries NOT already in CLAUDE.md.
 Only if discovered from docs or clear from structure.>
```

When subagent findings contradict, include both and flag the contradiction.

## Step 4: Gaps

Note areas where exploration was inconclusive: missing docs, unclear package purposes, untested or stale areas. Present as a short bulleted list.
