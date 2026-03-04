---
name: verify-suite
description: |
  This skill should be used when the user asks to "run the test suite", "verify tests pass", "compare test results to baseline", "run lint and tests", "check for regressions", or after completing implementation work that needs test/lint verification.
---

# Quality Assurance

Run tests, lint, and static analysis. Compare results to baseline. Report only — never fix.

## Procedure

### 1. Discover commands

Check project CLAUDE.md or `docs/overview.md` for test, lint, and static analysis commands. If not found, inspect `package.json`, `Cargo.toml`, `pyproject.toml`, or `composer.json` for standard scripts.

If no test command can be found, stop and report BLOCKED.

### 2. Run tests

Execute the discovered test command. Check project CLAUDE.md for test-specific constraints (sandbox requirements, memory limits). Wait for full results — suites may take several minutes.

### 3. Compare to baseline

Read project MEMORY.md for test baseline (test count, assertion count, expected failures). Compare current results against baseline values. Flag regressions and improvements.

### 4. Code style (if requested)

Run the discovered lint/format command.

### 5. Static analysis (if requested)

Run the discovered static analysis command.

## Constraints

- Report only — do not fix code or commit anything.
- Use the project's preferred commands, not generic defaults.

## Reporting

Report results with a verdict:

- **COMPLETE** — all tests pass, no regressions
- **PARTIAL** — test failures or regressions from baseline
- **BLOCKED** — environment issues prevent execution

Include test counts, failure details, and baseline comparison.
