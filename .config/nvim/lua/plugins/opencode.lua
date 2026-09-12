---@type LazySpec
-- ============================================================================
-- OPENCODE (AI coding agent frontend)
-- ============================================================================
-- Test drive: https://github.com/sudo-tee/opencode.nvim
-- Early-development plugin; config centralized here.
--
-- Requires the `opencode` CLI on PATH (already installed).
-- blink.cmp (completion) and snacks.nvim (picker) are already configured
-- elsewhere in lua/plugins/, so only render-markdown.nvim is added below.
--
-- NOTE: render-markdown is scoped to the opencode output buffer only, since
-- in-buffer markdown rendering is already handled by markview.nvim
-- (see lang-prose.lua). This avoids double-rendering markdown buffers.
return {
  {
    "sudo-tee/opencode.nvim",
    event = "VeryLazy",
    config = function()
      require("opencode").setup({
        -- Avoid colliding with AstroNvim's "<leader>o" = Toggle Explorer Focus
        keymap_prefix = "<leader>0",
      })
    end,
    dependencies = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "opencode_output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
  },
}