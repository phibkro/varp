import { describe, expect, it } from "bun:test";

import { RustLspPluginImpl, makeRustAstPlugin } from "./RustPlugin.js";

describe("RustLspPluginImpl", () => {
  it("handles .rs extension", () => {
    expect(RustLspPluginImpl.extensions.has(".rs")).toBe(true);
    expect(RustLspPluginImpl.extensions.has(".ts")).toBe(false);
  });

  it("returns rust languageId", () => {
    expect(RustLspPluginImpl.languageId("foo.rs")).toBe("rust");
  });
});

describe("makeRustAstPlugin", () => {
  it("handles .rs extension after init", async () => {
    const plugin = await makeRustAstPlugin();
    expect(plugin.extensions.has(".rs")).toBe(true);
  });

  it("parses Rust symbols", async () => {
    const plugin = await makeRustAstPlugin();
    const symbols = plugin.parseSymbols("pub fn hello() {}", "test.rs");
    expect(symbols.length).toBeGreaterThan(0);
    expect(symbols[0].name).toBe("hello");
  });
});
