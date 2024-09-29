return {
  "tpope/vim-repeat",
  config = function()
    vim.cmd([[
      runtime macros/repeat.vim
    ]])
  end,
}
