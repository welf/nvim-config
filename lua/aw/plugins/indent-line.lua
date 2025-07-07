return {
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = "ibl",
  opts = {
    indent = {
      char = "▏", -- Thinner character
      tab_char = "▏",
    },
    scope = {
      enabled = true,
      char = "▏", -- Thinner character for scope
      show_start = false,
      show_end = false,
    },
  },
}
