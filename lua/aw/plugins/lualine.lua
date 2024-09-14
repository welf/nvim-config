return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local filename = {
      "filename",
      color = { gui = "bold", fg = "#61afef" },
    }
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = "",
        -- section_separators = { left = "", right = "" },
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
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "buffers" },
        -- lualine_c = { filename },
        lualine_x = {
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
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "neo-tree", "fugitive", "quickfix", "symbols-outline", "mason", "fzf", "lazy" },
    })
  end,
}
