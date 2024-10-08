return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "famiu/bufdelete.nvim", -- for autocmd
  },
  opts = {
    theme = "hyper", --  theme is doom and hyper default is hyper
    disable_move = true, --  default is false disable move keymap for hyper
    shortcut_type = "letter", --  shorcut type 'letter' or 'number'
    shuffle_letter = false, --  default is true, shortcut 'letter' will be randomize, set to false to have ordered letter.
    change_to_vcs_root = false, -- default is false,for open file in hyper mru. it will change to the root of vcs
    --  config used for theme hyper
    config = {
      header = {
        "                                                       ",
        "                                                       ",
        "                                                       ",
        " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
        "                                                       ",
        "                                                       ",
        "                                                       ",
        "                                                       ",
      }, -- type is table def
      week_header = {
        enable = true, --boolean use a week header
      },
      disable_move = false, -- boolean default is false disable move key
      shortcut = {
        -- action can be a function type
        {
          icon = " ",
          desc = "New buffer",
          action = "ene | startinsert",
          key = "e",
        },
        {
          icon = " ",
          desc = "Restore Last Session",
          action = function()
            require("persistence").load({ last = true })
          end,
          key = "r",
        },
        {
          icon = "󰍉 ",
          desc = "Find files",
          action = "Telescope find_files cwd=",
          key = "f",
        },
        {
          icon = "󰍉 ",
          desc = "Grep",
          action = "Telescope live_grep",
          key = "s",
        },
        {
          icon = " ",
          desc = "Browse",
          action = "Yazi cwd",
          key = "\\",
        },
        {
          icon = " ",
          desc = "Git",
          action = "Neogit",
          key = "g",
        },
        { icon = " ", desc = "Lazy", group = "Label", action = "Lazy check", key = "l" },
        { icon = " ", desc = "Mason", group = "Label", action = "Mason", key = "m" },
        { desc = "Quit", group = "Number", action = "q", key = "q" },
      },
      packages = { enable = true }, -- show how many plugins neovim loaded
      -- limit how many projects list, action when you press key or enter it will run this action.
      -- action can be a functino type, e.g.
      -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
      project = {
        enable = true,
        limit = 5,
        icon = "󰹈 ",
        label = "Recent Projects",
        action = "Telescope find_files cwd=",
      },
      mru = { limit = 10, icon = " ", label = "Recent files", cwd_only = true },
      footer = { "Nam et ipsa scientia potestas est" }, -- footer
    },
    hide = {
      statusline = true, -- hide statusline default is true
      tabline = true, -- hide the tabline
      winbar = true, -- hide winbar
    },
    -- preview = {
    --   command, -- preview command
    --   file_path, -- preview file path
    --   file_height   -- preview file height
    --   file_width    -- preview file width
    -- },
  },
}
