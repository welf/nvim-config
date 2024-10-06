return {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
    diff = {
      ctxlen = 3,
    },

    -- priority list of external command to highlight diff
    -- disabled by defalt, must be set by yourself
    highlight_command = {
      -- require("actions-preview.highlight").delta(),
      -- require("actions-preview.highlight").diff_so_fancy(),
      -- require("actions-preview.highlight").diff_highlight(),
    },

    -- priority list of preferred backend
    backend = { "telescope", "nui" },

    -- options related to telescope.nvim
    telescope = vim.tbl_extend(
      "force",
      -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
      require("telescope.themes").get_dropdown(),
      -- a table for customizing content
      {
        -- a function to make a table containing the values to be displayed.
        -- fun(action: Action): { title: string, client_name: string|nil }
        make_value = nil,

        -- a function to make a function to be used in `display` of a entry.
        -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
        -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
        make_make_display = nil,
      }
    ),

    -- options for nui.nvim components
    nui = {
      -- component direction. "col" or "row"
      dir = "col",
      -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
      keymap = nil,
      -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
      layout = {
        position = "50%",
        size = {
          width = "60%",
          height = "90%",
        },
        min_width = 40,
        min_height = 10,
        relative = "editor",
      },
      -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
      preview = {
        size = "60%",
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
      -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
      select = {
        size = "40%",
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },
  },
  config = function()
    require("actions-preview").setup({
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    })
  end,
}
