---@type LazySpec
-- ============================================================================
-- FORMAT & LINT (none-ls / null-ls)
-- ============================================================================
-- AstroNvim v6 uses conform.nvim for format-on-save (see astrolsp.lua) and
-- nvim-lint for diagnostics where configured by language packs. This file
-- adds *extra* none-ls / null-ls sources when needed -- for instance a
-- linter not covered by nvim-lint or a formatter with no conform entry.
--
-- Useful references:
--   formatters   -> https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
--   diagnostics  -> https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- Only insert new sources; use opts.sources = { ... } to replace everything.
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- null_ls.builtins.formatting.prettier,
      -- null_ls.builtins.formatting.ruff,
      -- null_ls.builtins.diagnostics.markdownlint,
    })
  end,
}