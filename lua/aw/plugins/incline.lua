return {
  "b0o/incline.nvim",
  -- Optional: Lazy load Incline
  event = "VeryLazy",
  config = function()
    local devicons = require("nvim-web-devicons")
    local navic = require("nvim-navic")
    require("incline").setup({
      ignore = {
        filetypes = { "gitcommit" },
      },
      hide = {
        cursorline = true,
        focused_win = false,
        only_win = false,
      },
      window = {
        margin = {
          horizontal = 1,
          vertical = 3,
        },
        placement = {
          horizontal = "right",
          vertical = "top",
        },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        local f_type_icon = { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" }
        local f_name = {
          -- Add a modified indicator if the file is modified
          filename
            .. " "
            .. (modified and "● " or ""),
          -- Set the text style to italic if the file is modified
          gui = modified and "italic" or "bold",
          -- Set the text color to yellow if the file is modified
          guifg = modified and "#F1CA81" or "none",
        }
        local windows = { "┊  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" }

        local function get_git_diff()
          local icons = { removed = " ", changed = " ", added = " " }
          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon .. signs[name] .. "  ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, { "┊ " })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = " ", warn = " ", info = " ", hint = " " }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. n .. "  ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, { "┊ " })
          end
          return label
        end

        local result = {
          { get_diagnostic_label() },
          { get_git_diff() },
          f_type_icon,
          f_name,
        }

        if props.focused then
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            print(item.name)
            table.insert(result, {
              { " > ", group = "NavicSeparator" },
              { item.icon, group = "NavicIcons" .. item.type },
              { item.name, group = "NavicText" },
            })
          end
        end

        if props.win == vim.api.nvim_get_current_win() then
          table.insert(result, windows)
        end

        return result
      end,
    })
  end,
}
