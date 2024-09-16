return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  opts = {},
  config = function()
    -- Disable regular diagnostic virtual_text since it's redundant due to lsp_lines.
    vim.diagnostic.config({
      virtual_text = false,
    })
    require("lsp_lines").setup()
  end,
}
