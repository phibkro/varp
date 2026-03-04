---
name: evaluate-optimize-loop
description: Use when output can't be validated by tests or lint alone — prompt engineering, skill design, documentation, system prompts, API contracts. Triggers on "review and fix loop", "evaluate until clean", "optimize until no issues", "review cycle", "iterate until passing", "quality gate".
---

# Evaluate-Optimize Loop

Builder produces work. Reviewer evaluates against criteria. Builder fixes. Repeat until clean.

Uses havn's `builder` and `reviewer` agents.

## Procedure

### 1. Builder completes work

Dispatch a `builder` agent with `run_in_background: true` and `isolation: "worktree"`. The builder reads project memory, implements the task, and updates memory with stable patterns discovered.

If a builder already completed work (you have its agent ID), skip to step 2.

### 2. Dispatch reviewer

Dispatch a `reviewer` agent with `run_in_background: true`. The reviewer prompt MUST contain:

- **The spec to review against** — URL to fetch, file to read, or inline criteria. The reviewer fetches specs from source — never relies on training data.
- **The files to review** — absolute paths the builder wrote/modified.
- **Review criteria** — what specifically to evaluate (design compliance, prompt quality, structural correctness, etc.).

The reviewer outputs structured findings. Instruct the reviewer to end with PASS or FAIL verdict.

```
Review these files against [spec]:
- [absolute/path/to/file1]
- [absolute/path/to/file2]
- Fetch [spec URL] for current requirements

Criteria:
- [specific criterion 1]
- [specific criterion 2]
```

### 3. Parse verdict

- **PASS** → done. Report to user.
- **FAIL** → resume the builder with review findings.

### 4. Resume builder with findings

Resume the original builder agent (not a fresh one — it has context and project memory from the first pass). Inject the reviewer's findings verbatim. The builder fixes issues, reports what changed, and updates project memory.

### 5. Resume reviewer with changes

Resume the reviewer agent (not a fresh one — it remembers prior findings). Tell it which files changed. It re-checks previously-failing criteria plus any new issues introduced by fixes.

### 6. Repeat or stop

- **PASS** → done.
- **FAIL after 3 iterations** → stop. Surface remaining issues to the user with the reviewer's analysis. Diminishing returns past 3 rounds — remaining issues likely need human judgment.

## When NOT to loop

- Reviewer finds architectural issues (wrong approach, not wrong execution) → don't resume builder. Reframe the task or escalate to the user.
- Builder and reviewer disagree on the spec → surface the disagreement to the user. Don't let agents argue.
