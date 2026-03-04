# @vevx/havn

Default Claude Code plugin setup. A stable harbor for AI agents setting sail on new projects.

## What it provides

- **Agents** -- builder (implementation + RGR TDD), reviewer (PASS/FAIL verdicts), context-expert (CLAUDE.md/MEMORY.md compression)
- **Skills** -- development procedures (implement-feature, fix-bug, refactor, add-test-coverage), orchestration (execute-plan, evaluate-optimize-loop, verify-suite), authoring (prompt-writing, explore-codebase, skill-eval)
- **Git hook management** -- SessionStart hook auto-installs a pre-commit hook (format, lint, build, test, changeset verification)
- **Plugin auto-detection** -- SessionEnd hook enables Claude Code plugins based on project dependencies (Effect TS, React/Next.js, plugin-dev)
- **Memory extraction** -- PreCompact hook extracts session insights to MEMORY.md before context compression

Standalone -- no dependencies on other vevx packages.

## Configuration

Create `.havn.json` in your project root to override pre-commit hook defaults:

```json
{
  "precommit": {
    "format": "turbo format",
    "quality": "turbo lint && turbo build",
    "test": "turbo test",
    "main": "main"
  }
}
```

All fields are optional. Without overrides, the hook auto-detects your runner (turbo > bun > npm) and available package.json scripts. Format and quality checks run on all branches; tests and changeset verification run only on the main branch.

## Plugin assets

### Agents

| Agent | Purpose | Memory | Skills |
|-------|---------|--------|--------|
| `builder` | Implementation with RGR TDD | project | implement-feature, fix-bug, refactor, add-test-coverage, verify-suite |
| `reviewer` | Structured PASS/FAIL review | project | implement-feature, fix-bug, refactor, add-test-coverage, prompt-writing, superpowers:writing-skills |
| `context-expert` | CLAUDE.md/MEMORY.md compression | -- | -- |

### Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `implement-feature` | Procedure | RGR TDD: discover context, red, green, refactor |
| `fix-bug` | Procedure | Reproduce, regression test, minimal fix, verify |
| `refactor` | Procedure | Behavior-locked restructuring with baseline verification |
| `add-test-coverage` | Procedure | Contract-first test backfilling |
| `execute-plan` | Orchestration | Sequential task execution with builder + evaluate-optimize-loop |
| `evaluate-optimize-loop` | Orchestration | Builder/reviewer iteration until PASS (max 3 rounds) |
| `verify-suite` | Orchestration | Mechanical test/lint/analysis runner |
| `explore-codebase` | Authoring | Parallel Explore subagents, synthesized overview |
| `prompt-writing` | Authoring | Guidelines for writing agent-controlling text |
| `skill-eval` | Authoring | Dry-run skill with unbiased agent |

### Hooks

| Path | Event | Purpose |
|------|-------|---------|
| `hooks/install-hooks.sh` | SessionStart | Installs pre-commit hook, sets `core.hooksPath` |
| `hooks/sync-plugins.sh` | SessionEnd | Detects deps, enables matching plugins in `settings.local.json` |
| `hooks/hooks.json:PreCompact` | PreCompact | Extracts session insights to MEMORY.md |
| `hooks/pre-commit.sh` | Git hook | Format + lint + build (all branches), test + changeset (main only) |

### Templates

| Path | Purpose |
|------|---------|
| `templates/agent.md` | Agent frontmatter reference |
| `templates/SKILL.md` | Skill frontmatter reference |
