---@type LazySpec
-- ============================================================================
-- THEME  --  catppuccin
-- ============================================================================
-- How to change the theme: edit the `colorscheme` value in the astroui spec
-- below to `catppuccin-<flavour>` where flavour is:
--   "latte" | "frappe" | "macchiato" | "mocha"
--
-- This is the ONLY knob. The catppuccin `flavour` opts has no effect once a
-- concrete `catppuccin-<flavour>` colourscheme is set (the plain `catppuccin`
-- name is unreliable and falls back to mocha, so it is not used).
--
-- lazy.nvim lazy-loads the catppuccin plugin to satisfy the colourscheme name
-- at startup via its ColorSchemePre hook, so the plugin stays `lazy`.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000, -- apply early so the dashboard uses the theme immediately
    opts = {
      term_colors = true, -- sync terminal colors with the palette
      -- integrations are auto-enabled where the plugin is installed; add any
      -- explicit ones you need, e.g.:
      -- integrations = {
      --   aerial = true,
      --   blink_cmp = true,
      --   gitsigns = true,
      --   native_lsp = { enabled = true, underlines = {} },
      --   neo_tree = true,
      --   treesitter = true,
      -- },
    },
  },
  {
    "AstroNvim/astroui",
    opts = {
      -- <flavour> = latte | frappe | macchiato | mocha
      -- colorscheme = "catppuccin-mocha",
      colorscheme = "catppuccin-frappe",
    },
  },
}
