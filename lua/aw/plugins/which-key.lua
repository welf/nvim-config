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
      { "<leader>s", group = "Search" },
      { "<leader>q", group = "Sessions", icon = { icon = "⚙️ ", hl = "Constant" } },
      { "<leader>c", group = "LSP [c]ode actions", icon = { icon = "🔧 ", hl = "Constant" } },
      { "<leader>h", group = "Git [h]unk", mode = { "n", "v" } },
      { "<leader>g", group = "Git Actions", mode = { "n", "v" } },
      { "<leader>i", group = "Inspect Abstract Syntax Tree", icon = { icon = "🌴 ", hl = "Constant" } },
      { "<leader>m", group = "Marks" },
      { "<leader>o", group = "Open", icon = { icon = "📂 ", hl = "Constant" } },
      { "<leader>d", group = "Debugger", icon = { icon = "🐞 ", hl = "Constant" } },
      { "<leader>t", group = "Toggle" },
      { "<leader>D", group = "Database", icon = { icon = " ", hl = "Constant" } },
      { "<leader>V", group = "View information", icon = { icon = "👁 ", hl = "Constant" } },
      { "<leader>C", group = "Claude AI", icon = { icon = "🧠 ", hl = "Constant" }, mode = { "n", "v" } },
      { "<leader>A", group = "AI Code Companion", icon = { icon = "🧠 ", hl = "Constant" }, mode = { "n", "v" } },
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
