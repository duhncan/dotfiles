---@type LazySpec
-- ============================================================================
-- CODECOMPANION (AI chat / inline assistant)
-- ============================================================================
-- https://github.com/olimorris/codecompanion.nvim (via astrocommunity pack)
--
-- The pack hardcodes the mapping prefix as <Leader>A; we disable those and
-- re-register the same actions under <leader>9 so the AI tools don't collide
-- with AstroNvim defaults or opencode.nvim (<leader>0).
return {
  { import = "astrocommunity.ai.codecompanion-nvim" },

  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = function(_, opts)
      local icon = require("astroui").get_icon("CodeCompanion", 1, true)
      opts.mappings = opts.mappings or {}
      opts.mappings.n = opts.mappings.n or {}
      opts.mappings.v = opts.mappings.v or {}

      -- remove the pack's default <Leader>A mappings
      local disable = {
        n = { "<Leader>Ac", "<Leader>Ap", "<Leader>Aq" },
        v = { "<Leader>Ac", "<Leader>Ap", "<Leader>Aq", "<Leader>Aa" },
      }
      for mode, keys in pairs(disable) do
        for _, key in ipairs(keys) do
          opts.mappings[mode][key] = false
        end
      end

      -- re-register under <leader>9
      opts.mappings.n["<leader>9"] = { desc = icon .. "CodeCompanion" }
      opts.mappings.v["<leader>9"] = { desc = icon .. "CodeCompanion" }
      opts.mappings.n["<leader>9c"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" }
      opts.mappings.v["<leader>9c"] = { "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" }
      opts.mappings.n["<leader>9p"] = { "<cmd>CodeCompanionActions<cr>", desc = "Open action palette" }
      opts.mappings.v["<leader>9p"] = { "<cmd>CodeCompanionActions<cr>", desc = "Open action palette" }
      opts.mappings.n["<leader>9q"] = { "<cmd>CodeCompanion<cr>", desc = "Open inline assistant" }
      opts.mappings.v["<leader>9q"] = { "<cmd>CodeCompanion<cr>", desc = "Open inline assistant" }
      opts.mappings.v["<leader>9a"] = { "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to chat" }
    end,
  },
}