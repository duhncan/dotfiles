---@type LazySpec
-- ============================================================================
-- NAVIGATION & SEARCH
-- ============================================================================
-- AstroNvim v6 provides its pickers through snacks.nvim (`<Leader>f` finds
-- files, words, buffers, etc. -- see the default `<Leader>f` which-key menu).
-- The options below are merged into that existing snacks setup.
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- reorder results with the most recently used files first
        matcher = { frecency = true, cwd_bonus = true },
        -- favorites & more can go here, e.g.:
        -- files = { hidden = false },
        -- layout = { preset = "ivy" },
      },
    },
  },
}