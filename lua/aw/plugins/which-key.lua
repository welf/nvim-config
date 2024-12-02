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
      { "<leader>s", group = "[S]earch", icon = { icon = "🔎 ", hl = "Constant" } },
      { "<leader>q", group = "Sessions", icon = { icon = "⚙️ ", hl = "Constant" } },
      { "<leader>c", group = "[C]ode actions", icon = { icon = "🔧 ", hl = "Constant" } },
      { "<leader>e", group = "[E]lixir actions", mode = { "n", "v" }, icon = { icon = "💧 ", hl = "Constant" } },
      { "<leader>g", group = "[G]it Actions", mode = { "n", "v" }, icon = { icon = " ", hl = "Constant" } },
      { "<leader>i", group = "[I]nspect", icon = { icon = "👁 ", hl = "Constant" } },
      { "<leader>m", group = "[M]arks", icon = { icon = "〽️ ", hl = "Constant" } },
      { "<leader>M", group = "[M]ultiCursor", icon = { icon = " ", hl = "Constant" } },
      { "<leader>o", group = "[O]pen", icon = { icon = "📂 ", hl = "Constant" } },
      { "<leader>d", group = "[D]ebugger", icon = { icon = "🐞 ", hl = "Constant" } },
      { "<leader>t", group = "[T]oggle", icon = { icon = "🔘 ", hl = "Constant" } },
      { "<leader>D", group = "[D]atabase", icon = { icon = " ", hl = "Constant" } },
      { "<leader>S", group = "[S]how", icon = { icon = "🔍 ", hl = "Constant" } },
      { "<leader>Sd", group = "[S]how [d]iagnostics", icon = { icon = "🐞 ", hl = "Constant" } },
      { "<leader>a", group = "[A]I Code Companion", icon = { icon = "🧠 ", hl = "Constant" }, mode = { "n", "v" } },
      { "<leader>x", group = "Trouble diagnostic", icon = { icon = "⚠️ ", hl = "Constant" }, mode = { "n", "v" } },
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
