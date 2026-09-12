---@type LazySpec
-- ============================================================================
-- RUST
-- ============================================================================
-- Community pack provides:
--   * rustaceanvim (the main Rust plugin, replaces rust-analyzer lspconfig setup)
--     - rust-analyzer itself is managed via `rustup component add rust-analyzer`
--     - cargo integration, inline actions, runnables, expand macro, etc.
--   * crates.nvim  (Cargo.toml helpers, version browsing, completion)
--   * treesitter: rust, toml
--   * mason tools: codelldb (DAP adapter)
--   * neotest-rustaceanvim adapter
return {
  { import = "astrocommunity.pack.rust" },

  -- rust-analyzer settings override (add project-level config in .vscode/settings.json
  -- or a local rust-analyzer.json instead of hardcoding here)
  -- {
  --   "AstroNvim/astrolsp",
  --   optional = true,
  --   opts = { config = {
  --     ["rust-analyzer"] = {
  --       check = { command = "clippy", extraArgs = { "--all-targets", "--no-deps" } },
  --     },
  --   } },
  -- },
}