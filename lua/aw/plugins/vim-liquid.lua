return {
  "tpope/vim-liquid",
  event = "FileType",
  ft = "liquid",
  config = function()
    vim.g.liquid_extends = 1
    vim.g.liquid_highlight_error = 1
    vim.g.liquid_indent_tags = 1
    vim.g.liquid_indentation = 2
    vim.g.liquid_syntax = 1
  end,
}
