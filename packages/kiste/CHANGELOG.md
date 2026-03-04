# @vevx/kiste

## 0.3.0

### Minor Changes

- 993e89b: Add `kiste_get_cochange` MCP tool for behavioral coupling queries (co-changing files ranked by frequency with jaccard similarity) and snapshot support for resilient indexing (create/restore via CLI, auto-trigger at configured frequency).
- 55e8de5: Add shared Zod schema contract (ArtifactRow, ArtifactCommitRow, CoChangeRow) for cross-package query validation
- ed672f1: Add `kiste_tag` write tool for manual artifact tagging and expand default stop_tags to filter noisy directories

### Patch Changes

- ff8df79: Add coverage reporting infrastructure (strict + integration test tiers)
- 79ea04f: Update package descriptions to reflect vevx agent toolkit framing
- 6a11175: Compact MCP tool responses to reduce agent context window usage. `get_artifact` caps commits to 5 most recent with total count, `search` and `get_provenance` drop unused `conv_type`/`conv_scope` fields, `list_artifacts` drops internal `id` field, and `get_provenance` drops redundant echoed path and count.
- 8fd4a4a: Fix issues found during CodeRabbit review across all packages.

  **kart:** Fix FiberFailure unwrapping in `isPluginUnavailable`, fix stale registry reference in `makeLspRuntimes`, extract `registerLspTool` helper reducing ~224 lines of boilerplate.

  **kiste:** Fix transaction rollback using Effect error channel, fix snapshot sort by mtime instead of SHA, replace `as unknown as` casts with `sql.unsafe<T>()` generics, fix version string to 0.2.0.

  **varp:** Deep-freeze cached manifests to prevent cache poisoning, remove broken Stop prompt hook and obsolete SubagentStart hook, consolidate subagent-conventions into CLAUDE.md.

## 0.2.0

### Minor Changes

- 0f02122: Add Claude Code plugin: MCP server registration, 3 skills (index, query, context), 2 hooks (session-start auto-index, post-commit incremental index), marketplace listing, and README.

### Patch Changes

- a9be6f0: Security and performance hardening: sanitize FTS5 MATCH input to prevent query injection, validate git ref/path inputs against shell metacharacters and path traversal, wrap bulk indexing in transactions, add index on artifact_commits.commit_sha for join performance, and return structuredContent in MCP responses.
