-- =============================================================================
-- Enhanced Rust Diagnostics Configuration
-- =============================================================================
-- Improved error visualization and diagnostic tools for Rust development
-- Features: Better error display, quick fixes, diagnostic navigation

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- Better error display
  },
  
  config = function()
    -- =======================================================================
    -- LSP LINES SETUP (better error visualization)
    -- =======================================================================
    require("lsp_lines").setup()
    
    -- Disable virtual_text since we're using lsp_lines
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = { highlight_whole_line = false },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        show_header = true,
        source = "always",
        border = "rounded",
        format = function(diagnostic)
          -- Enhanced formatting for Rust diagnostics
          local message = diagnostic.message
          
          -- Add error code if available
          if diagnostic.code then
            message = string.format("[%s] %s", diagnostic.code, message)
          end
          
          -- Add source information
          if diagnostic.source then
            message = string.format("(%s) %s", diagnostic.source, message)
          end
          
          return message
        end,
      },
    })
    
    -- =======================================================================
    -- TROUBLE SETUP (diagnostic list)
    -- =======================================================================
    require("trouble").setup({
      modes = {
        diagnostics = {
          mode = "diagnostics",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
      },
      icons = {
        indent = {
          top           = "│ ",
          middle        = "├╴",
          last          = "└╴",
          fold_open     = " ",
          fold_closed   = " ",
          ws            = "  ",
        },
        folder_closed   = " ",
        folder_open     = " ",
        kinds = {
          Array         = " ",
          Boolean       = "󰨙 ",
          Class         = " ",
          Constant      = "󰏿 ",
          Constructor   = " ",
          Enum          = " ",
          EnumMember    = " ",
          Event         = " ",
          Field         = " ",
          File          = " ",
          Function      = "󰊕 ",
          Interface     = " ",
          Key           = " ",
          Method        = "󰊕 ",
          Module        = " ",
          Namespace     = "󰦮 ",
          Null          = " ",
          Number        = "󰎠 ",
          Object        = " ",
          Operator      = " ",
          Package       = " ",
          Property      = " ",
          String        = " ",
          Struct        = "󰆼 ",
          TypeParameter = " ",
          Variable      = "󰀫 ",
        },
      },
    })
    
    -- =======================================================================
    -- RUST-SPECIFIC DIAGNOSTIC ENHANCEMENTS
    -- =======================================================================
    
    -- Enhanced diagnostic signs for Rust
    local signs = {
      Error = "󰅚 ",
      Warn = "󰀪 ",
      Hint = "󰌶 ",
      Info = " ",
    }
    
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    
    -- =======================================================================
    -- RUST ERROR EXPLANATION SYSTEM
    -- =======================================================================
    
    local function explain_rust_error()
      local line = vim.fn.line(".")
      local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
      
      if #diagnostics == 0 then
        vim.notify("No diagnostics on current line", vim.log.levels.INFO)
        return
      end
      
      local diagnostic = diagnostics[1]
      local error_code = diagnostic.code
      
      if error_code and error_code:match("^E%d+") then
        -- Open rustc error explanation
        vim.cmd("split | resize 20 | terminal rustc --explain " .. error_code)
        vim.cmd("startinsert")
      elseif diagnostic.source == "rust-analyzer" then
        -- For rust-analyzer diagnostics, show detailed info
        vim.diagnostic.open_float(0, {
          scope = "line",
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = "always",
          prefix = " ",
          header = "Rust Analyzer Diagnostic:",
        })
      else
        -- Generic diagnostic display
        vim.diagnostic.open_float()
      end
    end
    
    -- =======================================================================
    -- QUICK FIX SYSTEM
    -- =======================================================================
    
    local function apply_rust_quick_fix()
      local line = vim.fn.line(".")
      local col = vim.fn.col(".")
      
      -- Get LSP clients
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local rust_analyzer = nil
      
      for _, client in ipairs(clients) do
        if client.name == "rust_analyzer" then
          rust_analyzer = client
          break
        end
      end
      
      if not rust_analyzer then
        vim.notify("Rust analyzer not attached", vim.log.levels.WARN)
        return
      end
      
      -- Request code actions
      local params = vim.lsp.util.make_range_params()
      params.context = {
        diagnostics = vim.diagnostic.get(0, { lnum = line - 1 }),
        only = { "quickfix" }
      }
      
      rust_analyzer.request("textDocument/codeAction", params, function(err, result)
        if err then
          vim.notify("Error getting code actions: " .. err.message, vim.log.levels.ERROR)
          return
        end
        
        if not result or #result == 0 then
          vim.notify("No quick fixes available", vim.log.levels.INFO)
          return
        end
        
        -- If only one action, apply it directly
        if #result == 1 then
          local action = result[1]
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
          elseif action.command then
            vim.lsp.buf.execute_command(action.command)
          end
          vim.notify("Applied: " .. (action.title or "Quick fix"), vim.log.levels.INFO)
        else
          -- Multiple actions, let user choose
          vim.ui.select(result, {
            prompt = "Select code action:",
            format_item = function(item)
              return item.title
            end,
          }, function(choice)
            if choice then
              if choice.edit then
                vim.lsp.util.apply_workspace_edit(choice.edit, "utf-8")
              elseif choice.command then
                vim.lsp.buf.execute_command(choice.command)
              end
              vim.notify("Applied: " .. choice.title, vim.log.levels.INFO)
            end
          end)
        end
      end)
    end
    
    -- =======================================================================
    -- DIAGNOSTIC NAVIGATION
    -- =======================================================================
    
    local function goto_next_error()
      vim.diagnostic.goto_next({
        severity = vim.diagnostic.severity.ERROR,
        wrap = true,
        float = true,
      })
    end
    
    local function goto_prev_error()
      vim.diagnostic.goto_prev({
        severity = vim.diagnostic.severity.ERROR,
        wrap = true,
        float = true,
      })
    end
    
    local function goto_next_warning()
      vim.diagnostic.goto_next({
        severity = vim.diagnostic.severity.WARN,
        wrap = true,
        float = true,
      })
    end
    
    local function goto_prev_warning()
      vim.diagnostic.goto_prev({
        severity = vim.diagnostic.severity.WARN,
        wrap = true,
        float = true,
      })
    end
    
    -- =======================================================================
    -- KEYMAPPINGS
    -- =======================================================================
    
    local map = vim.keymap.set
    
    -- Diagnostic navigation
    map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    map("n", "]e", goto_next_error, { desc = "Next error" })
    map("n", "[e", goto_prev_error, { desc = "Previous error" })
    map("n", "]w", goto_next_warning, { desc = "Next warning" })
    map("n", "[w", goto_prev_warning, { desc = "Previous warning" })
    
    -- Diagnostic display
    map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
    map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Add diagnostics to loclist" })
    map("n", "<leader>dw", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Workspace diagnostics" })
    map("n", "<leader>dd", function()
      require("trouble").toggle("document_diagnostics")
    end, { desc = "Document diagnostics" })
    
    -- LSP lines toggle (global)
    map("n", "<leader>rel", function()
      require("lsp_lines").toggle()
    end, { desc = "Toggle LSP lines" })
    
    -- =======================================================================
    -- AUTOCOMMANDS
    -- =======================================================================
    
    local augroup = vim.api.nvim_create_augroup("RustDiagnostics", { clear = true })
    
    -- Set up Rust-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = "rust",
      callback = function()
        local opts = { buffer = true }
        map("n", "<leader>ree", explain_rust_error, vim.tbl_extend("force", opts, { desc = "Explain Rust error" }))
        map("n", "<leader>ref", apply_rust_quick_fix, vim.tbl_extend("force", opts, { desc = "Apply quick fix" }))
        map("n", "<leader>ret", function()
          require("trouble").toggle("workspace_diagnostics")
        end, vim.tbl_extend("force", opts, { desc = "Toggle diagnostics panel" }))
      end,
    })
    
    -- Auto-open trouble on Rust errors
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = augroup,
      pattern = "*.rs",
      callback = function()
        local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        if #diagnostics > 0 then
          -- Auto-open trouble after a delay to avoid flickering
          vim.defer_fn(function()
            require("trouble").open("document_diagnostics")
          end, 500)
        end
      end,
    })
    
    -- Enhanced diagnostic display for Rust files
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = "rust",
      callback = function()
        -- Enable more detailed diagnostics for Rust
        vim.diagnostic.config({
          virtual_lines = {
            highlight_whole_line = false,
            only_current_line = false,
          },
          float = {
            show_header = true,
            source = "always",
            border = "rounded",
            max_width = 120,
            max_height = 20,
          },
        })
      end,
    })
  end,
  
  -- Keymapping definitions for lazy loading
  keys = {
    { "<leader>de", desc = "Show line diagnostics" },
    { "<leader>dq", desc = "Add diagnostics to loclist" },
    { "<leader>dw", desc = "Workspace diagnostics" },
    { "<leader>dd", desc = "Document diagnostics" },
    { "<leader>rel", desc = "Toggle LSP lines" },
    { "]d", desc = "Next diagnostic" },
    { "[d", desc = "Previous diagnostic" },
    { "]e", desc = "Next error" },
    { "[e", desc = "Previous error" },
    { "]w", desc = "Next warning" },
    { "[w", desc = "Previous warning" },
  },
}