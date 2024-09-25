return {
  "navarasu/onedark.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local onedark = require("onedark")
    -- load the colorscheme here
    -- vim.cmd([[colorscheme onedark]])

    -- Lua
    onedark.setup({
      -- Main options --
      style = "deep", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false, -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- toggle theme style ---
      toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine options --
      lualine = {
        transparent = false, -- lualine center bar transparency
      },

      -- Custom Highlights --
      --
      -- Override default colors
      -- green = "#00ffaa", -- redefine an existing color
      colors = {
        bright_orange = "#ff8800", -- define a new color
      },
      -- Override highlight groups
      -- ["@function"] = {fg = "$blue", bg = "$green", sp = "$cyan", fmt = "underline,italic"},
      highlights = {
        CursorLineNr = { fg = "$blue", fmt = "bold" }, -- Cursor line number color
        ["@lsp.type.interface"] = { fg = "$bright_orange" }, -- Change the interface and trait color
        ["@lsp.type.derive"] = { fg = "$bright_orange" }, -- Use the same color for traits in derive macro
      },

      -- Plugins Config --
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
    })
    onedark.load()
    -- load the colorscheme here
    vim.cmd([[colorscheme onedark]])
  end,
}
