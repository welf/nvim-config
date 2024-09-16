return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local filename = {
      "filename",
      color = { fg = "#61afef" },
    }

    -- get active LSP client for the current buffer
    local get_active_lsp = function()
      local msg = "No Active Lsp"
      local buf_ft = vim.api.nvim_get_option_value("filetype", {})
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if next(clients) == nil then
        return msg
      end

      for _, client in ipairs(clients) do
        ---@diagnostic disable-next-line: undefined-field
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          -- append a client.name to the msg if there are multiple clients for the same filetype
          if msg == "No Active Lsp" then
            msg = client.name
          else
            msg = msg .. ", " .. client.name
          end
        end
      end
      return msg
    end

    -- get virtual env for Python files
    local virtual_env = function()
      -- only show virtual env for Python
      if vim.bo.filetype ~= "python" then
        return ""
      end

      local conda_env = os.getenv("CONDA_DEFAULT_ENV")
      local venv_path = os.getenv("VIRTUAL_ENV")

      if venv_path == nil then
        if conda_env == nil then
          return ""
        else
          return string.format("  %s (conda)", conda_env)
        end
      else
        local venv_name = vim.fn.fnamemodify(venv_path, ":t")
        return string.format("  %s (venv)", venv_name)
      end
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = "", right = "" },
        component_separators = "|",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = {
          filename,
          {
            "branch",
            fmt = function(name, _)
              -- truncate branch name in case the name is too long
              return string.sub(name, 1, 20)
            end,
          },
          {
            virtual_env,
            color = { fg = "black", bg = "#F1CA81" },
          },
          "diagnostics",
          {
            "searchcount",
            maxcount = 999,
            timeout = 500,
          },
        },
        -- lualine_c = {
        --   {
        --     "buffers",
        --     show_filename_only = true, -- Shows shortened relative path when set to false.
        --     hide_filename_extension = false, -- Hide filename extension when set to true.
        --     show_modified_status = true, -- Shows indicator when the buffer is modified.
        --
        --     mode = 0, -- 0: Shows buffer name
        --     -- 1: Shows buffer index
        --     -- 2: Shows buffer name + buffer index
        --     -- 3: Shows buffer number
        --     -- 4: Shows buffer name + buffer number
        --
        --     max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
        --     -- it can also be a function that returns
        --     -- the value of `max_length` dynamically.
        --     filetype_names = {
        --       TelescopePrompt = "Telescope",
        --       dashboard = "Dashboard",
        --       packer = "Packer",
        --       fzf = "FZF",
        --       alpha = "Alpha",
        --     }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
        --     --
        --     -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
        --     use_mode_colors = true,
        --
        --     symbols = {
        --       modified = " ●", -- Text to show when the buffer is modified
        --       alternate_file = "#", -- Text to show to identify the alternate file
        --       directory = "", -- Text to show when the buffer is a directory
        --       readonly = "[🔒]", -- Text to show when the buffer is read-only
        --     },
        --   },
        -- },
        lualine_c = {},
        lualine_x = {
          {
            get_active_lsp,
            icon = " ",
            color = { fg = "black", bg = "#dd9046" },
          },
          {
            "copilot",
            -- Default values
            symbols = {
              status = {
                icons = {
                  enabled = " ",
                  sleep = " ", -- auto-trigger disabled
                  disabled = " ",
                  warning = " ",
                  unknown = " ",
                },
                hl = {
                  enabled = "#61afef",
                  sleep = "#AEB7D0",
                  disabled = "#6272A4",
                  warning = "#FFB86C",
                  unknown = "#FF5555",
                },
              },
              spinners = require("copilot-lualine.spinners").dots,
              spinner_color = "#6272A4",
            },
            show_colors = true,
            show_loading = true,
          },
          "encoding",
          {
            "fileformat",
            symbols = {
              unix = "", -- e712
              dos = "", -- e70f
              mac = "", -- e711
            },
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
      },
      inactive_sections = {
        lualine_a = { filename },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            separator = { left = "", right = "" },
            right_padding = 2,
            symbols = { alternate_file = "" },
          },
        },
        -- lualine_a = {
        --   { "filetype", icon_only = true },
        -- },
        -- lualine_b = {
        --   { "tabs", mode = 2, max_length = vim.o.columns },
        --   {
        --     function()
        --       vim.o.showtabline = 1
        --       return ""
        --       --HACK: lualine will set &showtabline to 2 if you have configured
        --       --lualine for displaying tabline. We want to restore the default
        --       --behavior here.
        --     end,
        --   },
        -- },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "fugitive", "quickfix", "symbols-outline", "mason", "fzf", "lazy" },
    })
  end,
}
