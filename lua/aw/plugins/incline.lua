local render = function(props)
  local devicons = require("nvim-web-devicons")

  -- Get the filename of the current buffer
  local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  if file_name == "" then
    file_name = "[No Name]"
  end

  -- Get the filetype icon and color
  local ft_icon, ft_color = devicons.get_icon_color(file_name)

  -- Get the modified status of the current buffer
  local is_modified = vim.bo[props.buf].modified

  -- Define the components of the statusline
  --
  -- File type icon
  local f_type_icon = { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" }
  -- File name
  local f_name = {
    -- Add a modified indicator if the file is modified
    file_name
      .. " "
      .. (is_modified and " " or ""),
    -- Set the text style to italic if the file is modified
    gui = is_modified and "italic" or "bold",
    -- Set the text color to yellow if the file is modified
    guifg = is_modified and "#FFB86C" or "none",
  }
  -- Window number
  local window_number = { "┊  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" }
  -- Git diff status
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
  -- LSP diagnostic status
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

  -- Assemble the statusline components
  local result = {
    { get_diagnostic_label() },
    { get_git_diff() },
    f_type_icon,
    f_name,
  }

  -- Add the window number to the statusline
  table.insert(result, window_number)

  -- Return the statusline components
  return result
end

return {
  "b0o/incline.nvim",
  -- Optional: Lazy load Incline
  event = "VeryLazy",
  config = function()
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
      render = render,
    })
  end,
}
