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
      { "<leader>e", desc = "Toggle NeoTree [e]xplorer", icon = { icon = "🌳 ", hl = "Constant" } },
      { "<leader>E", group = "[E]lixir actions", mode = { "n", "v" }, icon = { icon = "💧 ", hl = "Constant" } },
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
      { "<leader>x", group = "Trouble diagnostic", icon = { icon = "⚠️ ", hl = "Constant" }, mode = { "n", "v" } },

      -- =============================================================================
      -- RUST DEVELOPMENT KEY GROUPS
      -- =============================================================================
      { "<leader>r", group = "[R]ust Development", icon = { icon = "🦀 ", hl = "Constant" } },

      -- Build and compilation
      { "<leader>rb", group = "[B]uild & Compile", icon = { icon = "🔨 ", hl = "Constant" } },

      -- Run operations
      { "<leader>rr", group = "[R]un & Execute", icon = { icon = "▶️ ", hl = "Constant" } },

      -- Testing (extends existing debug group)
      { "<leader>rt", group = "[T]esting & Coverage", icon = { icon = "🧪 ", hl = "Constant" } },

      -- Code quality and linting
      { "<leader>rl", group = "[L]int & Quality", icon = { icon = "✨ ", hl = "Constant" } },

      -- Formatting
      { "<leader>rf", group = "[F]ormat & Search", icon = { icon = "🎨 ", hl = "Constant" } },

      -- Documentation
      { "<leader>rd", group = "[D]ocumentation", icon = { icon = "📚 ", hl = "Constant" } },

      -- Dependency and package management
      { "<leader>ru", group = "[U]pdate & Dependencies", icon = { icon = "📦 ", hl = "Constant" } },

      -- Rustaceanvim helpers and LSP actions
      { "<leader>rh", group = "[H]elpers & LSP", icon = { icon = "🔍 ", hl = "Constant" } },

      -- Project management
      { "<leader>rp", group = "[P]roject Management", icon = { icon = "📁 ", hl = "Constant" } },

      -- Crate management (Cargo.toml)
      { "<leader>rc", group = "[C]rate Management", icon = { icon = "📦 ", hl = "Constant" } },

      -- Benchmarking and performance
      { "<leader>rB", group = "[B]enchmark & Performance", icon = { icon = "⚡ ", hl = "Constant" } },

      -- Coverage and profiling
      { "<leader>rC", group = "[C]overage & Profiling", icon = { icon = "📊 ", hl = "Constant" } },

      -- Performance optimization
      { "<leader>rP", group = "[P]erformance Analysis", icon = { icon = "🚀 ", hl = "Constant" } },
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
