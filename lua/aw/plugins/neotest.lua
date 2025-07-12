-- =============================================================================
-- Neotest Configuration for Advanced Rust Testing
-- =============================================================================
-- Modern test runner with visual feedback, debugging integration, and coverage
-- Features: Test discovery, inline results, debugging, coverage reports

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Rust adapter
    "rouge8/neotest-rust",
    -- Debug adapter integration
    "mfussenegger/nvim-dap",
  },
  event = { "BufReadPre *.rs", "BufNewFile *.rs" },
  
  config = function()
    require("neotest").setup({
      -- =======================================================================
      -- ADAPTERS CONFIGURATION
      -- =======================================================================
      adapters = {
        require("neotest-rust") {
          -- Use cargo-nextest if available, fallback to cargo test
          args = function()
            local has_nextest = vim.fn.executable("cargo-nextest") == 1
            if has_nextest then
              return { "nextest", "run" }
            else
              return { "test" }
            end
          end,
          -- Enable debug mode for better error output
          dap_adapter = "codelldb",
          -- Enable rustaceanvim integration
          is_test_file = function(file_path)
            return file_path:match("%.rs$") and 
                   (file_path:match("_test%.rs$") or 
                    file_path:match("tests/") or 
                    vim.fn.search("#\\[test\\]", "nw") > 0 or
                    vim.fn.search("#\\[cfg(test)\\]", "nw") > 0)
          end,
        },
      },
      
      -- =======================================================================
      -- DISCOVERY CONFIGURATION
      -- =======================================================================
      discovery = {
        concurrent = 8, -- Run discovery concurrently
        enabled = true,
        filter_dir = function(name, rel_path, root)
          -- Skip target directory and hidden directories
          return not vim.tbl_contains({ "target", ".git", "node_modules" }, name)
        end,
      },
      
      -- =======================================================================
      -- RUNNING CONFIGURATION
      -- =======================================================================
      running = {
        concurrent = true,
        -- Show running status in statusline
        status_signs = {
          enabled = true,
          signs = {
            running = "⏳",
            passed = "✅",
            failed = "❌",
            skipped = "⏭️",
          },
        },
      },
      
      -- =======================================================================
      -- DIAGNOSTIC CONFIGURATION
      -- =======================================================================
      diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.ERROR,
      },
      
      -- =======================================================================
      -- FLOATING WINDOW CONFIGURATION
      -- =======================================================================
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = {},
      },
      
      -- =======================================================================
      -- HIGHLIGHT CONFIGURATION
      -- =======================================================================
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
      },
      
      -- =======================================================================
      -- ICONS CONFIGURATION
      -- =======================================================================
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✖",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        notify = "★",
        passed = "✓",
        running = "⟳",
        running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        skipped = "○",
        unknown = "?",
        watching = "👁",
      },
      
      -- =======================================================================
      -- OUTPUT CONFIGURATION
      -- =======================================================================
      output = {
        enabled = true,
        open_on_run = true,
      },
      
      -- =======================================================================
      -- OUTPUT PANEL CONFIGURATION
      -- =======================================================================
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      
      -- =======================================================================
      -- QUICKFIX CONFIGURATION
      -- =======================================================================
      quickfix = {
        enabled = true,
        open = false, -- Don't auto-open quickfix
      },
      
      -- =======================================================================
      -- STATE CONFIGURATION
      -- =======================================================================
      state = {
        enabled = true,
      },
      
      -- =======================================================================
      -- STATUS CONFIGURATION
      -- =======================================================================
      status = {
        enabled = true,
        signs = true,
        virtual_text = false, -- Disable to avoid clutter
      },
      
      -- =======================================================================
      -- STRATEGIES CONFIGURATION
      -- =======================================================================
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      
      -- =======================================================================
      -- SUMMARY CONFIGURATION
      -- =======================================================================
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w",
        },
        open = "botright vsplit | vertical resize 50",
      },
      
      -- =======================================================================
      -- WATCH CONFIGURATION
      -- =======================================================================
      watch = {
        enabled = true,
        symbol_queries = {
          rust = [[
            (function_item
              name: (identifier) @name
              (#match? @name "^test_"))
            (attribute_item
              (attribute
                (identifier) @attr
                (#eq? @attr "test")))
          ]],
        },
      },
    })
    
    -- =======================================================================
    -- CUSTOM HIGHLIGHTS
    -- =======================================================================
    local highlights = {
      NeotestAdapterName = { fg = "#7aa2f7", bold = true },
      NeotestBorder = { fg = "#414868" },
      NeotestDir = { fg = "#7dcfff" },
      NeotestExpandMarker = { fg = "#565f89" },
      NeotestFailed = { fg = "#f7768e" },
      NeotestFile = { fg = "#7dcfff" },
      NeotestFocused = { fg = "#e0af68" },
      NeotestIndent = { fg = "#414868" },
      NeotestNamespace = { fg = "#bb9af7" },
      NeotestPassed = { fg = "#9ece6a" },
      NeotestRunning = { fg = "#e0af68" },
      NeotestSkipped = { fg = "#565f89" },
      NeotestTarget = { fg = "#7aa2f7" },
      NeotestTest = { fg = "#c0caf5" },
      NeotestUnknown = { fg = "#565f89" },
      NeotestWinSelect = { fg = "#7aa2f7", bold = true },
    }
    
    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
  
  -- =======================================================================
  -- KEYMAPPINGS (using <leader>r prefix for Rust)
  -- =======================================================================
  keys = {
    -- Test running (using <leader>rn* for neotest operations)
    { "<leader>rnn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
    { "<leader>rnf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run current file tests" },
    { "<leader>rna", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = "Run all tests" },
    { "<leader>rnl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run last test" },
    { "<leader>rns", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop running tests" },
    
    -- Test debugging (using <leader>rn* for consistency)
    { "<leader>rnd", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug nearest test" },
    { "<leader>rnD", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug current file tests" },
    
    -- Test navigation and results
    { "<leader>rno", "<cmd>lua require('neotest').output.open({enter = true})<cr>", desc = "Open test output" },
    { "<leader>rnO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle output panel" },
    { "<leader>rnt", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle test summary" },
    { "<leader>rnm", "<cmd>lua require('neotest').run.run({suite = false, extra_args = {'--no-capture'}})<cr>", desc = "Run with output" },
    
    -- Test navigation
    { "]t", "<cmd>lua require('neotest').jump.next({status = 'failed'})<cr>", desc = "Jump to next failed test" },
    { "[t", "<cmd>lua require('neotest').jump.prev({status = 'failed'})<cr>", desc = "Jump to previous failed test" },
    
    -- Test watching
    { "<leader>rnw", "<cmd>lua require('neotest').watch.toggle()<cr>", desc = "Toggle test watching" },
    { "<leader>rnW", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", desc = "Toggle file watching" },
    
    -- Test marks and targets
    { "<leader>rnM", "<cmd>lua require('neotest').run.run({suite = true})<cr>", desc = "Run test suite" },
    { "<leader>rnT", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), env = {RUST_LOG = 'debug'}})<cr>", desc = "Run with debug logging" },
  },
}