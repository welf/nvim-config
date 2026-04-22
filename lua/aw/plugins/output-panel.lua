return {
  "mhanberg/output-panel.nvim",
  enabled = false, -- Disabled due to coroutine error in Neovim 0.11
  event = "VeryLazy",
  config = function()
    require("output_panel").setup({
      max_buffer_size = 5000, -- default
    })
  end,
  cmd = { "OutputPanel" },
}
