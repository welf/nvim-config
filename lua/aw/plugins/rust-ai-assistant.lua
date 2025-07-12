-- =============================================================================
-- Rust AI Assistant Configuration
-- =============================================================================
-- Enhanced AI integration with Rust-specific context and prompts
-- Features: Context-aware prompts, error explanations, code suggestions

local M = {}

-- =============================================================================
-- RUST CONTEXT GATHERING
-- =============================================================================

--- Get current Rust project context
---@return table
local function get_rust_context()
  local context = {}
  
  -- Get current file info
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.expand("%:p:h")
  
  -- Find Cargo.toml
  local cargo_toml = vim.fn.findfile("Cargo.toml", current_dir .. ";")
  if cargo_toml ~= "" then
    context.cargo_toml = cargo_toml
    context.project_root = vim.fn.fnamemodify(cargo_toml, ":h")
    
    -- Read Cargo.toml for dependencies
    local cargo_content = vim.fn.readfile(cargo_toml)
    context.dependencies = {}
    local in_dependencies = false
    
    for _, line in ipairs(cargo_content) do
      if line:match("^%[dependencies%]") then
        in_dependencies = true
      elseif line:match("^%[.*%]") then
        in_dependencies = false
      elseif in_dependencies and line:match("^%w+") then
        local dep = line:match("^(%w+)")
        if dep then
          table.insert(context.dependencies, dep)
        end
      end
    end
  end
  
  -- Get current function context
  local current_line = vim.fn.line(".")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Find current function
  for i = current_line, 1, -1 do
    local line = lines[i]
    if line and line:match("^%s*fn%s+") then
      context.current_function = line:match("fn%s+([%w_]+)")
      break
    end
  end
  
  -- Get current struct/impl context
  for i = current_line, 1, -1 do
    local line = lines[i]
    if line and line:match("^%s*struct%s+") then
      context.current_struct = line:match("struct%s+([%w_]+)")
      break
    elseif line and line:match("^%s*impl%s+") then
      context.current_impl = line:match("impl%s+([%w_<>]+)")
      break
    end
  end
  
  -- Get imports/uses
  context.imports = {}
  for _, line in ipairs(lines) do
    if line:match("^use%s+") then
      table.insert(context.imports, line:match("use%s+([^;]+)"))
    end
  end
  
  return context
end

--- Get Rust-specific diagnostics
---@return table
local function get_rust_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local rust_diagnostics = {}
  
  for _, diag in ipairs(diagnostics) do
    if diag.source == "rust-analyzer" or diag.source == "rustc" then
      table.insert(rust_diagnostics, {
        line = diag.lnum + 1,
        col = diag.col + 1,
        message = diag.message,
        severity = diag.severity,
        code = diag.code,
      })
    end
  end
  
  return rust_diagnostics
end

