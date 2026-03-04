# @vevx/varp

## 0.2.0

### Minor Changes

- 683854b: Enrich `varp_suggest_touches` with behavioral coupling from kiste's co-change index. When `.kiste/index.sqlite` exists, `suggestTouches` now surfaces read dependencies for components that frequently co-change in git history but aren't statically linked via imports. Falls back gracefully when kiste isn't indexed.

### Patch Changes

- ff8df79: Add coverage reporting infrastructure (strict + integration test tiers)
- 79ea04f: Update package descriptions to reflect vevx agent toolkit framing
- 8fd4a4a: Fix issues found during CodeRabbit review across all packages.

  **kart:** Fix FiberFailure unwrapping in `isPluginUnavailable`, fix stale registry reference in `makeLspRuntimes`, extract `registerLspTool` helper reducing ~224 lines of boilerplate.

  **kiste:** Fix transaction rollback using Effect error channel, fix snapshot sort by mtime instead of SHA, replace `as unknown as` casts with `sql.unsafe<T>()` generics, fix version string to 0.2.0.

  **varp:** Deep-freeze cached manifests to prevent cache poisoning, remove broken Stop prompt hook and obsolete SubagentStart hook, consolidate subagent-conventions into CLAUDE.md.

- c291f94: Validate kiste SQLite queries with shared Zod schema contract instead of inline type casts
- 4c7bde1: Compact MCP tool responses to reduce agent context window usage. Freshness reports only list stale docs, manifest returns component summaries, import scans strip per-file evidence, env checks only list missing vars, and co-change analysis returns summary stats instead of raw edges.
- Updated dependencies [ff8df79]
- Updated dependencies [79ea04f]
- Updated dependencies [993e89b]
- Updated dependencies [6a11175]
- Updated dependencies [55e8de5]
- Updated dependencies [ed672f1]
- Updated dependencies [8fd4a4a]
  - @vevx/kiste@0.3.0

## 0.1.1

### Patch Changes

- a9be6f0: Fix MCP tool responses to always return structuredContent, ensuring clients receive typed JSON alongside the text fallback. Fixes outputSchema validation errors for tools with declared output schemas.
