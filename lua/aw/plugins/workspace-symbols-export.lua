-- =============================================================================
-- Workspace Symbols Export
-- =============================================================================
-- Export LSP workspace symbols to documentation file
-- Features: Symbol querying, filtering, formatting, git root detection

local M = {}

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

--- Find the nearest git root directory
---@return string|nil
local function find_git_root()
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = vim.fn.system("cd " .. vim.fn.shellescape(current_dir) .. " && git rev-parse --show-toplevel 2>/dev/null")
  
  if vim.v.shell_error == 0 then
    return vim.trim(git_root)
  end
  
  -- Fallback: search upward for .git directory
  local path = current_dir
  while path ~= "/" do
    if vim.fn.isdirectory(path .. "/.git") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  
  return nil
end

--- Get symbol kind name from LSP symbol kind number
---@param kind number
---@return string
local function get_symbol_kind_name(kind)
  local symbol_kinds = {
    [1] = "File",
    [2] = "Module",
    [3] = "Namespace",
    [4] = "Package",
    [5] = "Class",
    [6] = "Method",
    [7] = "Property",
    [8] = "Field",
    [9] = "Constructor",
    [10] = "Enum",
    [11] = "Interface",
    [12] = "Function",
    [13] = "Variable",
    [14] = "Constant",
    [15] = "String",
    [16] = "Number",
    [17] = "Boolean",
    [18] = "Array",
    [19] = "Object",
    [20] = "Key",
    [21] = "Null",
    [22] = "EnumMember",
    [23] = "Struct",
    [24] = "Event",
    [25] = "Operator",
    [26] = "TypeParameter",
  }
  
  return symbol_kinds[kind] or "Unknown"
end

