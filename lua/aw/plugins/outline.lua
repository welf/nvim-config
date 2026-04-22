return {
  "hedyhli/outline.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = true,
  cmd = { "Outline", "OutlineOpen", "OutlineClose" },

  config = function()
    local outline = require("outline")

    -- Clean up any existing outline buffers to prevent name conflicts
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("OUTLINE") then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
    end

    outline.setup({
      outline_window = {
        position = "right",
        relative_width = true,
        width = 35,
        auto_close = true,
        auto_jump = false,
        jump_highlight_duration = 300,
        center_on_jump = true,
        show_numbers = true,
        show_relative_numbers = true,
        wrap = false,
        show_cursorline = true,
        hide_cursor = false,
        focus_on_open = true,
        winhl = "",
      },
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = false,
        highlight_hovered_item = true,
        auto_set_cursor = true,
        auto_update_events = {
          follow = { "CursorMoved" },
          items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
        },
      },
      guides = {
        enabled = true,
        markers = {
          bottom = "└",
          middle = "├",
          vertical = "│",
        },
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
          only = true,
        },
        markers = { "", "" },
      },
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = false,
        width = 50,
        min_width = 50,
        relative_width = true,
        border = "single",
        winhl = "NormalFloat:",
        live = true, -- Enable editing in preview window
      },
      keymaps = {
        show_help = "?",
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        peek_location = "o",
        goto_and_close = "<S-Cr>",
        restore_location = "<C-g>",
        -- hover_symbol removed - has bug with LSP hover response parsing
        -- Use 'K' for preview or 'o' for peek instead
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_toggle = "<Tab>",
        fold_toggle_all = "<S-Tab>",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
        down_and_jump = "<C-j>",
        up_and_jump = "<C-k>",
      },
      providers = {
        priority = { "nvim-lsp", "markdown", "norg" },
        ["nvim-lsp"] = {
          blacklist_clients = {},
        },
      },
      symbols = {
        icons = {
          File = { icon = "󰈙", hl = "Identifier" },
          Module = { icon = "󰏗", hl = "Include" },
          Namespace = { icon = "󰌗", hl = "Include" },
          Package = { icon = "󰏗", hl = "Include" },
          Class = { icon = "𝓒", hl = "Type" },
          Method = { icon = "ƒ", hl = "Function" },
          Property = { icon = "󰜢", hl = "Identifier" },
          Field = { icon = "󰽏", hl = "Identifier" },
          Constructor = { icon = "󰆧", hl = "Special" },
          Enum = { icon = "ℰ", hl = "Type" },
          Interface = { icon = "󰜰", hl = "Type" },
          Function = { icon = "ƒ", hl = "Function" },
          Variable = { icon = "󰀫", hl = "Constant" },
          Constant = { icon = "󰏿", hl = "Constant" },
          String = { icon = "𝓐", hl = "String" },
          Number = { icon = "#", hl = "Number" },
          Boolean = { icon = "◐", hl = "Boolean" },
          Array = { icon = "󰅪", hl = "Constant" },
          Object = { icon = "⦿", hl = "Type" },
          Key = { icon = "🔐", hl = "Type" },
          Null = { icon = "NULL", hl = "Type" },
          EnumMember = { icon = "󰕘", hl = "Identifier" },
          Struct = { icon = "𝓢", hl = "Structure" },
          Event = { icon = "󰉁", hl = "Type" },
          Operator = { icon = "+", hl = "Identifier" },
          TypeParameter = { icon = "𝙏", hl = "Identifier" },
          Component = { icon = "󰅴", hl = "Function" },
          Fragment = { icon = "󰅍", hl = "Constant" },
        },
        filter = {
          default = {
            -- Only exclude primitive types that clutter the outline
            "String",
            "Number",
            "Boolean",
            "Array",
            "Key",
            "Null",
            exclude = true,
          },
          -- rust = {
          --   -- Custom Rust filter disabled - use default filter for all symbol types
          -- },
        },
      },
    })

    -- Handle buffer deletion when outline is open
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function()
        local ok, outline = pcall(require, "outline")
        if ok then
          local is_open_ok, is_open = pcall(outline.is_open)
          if is_open_ok and is_open then
            -- Find a non-outline window to focus
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
              local filetype_ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })

              -- Skip outline and other special windows
              if buftype == "" and filetype_ok and filetype ~= "Outline" then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          end
        end
      end,
    })

    -- Add debug command for outline issues
    vim.api.nvim_create_user_command("OutlineDebug", function()
      local clients = vim.lsp.get_active_clients()
      print("=== OUTLINE DEBUG ===")
      print("Active LSP clients:")
      for _, client in ipairs(clients) do
        local has_symbols = client.server_capabilities.documentSymbolProvider
        print(string.format("- %s: documentSymbolProvider = %s", client.name, tostring(has_symbols)))
      end

      local ft = vim.bo.filetype
      print(string.format("Current filetype: %s", ft))

      local ok, outline = pcall(require, "outline")
      if ok then
        local is_open_ok, is_open = pcall(outline.is_open)
        print(string.format("Outline open: %s", tostring(is_open_ok and is_open)))

        -- Test if we can get symbols manually
        local symbols_ok, symbols = pcall(function()
          return vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", {
            textDocument = vim.lsp.util.make_text_document_params(),
          }, 1000)
        end)

        if symbols_ok and symbols then
          local symbol_count = 0
          for client_name, client_symbols in pairs(symbols) do
            if client_symbols.result then
              symbol_count = symbol_count + #client_symbols.result
              print(string.format("Client %s provided %d symbols", client_name, #client_symbols.result))
              -- Show first few symbols for debugging
              for i, symbol in ipairs(client_symbols.result) do
                if i <= 3 then
                  print(string.format("  - %s (%s)", symbol.name, symbol.kind))
                end
              end
            end
          end
          print(string.format("Total LSP symbols available: %d", symbol_count))
        else
          print("No LSP symbols available")
        end

        -- Check treesitter
        local has_parser = pcall(vim.treesitter.get_parser, 0, ft)
        print(string.format("Treesitter parser available for %s: %s", ft, tostring(has_parser)))
      else
        print("Failed to load outline plugin")
      end
    end, {})

    -- Add error handling for outline plugin issues
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        local ok, outline = pcall(require, "outline")
        if ok then
          local is_open_ok, is_open = pcall(outline.is_open)
          if is_open_ok and is_open then
            -- Check if current buffer is valid
            local current_buf = vim.api.nvim_get_current_buf()
            if not vim.api.nvim_buf_is_valid(current_buf) then
              -- Close outline if current buffer is invalid
              pcall(outline.close)
            end
          end
        end
      end,
    })
  end,

  keys = {
    {
      "<leader>to",
      function()
        local outline = require("outline")
        -- Check if outline is open and toggle accordingly
        if outline.is_open() then
          outline.close()
        else
          -- Clean up any stale outline buffers before opening
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local buf_name = vim.api.nvim_buf_get_name(buf)
              if buf_name:match("OUTLINE") then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
          outline.open()
          -- Force refresh symbols after opening
          vim.defer_fn(function()
            pcall(outline.refresh)
          end, 100)
        end
      end,
      desc = "[t]oggle [o]utline",
    },
    {
      "<leader>tr",
      function()
        local outline = require("outline")
        if outline.is_open() then
          outline.refresh()
        end
      end,
      desc = "[r]efresh ou[t]line",
    },
  },
}
