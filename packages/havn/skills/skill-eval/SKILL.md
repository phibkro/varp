---
name: skill-eval
description: Use when testing whether a skill produces useful output, evaluating skill prompt quality, dry-running a skill with an unbiased agent, or validating that skill instructions are clear enough for a naive executor.
---

# /havn:skill-eval

Test whether a skill produces useful output when executed by an unbiased agent. The main agent acts as evaluator; a spawned mock orchestrator executes the skill from scratch.

The loop optimizes the **skill text**, not the output. Each iteration tests whether a naive executor produces good results from the skill instructions alone.

## Procedure

### 1. Prep

Create a temp directory for the test run:

```
/tmp/claude/skill-eval-<skill-name>/
```

Read the skill file to understand what it instructs.

### 2. Dispatch mock orchestrator

Spawn a `general-purpose` agent with `run_in_background: true`. The prompt must contain:

- The absolute path to the skill file to read
- Instruction to execute only the scoping and dispatch-planning steps — NOT the actual dispatch
- Instruction to write planned subagent prompts to `/tmp/claude/skill-eval-<name>/prompts.json`

Format for prompts.json:

```json
[
  {"id": "a", "description": "short label", "subagent_type": "Explore", "prompt": "full prompt text"},
  {"id": "b", "description": "short label", "subagent_type": "Explore", "prompt": "full prompt text"}
]
```

The mock orchestrator scopes the codebase and plans subagent prompts exactly as the skill instructs — but does not dispatch them (subagents cannot spawn subagents).

### 3. Dispatch subagents

Read `/tmp/claude/skill-eval-<name>/prompts.json`. For each entry, dispatch an agent with the specified `subagent_type` using `run_in_background: true`. Make all calls in a single response.

Do not edit the prompts. Dispatch them verbatim — the test measures the skill's prompt quality, not yours.

Record the mapping of prompt IDs to agent task IDs.

### 4. Collect results

When all subagents complete, write each result to `/tmp/claude/skill-eval-<name>/<id>.md`.

### 5. Resume mock orchestrator for synthesis

Resume the mock orchestrator agent. Tell it:

- The skill file path (to re-read the synthesis instructions)
- The result file paths (`/tmp/claude/skill-eval-<name>/<id>.md`)
- Instruction to execute the remaining skill steps (synthesize, gaps)
- Instruction to write final output to `/tmp/claude/skill-eval-<name>/output.md`

### 6. Evaluate

Read `/tmp/claude/skill-eval-<name>/output.md`. Evaluate against the skill's own success criteria, plus:

- Did the mock orchestrator follow the skill instructions, or improvise?
- Were the subagent prompts well-scoped with output contracts?
- Is the output the right level of detail (not too sparse, not bloated)?
- Does the output avoid duplicating always-loaded context (CLAUDE.md)?

### 7. Fix or pass

If the output is good, the skill is working. Report findings.

If the output has issues, identify whether the problem is in:
- **Skill text** (instructions unclear, missing constraint) — fix the skill, re-run from step 2
- **Skill structure** (wrong step ordering, missing step) — fix the skill, re-run from step 2
- **One-off agent behavior** (agent ignored clear instructions) — re-run once without fixing to confirm

Stop after 3 iterations. Surface remaining issues to the user.
