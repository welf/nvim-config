return {
  "mhanberg/output-panel.nvim",
  event = "VeryLazy",
  config = function()
    require("output_panel").setup({
      max_buffer_size = 5000, -- default
    })
  end,
  cmd = { "OutputPanel" },
}
