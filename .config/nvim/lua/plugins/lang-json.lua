---@type LazySpec
-- ============================================================================
-- JSON
-- ============================================================================
-- Community pack provides:
--   * jsonls (LSP; validates against JSON schemas via SchemaStore)
--   * schemastore.nvim (auto-completes `$schema` refs)
--   * treesitter: json, jsonc
--   * mason tools: json-lsp
--
-- NOTE: jsonls formats via the LSP itself, so format-on-save works out of
-- the box (see astrolsp.lua for the global format_on_save settings).
return {
  { import = "astrocommunity.pack.json" },
}