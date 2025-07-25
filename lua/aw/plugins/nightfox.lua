return {
  "EdenEast/nightfox.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local nightfox = require("nightfox")

    nightfox.setup({
      options = {
        -- Compiled file's destination location
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = false, -- Disable setting background
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false, -- Non focused panes set to alternative background
        module_default = true, -- Default enable value for modules
        colorblind = {
          enable = false, -- Enable colorblind support
          simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
          severity = {
            protan = 0, -- Severity [0,1] for protan (red)
            deutan = 0, -- Severity [0,1] for deutan (green)
            tritan = 0, -- Severity [0,1] for tritan (blue)
          },
        },
        styles = { -- Style to be applied to different syntax groups
          comments = "italic", -- Value is any valid attr-list value `:help attr-list`
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = { -- Inverse highlight for different types
          match_paren = false,
          visual = false,
          search = false,
        },
        modules = { -- List of various plugins and additional options
          -- ...
        },
      },
      -- Palettes are the base color defines of a colorscheme.
      -- You can override these palettes for each colorscheme defined by nightfox.
      palettes = {
        -- Everything defined under `all` will be applied to each style.
        all = {
          -- Each palette defines these colors:
          --   black, red, green, yellow, blue, magenta, cyan, white, orange, pink
          --
          -- These colors have 3 shades: base, bright, and dim
          --
          -- Defining just a color defines it's base color
          -- red = "#ff0000",
        },
        nightfox = {
          -- A specific style's value will be used over the `all`'s value
          red = "#c94f6d",
          -- Make foreground colors less bright
          fg1 = "#b4bbc8", -- Main foreground (dimmed from default)
          fg2 = "#9da3b0", -- Secondary foreground (dimmed)
          fg3 = "#868c99", -- Tertiary foreground (dimmed)
        },
        dayfox = {
          -- Defining multiple shades is done by passing a table
          -- blue = { base = "#4d688e", bright = "#4e75aa", dim = "#485e7d" },
        },
        nordfox = {
          -- A palette also defines the following:
          --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment
          --
          -- These are the different foreground and background shades used by the theme.
          -- The base bg and fg is 1, 0 is normally the dark alternative. The others are
          -- incrementally lighter versions.
          -- bg1 = "#2e3440",

          -- sel is different types of selection colors.
          -- sel0 = "#3e4a5b", -- Popup bg, visual selection bg
          -- sel1 = "#4f6074", -- Popup sel bg, search bg

          -- comment is the definition of the comment color.
          -- comment = "#60728a",
        },
      },
      -- Spec's (specifications) are a mapping of palettes to logical groups that will be
      -- used by the groups. Some examples of the groups that specs map would be:
      --   - syntax groups (functions, types, keywords, ...)
      --   - diagnostic groups (error, warning, info, hints)
      --   - git groups (add, removed, changed)
      --
      -- You can override these just like palettes
      specs = {
        -- As with palettes, the values defined under `all` will be applied to every style.
        all = {
          syntax = {
            -- Specs allow you to define a value using either a color or template. If the string does
            -- start with `#` the string will be used as the path of the palette table. Defining just
            -- a color uses the base version of that color.
            -- keyword = "magenta",

            -- Adding either `.bright` or `.dim` will change the value
            -- conditional = "magenta.bright",
            -- number = "orange.dim",
          },
          git = {
            -- A color define can also be used
            changed = "#f4a261",
          },
        },
        nightfox = {
          syntax = {
            -- As with palettes, a specific style's value will be used over the `all`'s value.
            -- operator = "orange",
            -- Use normal (base) syntax colors instead of bright
            keyword = "blue",
            conditional = "magenta",
            constant = "orange",
            func = "blue",
            string = "green",
            type = "yellow",
            variable = "cyan.dim",
            field = "blue",
            parameter = "fg2",
          },
        },
      },
      -- Groups are the highlight group definitions. The keys of this table are the name of the highlight
      -- groups that will be overridden. The value is a table with the following values:
      --   - fg, bg, style, sp, link,
      --
      -- Just like `spec` groups support templates. This time the template is based on a spec object.
      groups = {
        -- As with specs and palettes, the values defined under `all` will be applied to every style.
        all = {
          -- If `link` is defined it will be applied over any other values defined
          Whitespace = { link = "Comment" },

          -- Specs are used for the template. Specs have their palette's as a field that can be accessed
          IncSearch = { bg = "palette.cyan" },
        },
        nightfox = {
          -- As with specs and palettes, a specific style's value will be used over the `all`'s value.
          PmenuSel = { bg = "#73daca", fg = "bg0" },

          -- Make indentation lines very subtle with specific colors
          IblIndent = { fg = "#2a2f3e" },
          IblScope = { fg = "#3b4261" },
          -- Legacy support for older versions
          IndentBlanklineChar = { fg = "#2a2f3e" },
          IndentBlanklineContextChar = { fg = "#3b4261" },
        },
      },
    })

    -- Clear any cached compiled themes
    vim.fn.delete(vim.fn.stdpath("cache") .. "/nightfox", "rf")

    nightfox.load()
    -- load the colorscheme here
    vim.cmd([[colorscheme nightfox]])

    -- Force reload highlights after everything is loaded
    vim.defer_fn(function()
      vim.cmd([[colorscheme nightfox]])
    end, 100)
  end,
}