--- Format symbol location for display
---@param location table LSP location object
---@param git_root string Git root path
---@return string
local function format_location(location, git_root)
  local uri = location.uri
  local path = vim.uri_to_fname(uri)
  
  -- Make path relative to git root
  if git_root and path:find(git_root, 1, true) == 1 then
    path = path:sub(#git_root + 2) -- +2 to remove leading slash
  end
  
  local line = location.range.start.line + 1 -- LSP is 0-indexed
  local col = location.range.start.character + 1
  
  return string.format("%s:%d:%d", path, line, col)
end

--- Sort symbols by kind, then by name
---@param symbols table List of workspace symbols
---@return table Sorted symbols
local function sort_symbols(symbols)
  table.sort(symbols, function(a, b)
    if a.kind ~= b.kind then
      return a.kind < b.kind
    end
    return a.name < b.name
  end)
  return symbols
end

--- Filter symbols based on configuration
---@param symbols table List of workspace symbols
---@param filter_config table Filter configuration
---@return table Filtered symbols
local function filter_symbols(symbols, filter_config)
  if not filter_config then
    return symbols
  end
  
  local filtered = {}
  
  for _, symbol in ipairs(symbols) do
    local include = true
    
    -- Filter by kind
    if filter_config.exclude_kinds then
      local kind_name = get_symbol_kind_name(symbol.kind)
      if vim.tbl_contains(filter_config.exclude_kinds, kind_name) then
        include = false
      end
    end
    
    -- Filter by name pattern
    if include and filter_config.name_pattern then
      if not symbol.name:match(filter_config.name_pattern) then
        include = false
      end
    end
    
    -- Filter by file pattern
    if include and filter_config.file_pattern then
      local location = symbol.location
      local path = vim.uri_to_fname(location.uri)
      if not path:match(filter_config.file_pattern) then
        include = false
      end
    end
    
    -- Exclude test files
    if include and filter_config.exclude_tests then
      local path = vim.uri_to_fname(symbol.location.uri)
      if path:match("/test") or path:match("_test%.") or path:match("/tests/") then
        include = false
      end
    end
    
    if include then
      table.insert(filtered, symbol)
    end
  end
  
  return filtered
end

--- Generate symbol documentation content
---@param symbols table List of workspace symbols
---@param git_root string Git root path
---@param config table Configuration options
---@return table Lines of documentation
local function generate_documentation(symbols, git_root, config)
  local lines = {}
  
  -- Header
  table.insert(lines, "# Workspace Symbols")
  table.insert(lines, "")
  table.insert(lines, "Generated on: " .. os.date("%Y-%m-%d %H:%M:%S"))
  table.insert(lines, "Total symbols: " .. #symbols)
  table.insert(lines, "")
  
  -- Group symbols by kind
  local symbols_by_kind = {}
  for _, symbol in ipairs(symbols) do
    local kind = get_symbol_kind_name(symbol.kind)
    if not symbols_by_kind[kind] then
      symbols_by_kind[kind] = {}
    end
    table.insert(symbols_by_kind[kind], symbol)
  end
  
  -- Sort kinds
  local sorted_kinds = {}
  for kind, _ in pairs(symbols_by_kind) do
    table.insert(sorted_kinds, kind)
  end
  table.sort(sorted_kinds)
  
  -- Generate content for each kind
  for _, kind in ipairs(sorted_kinds) do
    local kind_symbols = symbols_by_kind[kind]
    
    -- Sort symbols within kind
    table.sort(kind_symbols, function(a, b)
      return a.name < b.name
    end)
    
    -- Kind header
    table.insert(lines, "## " .. kind .. " (" .. #kind_symbols .. ")")
    table.insert(lines, "")
    
    if config.format == "table" then
      -- Table format
      table.insert(lines, "| Name | Location | Container |")
      table.insert(lines, "|------|----------|-----------|")
      
      for _, symbol in ipairs(kind_symbols) do
        local location = format_location(symbol.location, git_root)
        local container = symbol.containerName or ""
        local name = symbol.name
        
        -- Escape markdown table characters
        name = name:gsub("|", "\\|")
        container = container:gsub("|", "\\|")
        location = location:gsub("|", "\\|")
        
        table.insert(lines, string.format("| `%s` | %s | %s |", name, location, container))
      end
    else
      -- List format
      for _, symbol in ipairs(kind_symbols) do
        local location = format_location(symbol.location, git_root)
        local container = symbol.containerName and (" (" .. symbol.containerName .. ")") or ""
        
        table.insert(lines, string.format("- **%s**%s - %s", symbol.name, container, location))
      end
    end
    
    table.insert(lines, "")
  end
  
  -- Statistics
  table.insert(lines, "---")
  table.insert(lines, "")
  table.insert(lines, "## Statistics")
  table.insert(lines, "")
  
  for _, kind in ipairs(sorted_kinds) do
    local count = #symbols_by_kind[kind]
    table.insert(lines, string.format("- %s: %d", kind, count))
  end
  
  return lines
end

-- =============================================================================
-- MAIN EXPORT FUNCTION
-- =============================================================================

--- Export workspace symbols to documentation file
---@param opts table Configuration options
local function export_workspace_symbols(opts)
  opts = opts or {}
  
  -- Find git root
  local git_root = find_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end
  
  -- Get LSP clients
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local active_client = nil
  
  -- Debug: Show all available clients
  vim.notify("Available LSP clients:", vim.log.levels.INFO)
  for _, client in ipairs(clients) do
    local has_workspace_symbols = client.server_capabilities.workspaceSymbolProvider ~= nil
    vim.notify(string.format("  - %s (workspace symbols: %s)", client.name, tostring(has_workspace_symbols)), vim.log.levels.INFO)
    
    if has_workspace_symbols then
      active_client = client
    end
  end
  
  if not active_client then
    vim.notify("No LSP client with workspace symbol support found. Available clients: " .. 
      table.concat(vim.tbl_map(function(c) return c.name end, clients), ", "), vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Using LSP client: " .. active_client.name, vim.log.levels.INFO)
  vim.notify("Querying workspace symbols...", vim.log.levels.INFO)
  
  -- Query workspace symbols with multiple strategies
  local queries_to_try = {
    "", -- Empty query (should return all symbols)
    "fn", -- Functions
    "struct", -- Structs
    "impl", -- Implementations
    "mod", -- Modules
  }
  
  local function try_query(query_index)
    if query_index > #queries_to_try then
      vim.notify("No symbols found with any query strategy", vim.log.levels.WARN)
      return
    end
    
    local query = opts.query or queries_to_try[query_index]
    local params = { query = query }
    
    vim.notify(string.format("Trying query: '%s' (%d/%d)", query, query_index, #queries_to_try), vim.log.levels.INFO)
    
    active_client.request("workspace/symbol", params, function(err, result)
      if err then
        vim.notify("Error querying workspace symbols: " .. err.message, vim.log.levels.ERROR)
        return
      end
      
      vim.notify(string.format("Query '%s' returned %d symbols", query, result and #result or 0), vim.log.levels.INFO)
      
      if not result or #result == 0 then
        -- Try next query if this one failed
        if not opts.query then -- Only try multiple queries if user didn't specify one
          try_query(query_index + 1)
          return
        else
          vim.notify("No workspace symbols found for query: " .. query, vim.log.levels.WARN)
          return
        end
      end
      
      -- Filter symbols
      local filter_config = opts.filter or {
        exclude_tests = true,
        exclude_kinds = { "File", "String", "Number", "Boolean" }
      }
      
      local filtered_symbols = filter_symbols(result, filter_config)
      local sorted_symbols = sort_symbols(filtered_symbols)
      
      vim.notify(string.format("After filtering: %d symbols remaining", #sorted_symbols), vim.log.levels.INFO)
      
      -- Generate documentation
      local doc_config = {
        format = opts.format or "list" -- "list" or "table"
      }
      
      local lines = generate_documentation(sorted_symbols, git_root, doc_config)
      
      -- Write to file
      local docs_dir = git_root .. "/docs"
      local output_file = opts.output_file or "workspace_symbols.md"
      local full_path = docs_dir .. "/" .. output_file
      
      -- Create docs directory if it doesn't exist
      vim.fn.mkdir(docs_dir, "p")
      
      -- Write file
      local success = pcall(vim.fn.writefile, lines, full_path)
      if success then
        vim.notify(string.format("Exported %d symbols to %s", #sorted_symbols, full_path), vim.log.levels.INFO)
        
        -- Optionally open the file
        if opts.open_file then
          vim.cmd("edit " .. full_path)
        end
      else
        vim.notify("Failed to write symbols file", vim.log.levels.ERROR)
      end
    end)
  end
  
  -- Start with the first query
  try_query(1)
end

-- =============================================================================
-- INTERACTIVE EXPORT FUNCTION
-- =============================================================================

--- Interactive export with user options
local function interactive_export()
  -- Get format preference
  vim.ui.select({"list", "table"}, {
    prompt = "Select output format:",
    format_item = function(item)
      if item == "list" then
        return "List format (markdown list)"
      else
        return "Table format (markdown table)"
      end
    end,
  }, function(format)
    if not format then return end
    
    -- Get filter options
    local exclude_tests = vim.fn.confirm("Exclude test files?", "&Yes\n&No", 1) == 1
    local exclude_private = vim.fn.confirm("Exclude private symbols?", "&Yes\n&No", 2) == 1
    
    -- Get query string
    local query = vim.fn.input("Symbol query (empty for all): ")
    
    -- Get output filename
    local output_file = vim.fn.input("Output filename: ", "workspace_symbols.md")
    if output_file == "" then
      output_file = "workspace_symbols.md"
    end
    
    -- Build filter config
    local filter_config = {
      exclude_tests = exclude_tests,
      exclude_kinds = { "File", "String", "Number", "Boolean" }
    }
    
    if exclude_private then
      vim.list_extend(filter_config.exclude_kinds, { "Variable" })
    end
    
    -- Export with options
    export_workspace_symbols({
      query = query,
      format = format,
      output_file = output_file,
      filter = filter_config,
      open_file = true,
    })
  end)
end

-- =============================================================================
-- LANGUAGE-SPECIFIC EXPORTS
-- =============================================================================

--- Export Rust-specific symbols
local function export_rust_symbols()
  export_workspace_symbols({
    query = "",
    format = "table",
    output_file = "rust_symbols.md",
    filter = {
      exclude_tests = true,
      exclude_kinds = { "File", "String", "Number", "Boolean", "Variable" },
      file_pattern = "%.rs$", -- Only Rust files
    },
    open_file = true,
  })
end

--- Export public API symbols only
local function export_public_api()
  export_workspace_symbols({
    query = "",
    format = "table",
    output_file = "public_api.md",
    filter = {
      exclude_tests = true,
      exclude_kinds = { "File", "String", "Number", "Boolean", "Variable", "Property" },
      name_pattern = "^[A-Z]", -- Only symbols starting with capital letter (likely public)
    },
    open_file = true,
  })
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

--- Debug LSP workspace symbol capabilities
local function debug_lsp_workspace_symbols()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  
  print("=== LSP Workspace Symbol Debug ===")
  print("Number of LSP clients: " .. #clients)
  
  for i, client in ipairs(clients) do
    print(string.format("\nClient %d: %s", i, client.name))
    print("  Server capabilities:")
    if client.server_capabilities then
      print("    workspaceSymbolProvider: " .. tostring(client.server_capabilities.workspaceSymbolProvider))
      print("    workspace: " .. tostring(client.server_capabilities.workspace ~= nil))
      if client.server_capabilities.workspace then
        print("      symbol: " .. tostring(client.server_capabilities.workspace.symbol ~= nil))
      end
    else
      print("    No server capabilities found")
    end
    
    -- Test a simple query
    if client.server_capabilities.workspaceSymbolProvider then
      print("  Testing workspace symbol query...")
      client.request("workspace/symbol", { query = "" }, function(err, result)
        if err then
          print("    Error: " .. err.message)
        else
          print(string.format("    Success: returned %d symbols", result and #result or 0))
          if result and #result > 0 then
            print("    Sample symbols:")
            for j = 1, math.min(3, #result) do
              local symbol = result[j]
              print(string.format("      - %s (%s)", symbol.name, get_symbol_kind_name(symbol.kind)))
            end
          end
        end
      end)
    end
  end
  
  -- Also check current buffer
  print("\nCurrent buffer info:")
  print("  File: " .. vim.fn.expand("%:p"))
  print("  Filetype: " .. vim.bo.filetype)
  print("  LSP attached: " .. tostring(#clients > 0))
end

function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command("WorkspaceSymbolsExport", function(opts)
    if opts.bang then
      interactive_export()
    else
      export_workspace_symbols()
    end
  end, {
    bang = true,
    desc = "Export workspace symbols to docs/workspace_symbols.md (use ! for interactive)"
  })
  
  vim.api.nvim_create_user_command("RustSymbolsExport", export_rust_symbols, {
    desc = "Export Rust symbols to docs/rust_symbols.md"
  })
  
  vim.api.nvim_create_user_command("PublicApiExport", export_public_api, {
    desc = "Export public API symbols to docs/public_api.md"
  })
  
  vim.api.nvim_create_user_command("DebugWorkspaceSymbols", debug_lsp_workspace_symbols, {
    desc = "Debug LSP workspace symbol capabilities"
  })
  
  -- Create keymappings
  local map = vim.keymap.set
  map("n", "<leader>rse", "<cmd>WorkspaceSymbolsExport<cr>", { desc = "Export workspace symbols" })
  map("n", "<leader>rsi", "<cmd>WorkspaceSymbolsExport!<cr>", { desc = "Interactive symbol export" })
  map("n", "<leader>rsr", "<cmd>RustSymbolsExport<cr>", { desc = "Export Rust symbols" })
  map("n", "<leader>rsp", "<cmd>PublicApiExport<cr>", { desc = "Export public API" })
end

-- =============================================================================
-- KEYMAP SETUP
-- =============================================================================

-- Initialize the plugin immediately
M.setup()

-- Return empty table to avoid lazy.nvim trying to manage this as an external plugin
return {}