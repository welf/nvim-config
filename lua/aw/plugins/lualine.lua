local modified_icon = ""
local readonly_icon = ""
local python_icon = ""
local left = { left = "", right = "" }
local right = { left = "", right = "" }

local colors = {
  red = "#ca1243",
  blue_grey = "#6272A4",
  grey = "#AEB7D0",
  dark_grey = "#4b5263",
  black = "#383a42",
  white = "#f3f3f3",
  dark_orange = "#d65d0e",
  yellow = "#F1CA81",
  orange = "#FFB86C",
  green = "#8ec07c",
  blue = "#61afef",
  magenta = "magenta",
}

-- get active LSP client for the current buffer
local active_lsp = function()
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

local get_active_lsp = {
  active_lsp,
  icon = " ",
  color = { fg = colors.white, bg = colors.blue_grey },
  separator = right,
}

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
      return string.format(python_icon .. "  %s (conda)", conda_env)
    end
  else
    local venv_name = vim.fn.fnamemodify(venv_path, ":t")
    return string.format(python_icon .. "  %s (venv)", venv_name)
  end
end

local get_virtual_env = {
  virtual_env,
  color = { fg = colors.black, bg = colors.yellow },
  separator = left,
}

local copilot_symbols = {
  status = {
    icons = {
      enabled = " ",
      sleep = " ", -- auto-trigger disabled
      disabled = " ",
      warning = " ",
      unknown = " ",
    },
    hl = {
      enabled = colors.green,
      sleep = colors.grey,
      disabled = colors.blue_grey,
      warning = colors.orange,
      unknown = colors.red,
    },
  },
  spinners = require("copilot-lualine.spinners").dots,
  spinner_color = colors.blue_grey,
}

local get_filename_color = function()
  local modified = vim.bo.modified
  local readonly = vim.bo.readonly
  if modified then
    return { fg = colors.orange, gui = "italic" }
  elseif readonly then
    return { fg = colors.blue_grey, gui = "none" }
  else
    return { fg = colors.grey, gui = "none" }
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local filename = {
      "filename",
      color = get_filename_color,
      symbols = { modified = modified_icon, readonly = readonly_icon },
      path = 1,
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = "", right = "" },
        component_separators = "",
        -- section_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
        lualine_a = {
          { "mode", separator = left },
        },
        lualine_b = {
          {
            "branch",
            fmt = function(name, _)
              -- truncate branch name in case the name is too long
              return string.sub(name, 1, 20)
            end,
            -- Set background color to the same as the statusline
            color = { fg = colors.white, bg = colors.blue_grey },
            separator = left,
          },
          get_virtual_env,
          {
            "searchcount",
            maxcount = 999,
            timeout = 500,
            separator = left,
          },
          {
            "diagnostics",
            sections = { "error" },
            diagnostics_color = {
              error = { bg = colors.red, fg = colors.white },
            },
            separator = left,
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
          {
            "diagnostics",
            sections = { "warn" },
            diagnostics_color = {
              warn = { bg = colors.dark_orange, fg = colors.white },
            },
            separator = left,
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
          {
            "diagnostics",
            sections = { "info" },
            diagnostics_color = {
              info = { bg = colors.blue, fg = colors.black },
            },
            separator = left,
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
          {
            "diagnostics",
            sections = { "hint" },
            diagnostics_color = {
              hint = { bg = colors.magenta, fg = colors.white },
            },
            separator = left,
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
          {
            "filetype",
            icon_only = true,
            separator = left,
          },
          filename,
        },
        lualine_c = {},
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
        lualine_x = {
          get_active_lsp,
          {
            "copilot",
            -- Default values
            symbols = copilot_symbols,
            show_colors = true,
            show_loading = true,
            separator = right,
          },
        },
        lualine_y = {
          { "encoding", separator = right },
          {
            "fileformat",
            symbols = {
              unix = "", -- e712
              dos = "", -- e70f
              mac = "", -- e711
            },
            separator = right,
          },
          {
            "progress",
            separator = right,
          },
        },
        lualine_z = {
          {
            "location",
            separator = right,
          },
        },
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
