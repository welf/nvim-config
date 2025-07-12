-- =============================================================================
-- Enhanced Rust Documentation Tools
-- =============================================================================
-- Advanced documentation generation and navigation for Rust projects
-- Features: Doc generation, navigation, inline docs, doc testing

return {
  "hedyhli/outline.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = "rust",
  
  config = function()
    require("outline").setup({
      outline_window = {
        position = 'right',
        relative_width = true,
        width = 25,
        auto_close = false,
        auto_jump = false,
        jump_highlight_duration = 300,
        center_on_jump = true,
        show_numbers = false,
        show_relative_numbers = false,
        wrap = false,
        show_cursorline = true,
        hide_cursor = false,
        focus_on_open = false,
        winhl = '',
      },
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = false,
        highlight_hovered_item = true,
        auto_set_cursor = true,
        auto_update_events = {
          follow = { 'CursorMoved' },
          items = { 'InsertLeave', 'WinEnter', 'BufEnter', 'BufWinEnter', 'TabEnter', 'BufWritePost' },
        },
      },
      guides = {
        enabled = true,
        markers = {
          bottom = '└',
          middle = '├',
          vertical = '│',
        },
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
          only = true,
        },
        markers = { '', '' },
      },
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = false,
        width = 50,
        min_width = 50,
        relative_width = true,
        border = 'single',
        winhl = 'NormalFloat:',
        live = false,
      },
      keymaps = {
        show_help = '?',
        close = {'<Esc>', 'q'},
        goto_location = '<Cr>',
        peek_location = 'o',
        goto_and_close = '<S-Cr>',
        restore_location = '<C-g>',
        hover_symbol = '<C-space>',
        toggle_preview = 'K',
        rename_symbol = 'r',
        code_actions = 'a',
        fold = 'h',
        unfold = 'l',
        fold_toggle = '<Tab>',
        fold_toggle_all = '<S-Tab>',
        fold_all = 'W',
        unfold_all = 'E',
        fold_reset = 'R',
        down_and_jump = '<C-j>',
        up_and_jump = '<C-k>',
      },
      providers = {
        priority = { 'lsp', 'coc', 'markdown', 'norg' },
        lsp = {
          blacklist_clients = {},
        },
      },
      symbols = {
        icons = {
          File = { icon = '', hl = 'Identifier' },
          Module = { icon = '', hl = 'Include' },
          Namespace = { icon = '', hl = 'Include' },
          Package = { icon = '', hl = 'Include' },
          Class = { icon = '𝓒', hl = 'Type' },
          Method = { icon = 'ƒ', hl = 'Function' },
          Property = { icon = '', hl = 'Identifier' },
          Field = { icon = '', hl = 'Identifier' },
          Constructor = { icon = '', hl = 'Special' },
          Enum = { icon = 'ℰ', hl = 'Type' },
          Interface = { icon = '', hl = 'Type' },
          Function = { icon = '', hl = 'Function' },
          Variable = { icon = '', hl = 'Constant' },
          Constant = { icon = '', hl = 'Constant' },
          String = { icon = '𝓐', hl = 'String' },
          Number = { icon = '#', hl = 'Number' },
          Boolean = { icon = '⊨', hl = 'Boolean' },
          Array = { icon = '', hl = 'Constant' },
          Object = { icon = '⦿', hl = 'Type' },
          Key = { icon = '🔐', hl = 'Type' },
          Null = { icon = 'NULL', hl = 'Type' },
          EnumMember = { icon = '', hl = 'Identifier' },
          Struct = { icon = '𝓢', hl = 'Structure' },
          Event = { icon = '🗲', hl = 'Type' },
          Operator = { icon = '+', hl = 'Identifier' },
          TypeParameter = { icon = '𝙏', hl = 'Identifier' },
          Component = { icon = '', hl = 'Function' },
          Fragment = { icon = '', hl = 'Constant' },
        },
        filter = {
          default = {
            'String', 'Number', 'Boolean', 'Array', 'Object', 'Key', 'Null',
            exclude = true
          },
          rust = {
            'String', 'Number', 'Boolean', 'Array', 'Object', 'Key', 'Null',
            exclude = true
          },
        },
      },
    })
    
    -- =======================================================================
    -- DOCUMENTATION ENHANCEMENT FUNCTIONS
    -- =======================================================================
    
    local function open_rust_docs()
      local word = vim.fn.expand("<cword>")
      if word == "" then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
      end
      
      -- Try to find local documentation first
      local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
      if cargo_toml ~= "" then
        local project_dir = vim.fn.fnamemodify(cargo_toml, ":h")
        local doc_path = project_dir .. "/target/doc"
        
        if vim.fn.isdirectory(doc_path) == 1 then
          vim.fn.system("open " .. doc_path .. "/index.html")
          return
        end
      end
      
      -- Fallback to online docs
      local url = "https://doc.rust-lang.org/std/?search=" .. word
      vim.fn.system("open '" .. url .. "'")
    end
    
    local function open_crate_docs()
      local word = vim.fn.expand("<cword>")
      if word == "" then
        vim.notify("No word under cursor", vim.log.levels.WARN)
        return
      end
      
      local url = "https://docs.rs/" .. word
      vim.fn.system("open '" .. url .. "'")
    end
    
    local function generate_doc_template()
      local current_line = vim.fn.line(".")
      local lines = vim.api.nvim_buf_get_lines(0, current_line, current_line + 10, false)
      
      -- Find function/struct/enum definition
      local definition_line = nil
      local definition_type = nil
      
      for i, line in ipairs(lines) do
        if line:match("^%s*pub%s+fn%s+") or line:match("^%s*fn%s+") then
          definition_line = line
          definition_type = "function"
          break
        elseif line:match("^%s*pub%s+struct%s+") or line:match("^%s*struct%s+") then
          definition_line = line
          definition_type = "struct"
          break
        elseif line:match("^%s*pub%s+enum%s+") or line:match("^%s*enum%s+") then
          definition_line = line
          definition_type = "enum"
          break
        end
      end
      
      if not definition_line then
        vim.notify("No function/struct/enum found", vim.log.levels.WARN)
        return
      end
      
      local doc_template = {}
      
      if definition_type == "function" then
        -- Extract function name and parameters
        local fn_name = definition_line:match("fn%s+([%w_]+)")
        local params = definition_line:match("%((.*)%)")
        
        table.insert(doc_template, "/// " .. fn_name:gsub("_", " "):gsub("^%l", string.upper))
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// # Arguments")
        table.insert(doc_template, "///")
        
        -- Parse parameters
        if params and params ~= "" then
          for param in params:gmatch("([%w_]+):%s*[^,]+") do
            table.insert(doc_template, "/// * `" .. param .. "` - Description")
          end
        end
        
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// # Returns")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// Description of return value")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// # Examples")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// ```")
        table.insert(doc_template, "/// // Example usage")
        table.insert(doc_template, "/// ```")
        
      elseif definition_type == "struct" then
        local struct_name = definition_line:match("struct%s+([%w_]+)")
        table.insert(doc_template, "/// " .. struct_name:gsub("_", " "):gsub("^%l", string.upper))
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// Description of the struct")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// # Examples")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// ```")
        table.insert(doc_template, "/// // Example usage")
        table.insert(doc_template, "/// ```")
        
      elseif definition_type == "enum" then
        local enum_name = definition_line:match("enum%s+([%w_]+)")
        table.insert(doc_template, "/// " .. enum_name:gsub("_", " "):gsub("^%l", string.upper))
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// Description of the enum")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// # Variants")
        table.insert(doc_template, "///")
        table.insert(doc_template, "/// * `Variant` - Description")
      end
      
      -- Insert documentation above current line
      vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, doc_template)
      
      -- Move cursor to first description line
      vim.fn.cursor(current_line, 1)
      vim.cmd("normal! f ")
      vim.cmd("startinsert!")
    end
    
    local function run_doc_tests()
      local current_file = vim.fn.expand("%:p")
      local cargo_toml = vim.fn.findfile("Cargo.toml", vim.fn.expand("%:p:h") .. ";")
      
      if cargo_toml == "" then
        vim.notify("Not in a Rust project", vim.log.levels.ERROR)
        return
      end
      
      local project_dir = vim.fn.fnamemodify(cargo_toml, ":h")
      local relative_path = vim.fn.fnamemodify(current_file, ":." .. project_dir)
      
      -- Run doc tests for current file
      local cmd = "cargo test --doc --package " .. vim.fn.fnamemodify(project_dir, ":t")
      vim.cmd("split | resize 20 | terminal " .. cmd)
      vim.cmd("startinsert")
    end
    
    local function extract_docs_to_readme()
      local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
      if cargo_toml == "" then
        vim.notify("Not in a Rust project", vim.log.levels.ERROR)
        return
      end
      
      local project_dir = vim.fn.fnamemodify(cargo_toml, ":h")
      local lib_rs = project_dir .. "/src/lib.rs"
      
      if vim.fn.filereadable(lib_rs) == 0 then
        vim.notify("lib.rs not found", vim.log.levels.ERROR)
        return
      end
      
      -- Read lib.rs and extract module-level documentation
      local lib_content = vim.fn.readfile(lib_rs)
      local readme_lines = {}
      local in_doc_comment = false
      
      for _, line in ipairs(lib_content) do
        if line:match("^//!") then
          in_doc_comment = true
          local doc_line = line:gsub("^//!%s*", "")
          table.insert(readme_lines, doc_line)
        elseif in_doc_comment and not line:match("^//") and line:match("%S") then
          break
        end
      end
      
      if #readme_lines > 0 then
        local readme_path = project_dir .. "/README.md"
        vim.fn.writefile(readme_lines, readme_path)
        vim.notify("Generated README.md from lib.rs documentation", vim.log.levels.INFO)
      else
        vim.notify("No module-level documentation found in lib.rs", vim.log.levels.WARN)
      end
    end
    
    -- =======================================================================
    -- KEYMAPPINGS
    -- =======================================================================
    
    local map = vim.keymap.set
    
    -- Global LSP documentation (works for all file types)
    map("n", "K", vim.lsp.buf.hover, { desc = "Show documentation" })
    
    -- =======================================================================
    -- AUTOCOMMANDS
    -- =======================================================================
    
    local augroup = vim.api.nvim_create_augroup("RustDocs", { clear = true })
    
    -- Set up Rust-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = "rust",
      callback = function()
        local opts = { buffer = true, desc = "Rust docs" }
        map("n", "<leader>rDs", "<cmd>Outline<cr>", vim.tbl_extend("force", opts, { desc = "Symbols outline" }))
        map("n", "<leader>rDr", open_rust_docs, vim.tbl_extend("force", opts, { desc = "Open Rust docs" }))
        map("n", "<leader>rDc", open_crate_docs, vim.tbl_extend("force", opts, { desc = "Open crate docs" }))
        map("n", "<leader>rDt", generate_doc_template, vim.tbl_extend("force", opts, { desc = "Generate doc template" }))
        map("n", "<leader>rDT", run_doc_tests, vim.tbl_extend("force", opts, { desc = "Run doc tests" }))
        map("n", "<leader>rDR", extract_docs_to_readme, vim.tbl_extend("force", opts, { desc = "Extract docs to README" }))
        map("n", "<leader>rDh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover info" }))
        map("n", "<leader>rDi", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
      end,
    })
    
    -- Auto-generate documentation templates
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = "*.rs",
      callback = function()
        -- Check if we're in a function/struct/enum without documentation
        local current_line = vim.fn.line(".")
        local lines = vim.api.nvim_buf_get_lines(0, math.max(0, current_line - 5), current_line, false)
        
        -- Check if there's a definition without preceding documentation
        for i = #lines, 1, -1 do
          local line = lines[i]
          if line:match("^%s*pub%s+fn%s+") or line:match("^%s*fn%s+") or
             line:match("^%s*pub%s+struct%s+") or line:match("^%s*struct%s+") or
             line:match("^%s*pub%s+enum%s+") or line:match("^%s*enum%s+") then
            
            -- Check if previous line is documentation
            local prev_line = lines[i - 1]
            if not prev_line or not prev_line:match("^%s*///") then
              -- Could suggest documentation here, but might be too intrusive
              -- vim.notify("Consider adding documentation", vim.log.levels.INFO)
            end
            break
          end
        end
      end,
    })
    
    -- Enhanced hover for Rust types
    vim.api.nvim_create_autocmd("CursorHold", {
      group = augroup,
      pattern = "*.rs",
      callback = function()
        local word = vim.fn.expand("<cword>")
        if word:match("^[A-Z][a-zA-Z0-9_]*$") then -- Likely a type
          -- Could show type information automatically
          -- vim.lsp.buf.hover()
        end
      end,
    })
  end,
  
  -- Key mappings for lazy loading
  keys = {
    { "<leader>rDs", desc = "Symbols outline" },
    { "<leader>rDr", desc = "Open Rust docs" },
    { "<leader>rDc", desc = "Open crate docs" },
    { "<leader>rDt", desc = "Generate doc template" },
    { "<leader>rDT", desc = "Run doc tests" },
    { "<leader>rDR", desc = "Extract docs to README" },
    { "<leader>rDh", desc = "Show hover info" },
    { "<leader>rDi", desc = "Signature help" },
  },
}