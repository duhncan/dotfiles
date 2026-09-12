---@type LazySpec
-- ============================================================================
-- MAPPINGS  --  everything shortcut-related lives here
-- ============================================================================
-- This is the single home for custom keymaps. Lazy merges these specs with the
-- `astrocore.lua` / `astrolsp.lua` files so nothing here conflicts with the
-- base configuration options.
--
-- To add a shortcut: put it under the right mode inside the matching spec below.
--   * general editor shortcuts    -> the "AstroNvim/astrocore" spec
--   * LSP-only shortcuts          -> the "AstroNvim/astrolsp" spec
--
-- Mapping format: `{ lhs } = { rhs, desc = "…" }`
--   `rhs` can be a string (Ex command), a Lua function, or `false` to disable a
--   default mapping. Tables with only a `desc` key name a which-key group.
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- navigate buffer tabs
          ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          -- mappings seen under group name "Buffer"
          ["<Leader>bd"] = {
            function()
              require("astroui.status.heirline").buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Close buffer from tabline",
          },

          -- tables with just a `desc` key register a which-key menu name
          -- ["<Leader>b"] = { desc = "Buffers" },

          -- setting a mapping to false will disable it
          -- ["<C-S>"] = false,
        },
        -- t = {
        --   ["<C-w>"] = { "<Cmd>vertical terminal<CR>", desc = "Vertical terminal" },
        -- },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- a `cond` key can be a server capability string or a function(client, bufnr)
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
              return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
            end,
          },
        },
      },
    },
  },
}