--- Get current selection or word under cursor
---@return string
local function get_current_selection()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- Visual mode - get selected text
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    
    if #lines == 1 then
      return lines[1]:sub(start_pos[3], end_pos[3])
    else
      lines[1] = lines[1]:sub(start_pos[3])
      lines[#lines] = lines[#lines]:sub(1, end_pos[3])
      return table.concat(lines, "\n")
    end
  else
    -- Normal mode - get word under cursor
    return vim.fn.expand("<cword>")
  end
end

-- =============================================================================
-- CONTEXT-AWARE PROMPTS
-- =============================================================================

--- Generate context-aware Rust prompt
---@param prompt_type string
---@param user_input string
---@return string
local function generate_rust_prompt(prompt_type, user_input)
  local context = get_rust_context()
  local diagnostics = get_rust_diagnostics()
  local selection = get_current_selection()
  
  local prompt_parts = {}
  
  -- Add context header
  table.insert(prompt_parts, "# Rust Development Context")
  
  if context.project_root then
    table.insert(prompt_parts, "**Project Root:** " .. context.project_root)
  end
  
  if context.dependencies and #context.dependencies > 0 then
    table.insert(prompt_parts, "**Dependencies:** " .. table.concat(context.dependencies, ", "))
  end
  
  if context.current_function then
    table.insert(prompt_parts, "**Current Function:** " .. context.current_function)
  end
  
  if context.current_struct then
    table.insert(prompt_parts, "**Current Struct:** " .. context.current_struct)
  end
  
  if context.current_impl then
    table.insert(prompt_parts, "**Current Impl:** " .. context.current_impl)
  end
  
  if context.imports and #context.imports > 0 then
    table.insert(prompt_parts, "**Imports:** " .. table.concat(context.imports, ", "))
  end
  
  -- Add diagnostics if any
  if #diagnostics > 0 then
    table.insert(prompt_parts, "\n## Current Diagnostics:")
    for _, diag in ipairs(diagnostics) do
      table.insert(prompt_parts, string.format("- Line %d: %s", diag.line, diag.message))
    end
  end
  
  -- Add selection if any
  if selection and selection ~= "" then
    table.insert(prompt_parts, "\n## Selected Code:")
    table.insert(prompt_parts, "```rust")
    table.insert(prompt_parts, selection)
    table.insert(prompt_parts, "```")
  end
  
  -- Add prompt-specific content
  table.insert(prompt_parts, "\n## Request:")
  
  if prompt_type == "error_explanation" then
    table.insert(prompt_parts, "Please explain the Rust errors/warnings above and provide solutions. Focus on:")
    table.insert(prompt_parts, "1. Root cause of each error")
    table.insert(prompt_parts, "2. Step-by-step fix instructions")
    table.insert(prompt_parts, "3. Best practices to avoid similar issues")
  elseif prompt_type == "code_review" then
    table.insert(prompt_parts, "Please review this Rust code and provide feedback on:")
    table.insert(prompt_parts, "1. Code quality and idioms")
    table.insert(prompt_parts, "2. Performance considerations")
    table.insert(prompt_parts, "3. Safety and error handling")
    table.insert(prompt_parts, "4. Suggested improvements")
  elseif prompt_type == "refactor" then
    table.insert(prompt_parts, "Please suggest refactoring improvements for this Rust code:")
    table.insert(prompt_parts, "1. Better abstractions")
    table.insert(prompt_parts, "2. Performance optimizations")
    table.insert(prompt_parts, "3. Code organization")
    table.insert(prompt_parts, "4. Error handling improvements")
  elseif prompt_type == "test_generation" then
    table.insert(prompt_parts, "Please generate comprehensive tests for this Rust code:")
    table.insert(prompt_parts, "1. Unit tests for all functions")
    table.insert(prompt_parts, "2. Edge case testing")
    table.insert(prompt_parts, "3. Integration tests if applicable")
    table.insert(prompt_parts, "4. Property-based tests where suitable")
  elseif prompt_type == "documentation" then
    table.insert(prompt_parts, "Please generate documentation for this Rust code:")
    table.insert(prompt_parts, "1. Comprehensive doc comments")
    table.insert(prompt_parts, "2. Usage examples")
    table.insert(prompt_parts, "3. Error conditions")
    table.insert(prompt_parts, "4. Safety considerations")
  else
    table.insert(prompt_parts, user_input)
  end
  
  if user_input and user_input ~= "" then
    table.insert(prompt_parts, "\n**Additional Context:** " .. user_input)
  end
  
  table.insert(prompt_parts, "\nPlease provide practical, actionable advice specific to Rust development.")
  
  return table.concat(prompt_parts, "\n")
end

-- =============================================================================
-- CLAUDE CODE INTEGRATION
-- =============================================================================

--- Send context-aware prompt to Claude Code
---@param prompt_type string
---@param user_input string
local function send_to_claude(prompt_type, user_input)
  local prompt = generate_rust_prompt(prompt_type, user_input)
  
  -- Create temporary file with prompt
  local temp_file = vim.fn.tempname()
  vim.fn.writefile(vim.split(prompt, "\n"), temp_file)
  
  -- Open Claude Code with the prompt
  local claude_code = require("claude-code")
  if claude_code then
    -- If claude-code plugin is available, use it
    vim.cmd("ClaudeCode")
    vim.defer_fn(function()
      vim.cmd("edit " .. temp_file)
    end, 100)
  else
    -- Fallback to terminal
    vim.cmd("split | resize 20")
    vim.cmd("terminal claude < " .. temp_file)
  end
end

-- =============================================================================
-- USER COMMANDS
-- =============================================================================

--- Explain Rust errors with AI
local function explain_rust_errors()
  local diagnostics = get_rust_diagnostics()
  if #diagnostics == 0 then
    vim.notify("No Rust errors or warnings found", vim.log.levels.INFO)
    return
  end
  
  send_to_claude("error_explanation", "")
end

--- Get AI code review for current selection or buffer
local function rust_code_review()
  local selection = get_current_selection()
  if not selection or selection == "" then
    vim.notify("Please select code to review", vim.log.levels.WARN)
    return
  end
  
  send_to_claude("code_review", "")
end

--- Get refactoring suggestions
local function rust_refactor_suggestions()
  local selection = get_current_selection()
  if not selection or selection == "" then
    vim.notify("Please select code to refactor", vim.log.levels.WARN)
    return
  end
  
  send_to_claude("refactor", "")
end

--- Generate tests for current code
local function rust_generate_tests()
  local selection = get_current_selection()
  if not selection or selection == "" then
    vim.notify("Please select code to generate tests for", vim.log.levels.WARN)
    return
  end
  
  send_to_claude("test_generation", "")
end

--- Generate documentation
local function rust_generate_docs()
  local selection = get_current_selection()
  if not selection or selection == "" then
    vim.notify("Please select code to document", vim.log.levels.WARN)
    return
  end
  
  send_to_claude("documentation", "")
end

--- Custom prompt with context
local function rust_custom_prompt()
  local input = vim.fn.input("Rust AI Assistant: ")
  if input and input ~= "" then
    send_to_claude("custom", input)
  end
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command("RustExplainErrors", explain_rust_errors, {
    desc = "Explain Rust errors with AI"
  })
  
  vim.api.nvim_create_user_command("RustCodeReview", rust_code_review, {
    desc = "Get AI code review for Rust code"
  })
  
  vim.api.nvim_create_user_command("RustRefactor", rust_refactor_suggestions, {
    desc = "Get refactoring suggestions"
  })
  
  vim.api.nvim_create_user_command("RustGenerateTests", rust_generate_tests, {
    desc = "Generate tests for Rust code"
  })
  
  vim.api.nvim_create_user_command("RustGenerateDocs", rust_generate_docs, {
    desc = "Generate documentation for Rust code"
  })
  
  vim.api.nvim_create_user_command("RustAI", rust_custom_prompt, {
    desc = "Custom Rust AI prompt with context"
  })
end

return {
  "dummy/rust-ai-assistant", -- Placeholder plugin name
  dir = vim.fn.stdpath("config") .. "/lua/aw/plugins/",
  config = function()
    require("aw.plugins.rust-ai-assistant").setup()
  end,
  
  -- Keymappings using <leader>ra* prefix (rust + ai)
  keys = {
    -- Error explanation
    { "<leader>rae", "<cmd>RustExplainErrors<cr>", desc = "Explain Rust errors with AI", ft = "rust" },
    
    -- Code review
    { "<leader>rar", "<cmd>RustCodeReview<cr>", desc = "AI code review", ft = "rust", mode = { "n", "v" } },
    
    -- Refactoring
    { "<leader>raf", "<cmd>RustRefactor<cr>", desc = "AI refactoring suggestions", ft = "rust", mode = { "n", "v" } },
    
    -- Test generation
    { "<leader>rat", "<cmd>RustGenerateTests<cr>", desc = "Generate tests with AI", ft = "rust", mode = { "n", "v" } },
    
    -- Documentation
    { "<leader>rad", "<cmd>RustGenerateDocs<cr>", desc = "Generate docs with AI", ft = "rust", mode = { "n", "v" } },
    
    -- Custom prompt
    { "<leader>raa", "<cmd>RustAI<cr>", desc = "Custom Rust AI prompt", ft = "rust" },
  },
}