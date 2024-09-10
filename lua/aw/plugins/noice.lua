local cmdline_opts = {
  border = {
    style = "rounded",
    text = { top = "" },
  },
}

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    views = {
      cmdline_popup = {
        position = {
          row = 15,
          col = "50%",
        },
        size = {
          width = 90,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 18,
          col = "50%",
        },
        size = {
          width = 90,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
    cmdline = {
      view = "cmdline_popup",
      format = {
        cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
        search_down = { view = "cmdline", kind = "Search", pattern = "^/", icon = "🔎 ", ft = "regex" },
        search_up = { view = "cmdline", kind = "Search", pattern = "^%?", icon = "🔎 ", ft = "regex" },
        input = { view = "cmdline", icon = "✏️ ", ft = "regex" },
        calculator = { view = "cmdline", pattern = "^:=", icon = "", lang = "vimnormal" },
        substitute = {
          pattern = "^:%%?s/",
          icon = "🔁",
          ft = "regex",
          opts = { border = { text = { top = " sub (old/new/) " } } },
        },
        filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
        filefilter = { kind = "Filter", pattern = "^:%s*%%%s*!", icon = "📄 $", ft = "sh", opts = cmdline_opts },
        selectionfilter = {
          kind = "Filter",
          pattern = "^:%s*%'<,%'>%s*!",
          icon = " $",
          ft = "sh",
          opts = cmdline_opts,
        },
        lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
        rename = {
          pattern = "^:%s*IncRename%s+",
          icon = "✏️ ",
          conceal = true,
          opts = {
            relative = "cursor",
            size = { min_width = 20 },
            position = { row = -3, col = 0 },
            buf_options = { filetype = "text" },
            border = { text = { top = " rename " } },
          },
        },
        help = { pattern = "^:%s*h%s+", icon = "💡", opts = cmdline_opts },
      },
    },
    messages = { view_search = false },
    commands = {
      history = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },
            { event = "lsp", kind = "message" },
            { event = "msg_show", kind = { "" } },
          },
          ["not"] = { event = "msg_show", find = "written" },
        },
        filter_opts = { reverse = true },
      },
      errors = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = { error = true },
        filter_opts = { reverse = true },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { enabled = false },
      signature = { enabled = false },
      documentation = {
        opts = {
          win_options = {
            concealcursor = "n",
            conceallevel = 3,
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "Todo",
            },
          },
        },
      },
    },
    -- views = {
    --   split = { enter = true },
    --   mini = { win_options = { winblend = 0 } },
    -- },
    presets = {
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    routes = {
      { filter = { find = "E162" }, view = "mini" },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "fewer lines" },
            { find = "written" },
            { find = "Conflict %[%d+" },
            { find = "Col %d+" },
          },
        },
        view = "mini",
      },
      { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
      { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
      { filter = { event = "emsg", find = "E23" }, skip = true },
      { filter = { event = "emsg", find = "E20" }, skip = true },
      { filter = { find = "No signature help" }, skip = true },
      { filter = { find = "E37" }, skip = true },
      { filter = { find = "E31" }, skip = true },
      { filter = { find = "Error detected while processing BufReadPost Autocommands for" }, skip = true },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 5000,
        render = "minimal",
        stages = "fade_in_slide_out",
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      },
    },
  },
}
