return {
  "yorickpeterse/nvim-tree-pairs",
  event = "BufReadPre",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("tree-pairs").setup()
  end,
}
