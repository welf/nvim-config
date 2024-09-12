return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "helix", -- false | "classic" | "modern" | "helix"
    spec = {
      { "<leader>s", group = "[S]earch" },
      { "<leader>h", group = "Git [h]unk", mode = { "n", "v" } },
      { "<leader>i", group = "[I]nspect AST" },
      { "<leader>m", group = "[M]arks" },
      { "<leader>o", group = "[O]pen" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>d", group = "[D]atabase" },
      { "<leader>V", group = "[V]iew" },
      { "<leader>C", group = "[C]laude AI" },
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
