-- =============================================================================
-- Simple Rust Test Runner
-- =============================================================================
-- Alternative to neotest that works reliably with cargo test
-- Provides visual feedback without the complexity of nextest integration

return {
  "akinsho/toggleterm.nvim",
  optional = true, -- Only if toggleterm is available
  config = function()
    -- Simple test runner functions
    local M = {}
    
    -- Run cargo test with visual output
    function M.run_cargo_test(args)
      args = args or ""
      local cmd = "cargo test " .. args
      
      -- Create a floating terminal for test output
      vim.cmd("split")
      vim.cmd("resize 15")
      vim.cmd("terminal " .. cmd)
      
      -- Enter insert mode to see output immediately
      vim.cmd("startinsert")
      
      -- Set up auto-close after command finishes
      vim.api.nvim_create_autocmd("TermClose", {
        buffer = vim.api.nvim_get_current_buf(),
        callback = function()
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(vim.api.nvim_get_current_buf()) then
              print("Tests completed - press 'q' to close or review output")
            end
          end, 100)
        end,
        once = true,
      })
    end
    
    -- Global access
    _G.SimpleRustTest = M
  end,
}