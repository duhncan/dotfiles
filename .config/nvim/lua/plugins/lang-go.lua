---@type LazySpec
-- ============================================================================
-- GO
-- ============================================================================
-- Community pack provides:
--   * gopls  (LSP, gofumpt formatting, codelenses, staticcheck, …)
--   * treesitter: go, gomod, gosum, gowork
--   * mason tools: delve, gopls, gomodifytags, gotests, iferr, impl, goimports
--   * nvim-dap-go (DAP), gopher.nvim, neotest-golang
--   * conform: goimports, gopls fallback
return {
  { import = "astrocommunity.pack.go" },

  -- extra conform overrides for Go (if you prefer gofumpt over goimports)
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = { formatters_by_ft = { go = { "gofumpt", lsp_format = "last" } } },
  -- },
}