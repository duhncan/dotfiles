---@type LazySpec
-- ============================================================================
-- TYPESCRIPT / JAVASCRIPT
-- ============================================================================
-- Community pack provides:
--   * vtsls (LSP, successor to vtsls/tsserver with vtsls completion)
--   * nvim-vtsls   (extra vtsls commands: organize imports, goto source def, …)
--   * treesitter: javascript, typescript, tsx, jsdoc
--   * mason tools: vtsls, js-debug-adapter
--   * nvim-dap (JS/TS debugging), neotest-jest, tsc.nvim (workspace diagnostics)
--   * package-info.nvim (package.json peek)
--   * conform: prettier, eslint (when installed)
--   * lsp-file-operations (auto-import on rename)
return {
  { import = "astrocommunity.pack.typescript" },

  -- tsc.nvim: run workspace type checking with `:TSC`
  -- already included in the pack (cmd = "TSC", opts = {})
}