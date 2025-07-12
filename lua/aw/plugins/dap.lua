-- =============================================================================
-- DAP Configuration for Advanced Rust Debugging
-- =============================================================================
-- Enhanced debugging with Rust-specific features and improved UX
-- Features: Breakpoint management, variable inspection, test debugging

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
  },
  
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- =======================================================================
    -- MASON-DAP SETUP
    -- =======================================================================
    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "codelldb", -- For Rust debugging
      },
    })
    
    -- =======================================================================
    -- VIRTUAL TEXT SETUP
    -- =======================================================================
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      display_callback = function(variable, buf, stackframe, node, options)
        -- Rust-specific value formatting
        if variable.type and variable.type:match("^&") then
          return variable.name .. " = " .. variable.value
        end
        return variable.name .. " = " .. variable.value
      end,
      virt_text_pos = "eol", -- end of line
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    })
    
    -- =======================================================================
    -- DAP UI INTEGRATION
    -- =======================================================================
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    
    -- =======================================================================
    -- BREAKPOINT CONFIGURATION
    -- =======================================================================
    vim.fn.sign_define("DapBreakpoint", {
      text = "🔴",
      texthl = "DapBreakpoint",
      linehl = "DapBreakpointLine",
      numhl = "DapBreakpointNum",
    })
    
    vim.fn.sign_define("DapBreakpointCondition", {
      text = "🟡",
      texthl = "DapBreakpointCondition",
      linehl = "DapBreakpointConditionLine",
      numhl = "DapBreakpointConditionNum",
    })
    
    vim.fn.sign_define("DapLogPoint", {
      text = "📋",
      texthl = "DapLogPoint",
      linehl = "DapLogPointLine",
      numhl = "DapLogPointNum",
    })
    
    vim.fn.sign_define("DapStopped", {
      text = "▶️",
      texthl = "DapStopped",
      linehl = "DapStoppedLine",
      numhl = "DapStoppedNum",
    })
    
    vim.fn.sign_define("DapBreakpointRejected", {
      text = "❌",
      texthl = "DapBreakpointRejected",
      linehl = "DapBreakpointRejectedLine",
      numhl = "DapBreakpointRejectedNum",
    })
    
    -- =======================================================================
    -- RUST-SPECIFIC DEBUGGING CONFIGURATION
    -- =======================================================================
    
    -- Helper function to get rust target
    local function get_rust_target()
      local handle = io.popen("rustc --print target-triple")
      if handle then
        local target = handle:read("*l")
        handle:close()
        return target
      end
      return "x86_64-apple-darwin" -- fallback
    end
    
    -- Helper function to find rust executable
    local function find_rust_executable()
      local current_file = vim.fn.expand("%:p")
      local cargo_toml = vim.fn.findfile("Cargo.toml", vim.fn.expand("%:p:h") .. ";")
      
      if cargo_toml == "" then
        return nil
      end
      
      local cargo_dir = vim.fn.fnamemodify(cargo_toml, ":h")
      local project_name = vim.fn.fnamemodify(cargo_dir, ":t")
      
      -- Try to find the executable in target/debug
      local debug_exe = cargo_dir .. "/target/debug/" .. project_name
      if vim.fn.filereadable(debug_exe) == 1 then
        return debug_exe
      end
      
      -- Fallback: ask user to build first
      vim.notify("Please run 'cargo build' first", vim.log.levels.WARN)
      return nil
    end
    
    -- Enhanced Rust debugging configuration
    dap.configurations.rust = {
      {
        name = "Launch Rust Program",
        type = "codelldb",
        request = "launch",
        program = function()
          local exe = find_rust_executable()
          if exe then
            return exe
          end
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        env = {
          RUST_LOG = "debug",
          RUST_BACKTRACE = "1",
        },
        
        -- Rust-specific settings
        initCommands = function()
          local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
          local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
          local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
          
          local commands = {}
          table.insert(commands, script_import)
          
          if vim.fn.filereadable(commands_file) == 1 then
            table.insert(commands, 'command source -s 0 "' .. commands_file .. '"')
          end
          
          table.insert(commands, 'type synthetic add -l lldb_lookup.synthetic_lookup -x ".*" --category Rust')
          table.insert(commands, 'type summary add -F lldb_lookup.summary_lookup  -e -x -h "^(alloc::)?(vec::)?Vec<.+>$" --category Rust')
          table.insert(commands, 'type summary add -F lldb_lookup.summary_lookup  -e -x -h "^(alloc::)?string::String$" --category Rust')
          table.insert(commands, 'category enable Rust')
          
          return commands
        end,
        
        -- Console settings
        console = "integratedTerminal",
        sourceLanguages = { "rust" },
      },
      {
        name = "Attach to Rust Process",
        type = "codelldb",
        request = "attach",
        pid = function()
          local output = vim.fn.system("pgrep -f rust")
          local processes = vim.split(output, "\n")
          local choices = {}
          for _, process in ipairs(processes) do
            if process ~= "" then
              table.insert(choices, process)
            end
          end
          
          if #choices == 0 then
            vim.notify("No Rust processes found", vim.log.levels.WARN)
            return nil
          end
          
          local choice = vim.fn.inputlist(vim.tbl_map(function(p, i)
            return i .. ". " .. p
          end, choices))
          
          if choice > 0 and choice <= #choices then
            return tonumber(choices[choice])
          end
          return nil
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        name = "Launch Rust Test",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Build test executable
          local test_name = vim.fn.input("Test name (or leave empty for all): ")
          local cmd = "cargo test --no-run --message-format=json"
          if test_name ~= "" then
            cmd = cmd .. " " .. test_name
          end
          
          local output = vim.fn.system(cmd)
          local lines = vim.split(output, "\n")
          
          for _, line in ipairs(lines) do
            if line:match("^{") then
              local success, json = pcall(vim.fn.json_decode, line)
              if success and json.executable then
                return json.executable
              end
            end
          end
          
          return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local test_name = vim.fn.input("Test name (optional): ")
          if test_name ~= "" then
            return { test_name }
          end
          return {}
        end,
        env = {
          RUST_LOG = "debug",
          RUST_BACKTRACE = "1",
        },
        console = "integratedTerminal",
        sourceLanguages = { "rust" },
      },
    }
    
    -- =======================================================================
    -- CUSTOM HIGHLIGHTS
    -- =======================================================================
    local highlights = {
      DapBreakpoint = { fg = "#e51400" },
      DapBreakpointCondition = { fg = "#f79000" },
      DapLogPoint = { fg = "#61afef" },
      DapStopped = { fg = "#98c379" },
      DapBreakpointRejected = { fg = "#888888" },
      DapBreakpointLine = { bg = "#2d1b1b" },
      DapBreakpointConditionLine = { bg = "#2d2419" },
      DapLogPointLine = { bg = "#1b252d" },
      DapStoppedLine = { bg = "#1b2d1b" },
      DapBreakpointRejectedLine = { bg = "#1c1c1c" },
    }
    
    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
}
