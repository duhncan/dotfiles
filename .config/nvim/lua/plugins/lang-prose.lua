---@type LazySpec
-- ============================================================================
-- PROSE / MARKDOWN / DOCUMENTATION
-- ============================================================================
-- Community pack provides:
--   * marksman (LSP for markdown)
--   * treesitter: markdown, markdown_inline
--   * mason tools: marksman
return {
  { import = "astrocommunity.pack.markdown" },

  -- markview.nvim: render/read markdown in-buffer (Obsidian-style conceal).
  -- Lazy-loads on markdown filetypes; in normal mode headings are
  -- "collapsed" onto one line for a cleaner read.
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  -- optional: additional prose linters / formatters
  -- { "norcalli/nvim-colorizer.lua", ft = "css", opts = {} },
}