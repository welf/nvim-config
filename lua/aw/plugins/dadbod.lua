return {
  "tpope/vim-dadbod",
  lazy = true,
  dependencies = {
    {
      "kristijanhusak/vim-dadbod-ui",
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
      init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  opts = {
    db_competion = function()
      ---@diagnostic disable-next-line
      require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
    end,
  },
  config = function(_, opts)
    vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
      },
      command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
        "mysql",
        "plsql",
      },
      callback = function()
        vim.schedule(opts.db_completion)
      end,
    })
  end,
  keys = {
    { "<leader>tD", "<cmd>DBUIToggle<cr>", desc = "[t]oggle [D]atabase ui" },
    { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "[D]atabase [f]ind buffer" },
    { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "[D]atabase [r]ename buffer" },
    { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "[D]atabase last [q]uery " },
  },
}
