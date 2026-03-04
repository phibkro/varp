---
name: execute-plan
description: |
  Use when a plan with ordered tasks needs sequential execution. Triggers on "execute the plan", "implement this plan", "work through these tasks", "start the implementation".
---

# Execute Plan

Tasks execute sequentially. Each one must pass review before the next starts.

## Procedure

### 1. Extract tasks

Read the plan. Create a task list with full task text, affected files, and dependencies. Note which tasks share files or modules — this informs the resume-vs-fresh decision in step 3.

### 2. Select procedure

Match each task to the appropriate builder skill:
- New functionality → implement-feature
- Bug or regression → fix-bug
- Restructuring → refactor
- Test gaps → add-test-coverage

Include the skill name in the builder's dispatch prompt.

### 3. Dispatch builder

Dispatch a `builder` agent with `run_in_background: true`. Include the full task text, affected files, and the skill name from step 2 in the prompt.

**Resume or fresh?** Does the next task list any of the same file paths or directories as the previous task? If yes, resume. If no, fresh.

| Signal | Resume | Fresh |
|--------|:------:|:-----:|
| Next task touches same files/module | Yes | -- |
| Next task is in a different package or directory tree | -- | Yes |
| Independent tasks that happen to be ordered | -- | Yes |

### 4. Evaluate

The builder from step 3 already completed work. Run evaluate-optimize-loop starting at step 2 (dispatch reviewer) with the builder's agent ID and the task requirements as review criteria. Mark the task complete on PASS.

### 5. Next task

Check remaining tasks. Use the resume-vs-fresh table from step 3 to decide whether to resume the existing builder or dispatch a fresh one. Repeat steps 2–5 until all tasks complete.

### 6. Final verification

Run the verify-suite skill directly (not via builder dispatch). Individual tasks already verified locally — this catches cross-task regressions from interactions between tasks.

## Constraints

- Execute tasks sequentially — parallel builder dispatches cause conflicts
- Do not skip the evaluate step, even for "simple" tasks
- If a task reveals the plan is wrong (wrong approach, not wrong execution), stop and surface to the user. Example: task 3 discovers the data model from task 1 can't support the required query pattern — that's architectural, not a bug to fix in place
