---@type LazySpec
-- ============================================================================
-- YAML
-- ============================================================================
-- Community pack provides:
--   * yamlls (LSP; schema validation via SchemaStore)
--   * schemastore.nvim
--   * treesitter: yaml
--   * mason tools: yaml-language-server
--
-- NOTE: yamlls formats via the LSP itself (prettier-based), so format-on-save
-- works out of the box (see astrolsp.lua for the global format_on_save settings).
-- All YAML-specific behavior is configured here.
return {
  { import = "astrocommunity.pack.yaml" },

  -- YAML formatting / language preferences (single source of truth for yaml)
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      config = {
        yamlls = {
          settings = {
            yaml = {
              format = {
                singleQuote = true,
                printWidth = 100,
                proseWrap = "always",
              },
              keyOrdering = true,
            },
          },
        },
      },
    },
  },
}