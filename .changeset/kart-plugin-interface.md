---
"@vevx/kart": minor
---

Add plugin interface for multi-language support (ADR-007). Split TypeScript-hardcoded LSP and AST code into `LspPlugin` and `AstPlugin` interfaces with a `PluginRegistry` that routes by file extension. Adds `LspRuntimes` service for lazy per-language runtime management and `PluginUnavailableError` for structured error responses on unsupported extensions.
