return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "modern", -- false | "classic" | "modern" | "helix"
    spec = {
      { "<leader>s", group = "Search" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "<leader>i", group = "Inspect AST" },
      { "<leader>m", group = "Marks" },
      { "<leader>o", group = "Open" },
      { "<leader>t", group = "Toggle" },
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
