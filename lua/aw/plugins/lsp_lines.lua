return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  opts = {},
  config = function()
    vim.diagnostic.config({
      virtual_text = true, -- Enable virtual text diagnostics after the end of each line
      virtual_lines = { only_current_line = true }, -- Extend virtual text to the entire line
    })
    require("lsp_lines").setup()
  end,
}
