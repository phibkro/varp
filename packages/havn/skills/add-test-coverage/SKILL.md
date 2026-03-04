---
name: add-test-coverage
description: |
  Use when adding tests to existing untested code, improving coverage for a module, or backfilling test gaps before a refactor. Triggers on "add tests", "improve coverage", "write tests for", "backfill tests".
---

# Add Test Coverage

Test existing contracts. Focus on what the code does for consumers, not how it works internally.

## Procedure

### 1. Identify untested contracts

Read the module's public interface: exports, function signatures, return types. These are the contracts to test. Skip internal helpers unless they encode critical business logic.

### 2. Write tests for behavior

For each contract:
- What does a consumer expect when calling with valid input?
- What happens with edge cases (empty, null, boundary values)?
- What error conditions exist?

Name each test by the behavior it verifies, not the function it calls.

### 3. Verify coverage delta

Run tests with coverage using the project's coverage command (check project CLAUDE.md). Compare per-file coverage before and after. Every new test should increase coverage for the target module.

## Running Tests

- Environment errors before code errors — check sandbox, deps, and cwd first
- Sandbox blocks tests needing file writes, network, or env vars — disable when needed
- Compare test counts and failures against baseline

## Red Flags

- Testing implementation (mocking internals) instead of contracts
- Test would break if internals were refactored
- Cannot name the specific regression this test catches
- No one would notice if this test were deleted
- Testing type checks or instanceof assertions — the compiler handles these
- Testing framework behavior instead of your code
- Testing trivial getters and setters with no logic
