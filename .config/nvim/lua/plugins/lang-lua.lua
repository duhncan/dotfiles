---@type LazySpec
-- ============================================================================
-- LUA
-- ============================================================================
-- Community pack provides:
--   * lua_ls (LSP, hints enabled)
--   * treesitter: lua, luap
--   * mason tools: lua-language-server, stylua, selene (not on aarch64)
--   * conform: stylua
--   * nvim-lint: selene (auto-detected via selene.toml)
return {
  { import = "astrocommunity.pack.lua" },
}