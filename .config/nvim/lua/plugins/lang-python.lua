---@type LazySpec
-- ============================================================================
-- PYTHON
-- ============================================================================
-- Community pack provides:
--   * basedpyright (LSP, fork of pyright with extra checks)
--   * treesitter: python
--   * mason tools: python-lsp-server, debugpy, isort, black, ruff
--   * conform: black, isort, ruff, ruff_fix
--   * nvim-lint: ruff, ruff_format, mypy, pylint
return {
  { import = "astrocommunity.pack.python" },
}