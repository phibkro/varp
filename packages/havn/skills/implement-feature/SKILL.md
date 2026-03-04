---
name: implement-feature
description: |
  Use when implementing a new feature, adding functionality, or building a component from requirements. Triggers on "build", "implement", "create", "add feature".
---

# Implement Feature

Red-Green-Refactor. Write the test first, make it pass, clean up.

## Procedure

### 1. Discover context

Read surrounding code. Identify existing patterns, conventions, and test structure in the component. Check project memory for past learnings.

### 2. Red — write a failing test

Write a test that describes the expected behavior. Run it. Confirm it fails for the right reason (missing implementation, not broken test setup).

Test the contract, not the implementation:
- Name the specific bug or regression this test catches
- Test what it does, not how it does it
- Skip type checks and instanceof assertions — the compiler handles those

### 3. Green — make it pass

Write the minimum code to make the test pass. Match existing patterns in the component. No speculative abstractions — write the concrete version.

### 4. Refactor

Clean up with tests green. Inline unless two other call sites exist. Simplify until a teammate reading cold would understand without explanation.

### 5. Repeat

Return to step 2 for the next behavior. Each cycle adds one testable behavior.

### 6. Verify suite

Run the full test suite. Compare results to baseline in project memory. Check for regressions.

## Running Tests

- Environment errors before code errors — check sandbox, deps, and cwd first
- Sandbox blocks tests needing file writes, network, or env vars — disable when needed
- Compare test counts and failures against baseline

## Red Flags

- Writing implementation before a test exists
- Test passes immediately on first run (not testing anything new)
- "I'll add the test after" — the test shapes the design
- Fixing a test by changing assertions to match wrong output
