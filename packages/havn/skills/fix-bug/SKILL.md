---
name: fix-bug
description: |
  Use when fixing a bug, resolving an error, or addressing unexpected behavior. Triggers on "fix", "debug", "broken", "regression", "not working".
---

# Fix Bug

Reproduce, test, fix, verify. The regression test is the deliverable — the fix is secondary.

## Procedure

### 1. Reproduce

Confirm the bug exists. Find or create a minimal reproduction. If it cannot be reproduced, gather more information before proceeding.

### 2. Isolate root cause

Read the code path. Form a hypothesis. Verify with targeted code reading, test instrumentation, or print debugging — do not guess. The fix should target the cause, not the symptom.

### 3. Write a regression test

Write a test that fails with the current buggy code. This test proves the bug exists and prevents reintroduction. Run it — confirm it fails for the right reason.

### 4. Fix minimally

Change the minimum code to make the regression test pass. Do not refactor surrounding code or fix unrelated issues in the same change — scope creep masks regressions.

### 5. Verify suite

Run the full test suite. Compare to baseline in project memory. The fix must not break existing behavior.

## Running Tests

- Environment errors before code errors — check sandbox, deps, and cwd first
- Sandbox blocks tests needing file writes, network, or env vars — disable when needed
- Compare test counts and failures against baseline

## Red Flags

- Fixing without reproducing first
- No regression test — the bug will return
- Fix touches code unrelated to the root cause
- Multiple unrelated changes in one fix — split them
