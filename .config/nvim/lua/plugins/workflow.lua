---@type LazySpec
-- ============================================================================
-- WORKFLOW  --  git / terminal / projects / sessions
-- ============================================================================
-- AstroNvim already wires up the core workflow surface, so these files only
-- *extend* it:
--   * terminal   -> toggleterm.nvim   (`<Leader>tf` float, `<F7>`/`<C-'>` toggle)
--   * sessions   -> resession.nvim    (`<Leader>S` menu: save/load/delete)
--   * projects   -> snacks.picker     (`<Leader>fp` find projects)
--   * git        -> snacks.picker     (`<Leader>g` menu incl. status/log/browse)
--
-- Below we add a full git UI (Neogit) on top of the snack pickers.
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      graph_style = "unicode",
      integrations = { diffview = true },
      disable_builtin_notifications = true,
    },
    -- open it with `<Leader>gG` (avoids AstroNvim's existing `<Leader>g*` git bindings)
    keys = {
      { "<Leader>gG", "<Cmd>Neogit<CR>", desc = "Neogit status" },
      { "<Leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview" },
    },
  },
}