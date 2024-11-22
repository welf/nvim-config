return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  config = function()
    local ts = require("telescope")
    local h_pct = 0.90
    local w_pct = 0.99
    local w_limit = 99

    local standard_setup = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      preview = { hide_on_startup = false },
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          mirror = true,
          prompt_position = "top",
          width = function(_, cols, _)
            return math.min(math.floor(w_pct * cols), w_limit)
          end,
          height = function(_, _, rows)
            return math.floor(rows * h_pct)
          end,
          preview_cutoff = 10,
          preview_height = 0.4,
        },
      },
    }

    local fullscreen_setup = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      preview = { hide_on_startup = false },
      layout_strategy = "flex",
      layout_config = {
        flex = { flip_columns = 100 },
        horizontal = {
          mirror = false,
          prompt_position = "top",
          width = function(_, cols, _)
            return cols
          end,
          height = function(_, _, rows)
            return rows
          end,
          preview_cutoff = 10,
          preview_width = 0.6,
        },
        vertical = {
          mirror = true,
          prompt_position = "top",
          width = function(_, cols, _)
            return cols
          end,
          height = function(_, _, rows)
            return rows
          end,
          preview_cutoff = 10,
          preview_height = 0.5,
        },
      },
    }

    ts.setup({
      defaults = vim.tbl_extend("error", standard_setup, {
        selection_caret = " ",
        entry_prefix = " ",
        file_ignore_patterns = { "node_modules", ".git" },
        sorting_strategy = "ascending",
        path_display = { "filename_first" },
        mappings = {
          n = {
            ["o"] = require("telescope.actions.layout").toggle_preview,
            ["<C-c>"] = require("telescope.actions").close,
          },
          i = {
            ["<C-o>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      }),
      pickers = {
        oldfiles = {
          prompt_title = "Recent Files",
        },
        buffers = {
          prompt_title = "Open Buffers",
        },
        find_files = {
          prompt_title = "Files",
        },
        builtin = {
          prompt_title = "Builtin Pickers",
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })
    ts.load_extension("fzf")
  end,
}
