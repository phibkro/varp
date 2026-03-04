---
name: refactor
description: |
  Use when restructuring, renaming, extracting, or reorganizing existing code without changing external behavior. Triggers on "refactor", "restructure", "extract", "clean up", "simplify".
---

# Refactor

Transform structure with behavior locked. Tests are the safety net — if they do not exist, write them first.

## Procedure

### 1. Verify baseline

Run the test suite. All tests must pass before starting. If tests do not exist for the code being refactored, write them first using the add-test-coverage skill.

Record baseline: test count, pass count, assertion count.

### 2. Transform

Make one structural change at a time. Run tests after each change. If tests break, the change altered behavior — revert and decompose further.

Common transforms:
- Extract function or module
- Rename for clarity
- Inline unnecessary abstraction
- Move to more appropriate location
- Simplify conditional logic

### 3. Verify no behavior change

Run the full test suite. Compare to baseline recorded in step 1. Same test count, same pass count. If a test was deleted or modified, that is a behavior change — justify it explicitly.

## Running Tests

- Environment errors before code errors — check sandbox, deps, and cwd first
- Sandbox blocks tests needing file writes, network, or env vars — disable when needed
- Compare test counts and failures against baseline

## Red Flags

- Tests broke after a change — revert, do not fix the test
- Adding new behavior during refactor — split into a separate task
- Changing test assertions to match new output — that is a behavior change
- No tests exist for this code — write coverage first
