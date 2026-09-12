---@type LazySpec
-- ============================================================================
-- COMPLETION & SNIPPETS
-- ============================================================================
-- AstroNvim v6 uses blink.cmp as its completion engine. Options defined here
-- are merged on top of AstroNvim's own blink defaults (table opts deep-merge).
return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- extend/replace the providers used for completions
        -- default: { "lsp", "path", "snippets", "buffer" }
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        menu = {
          max_height = 12,
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true }, -- inline preview of the current selection
      },
      -- uncomment to tweak the confirmation/cycling keys
      -- keymap = {
      --   ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      -- },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      -- extend luasnip per-filetype (see :h luasnip-filetype_extend)
      -- require("luasnip").filetype_extend("javascript", { "javascriptreact" })

      -- include the default astronvim config that calls the setup call
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(cond.not_before_regex("xxx", 3))
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it works for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
}