---@type LazySpec
-- ============================================================================
-- EDITOR BEHAVIOR  --  plugin-level tweaks that don't fit elsewhere
-- ============================================================================
-- Most editor options (vim.opt.*) belong in `astrocore.lua`. This file is for
-- plugin-level behavior switches.
return {
  -- disable AstroNvim's bundled better-escape (jj/jk to leave insert mode)
  { "max397574/better-escape.nvim", enabled = false },
}