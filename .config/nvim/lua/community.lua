---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Per-language community packs are imported in lua/plugins/lang-*.lua
  -- so that each language's LSP/tools/formatters live together in one file.
  --
  -- NOTE: lazy.nvim only loads *.lua files directly under lua/plugins/.
  -- Subdirectories are IGNORED (settings/, langs/ etc. would silently not load).
}