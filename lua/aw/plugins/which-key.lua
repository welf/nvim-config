return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- icon = { icon = "󰑕 ", hl = "Constant" }
    preset = "helix", -- false | "classic" | "modern" | "helix"
    spec = {
      { "<leader>s", group = "[S]earch", icon = { icon = " ", hl = "Constant" } },
      { "<leader>c", group = "LSP [c]ode actions", icon = { icon = "󰑕 ", hl = "Constant" } },
      { "<leader>h", group = "Git [h]unk", mode = { "n", "v" } },
      { "<leader>i", group = "[I]nspect AST" },
      { "<leader>m", group = "[M]arks" },
      { "<leader>o", group = "[O]pen" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>d", group = "[D]atabase", icon = { icon = " ", hl = "Constant" } },
      { "<leader>V", group = "[V]iew" },
      { "<leader>C", group = "[C]laude AI", icon = { icon = "🤖 ", hl = "Constant" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
