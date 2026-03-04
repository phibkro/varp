# Reviewer Memory

## Recurring Patterns

### Path handling bugs (kart)
- `join(root, path)` when `path` is absolute creates double-rooted paths. Always guard with `isAbsolute()` check first. Found in DeclCache.ts, fixed.
- Test suites that only use relative paths mask absolute-path bugs. Always include absolute path test cases for path-accepting APIs.

### Regex-based parsing gaps (kart/TypeRefs)
- When handling import aliases (`as`), must apply consistently across all import forms (`import type { X as Y }` AND `import { type X as Y }`).
- `.d.ts` parsing via regex is fragile for multi-line constructs. Brace-depth tracking misses braceless multi-line function signatures.

### Extension handling (kart)
- TypeScript resolution must handle `.ts`, `.tsx`, `.js`, `.jsx`, and extensionless specifiers. Easy to miss `.tsx` variants in include patterns, staleness scans, and specifier resolution.

### Skill cross-references (havn)
- When skill A dispatches an agent and then calls skill B which also dispatches an agent, the handoff must specify which step of skill B to enter. Otherwise the agent may re-dispatch redundantly.
- Resume-vs-fresh signals must be objectively checkable from the builder's output (file paths, module names). Subjective signals like "discovered patterns" are not falsifiable.

## Kart Architecture Notes
- `DeclCache` manages `.kart/decls/` via `tsc --declaration`. Key files: `DeclCache.ts`, `TypeRefs.ts` (pure parsing), `Symbols.ts` (service layer consuming both).
- `filterDtsByKind` in Symbols.ts uses line-based regex filtering of `.d.ts` content. Known limitation: multi-line braceless signatures.
- `resolveSpecifierToSource` in Symbols.ts resolves import specifiers to source files with extension mapping.
