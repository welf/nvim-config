-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

local diaglist = require("diaglist")

-- set prefix for Show group
local show_prefix = "<leader>S"
-- set prefix for Inspect group
local inspect_prefix = "<leader>i"

-- INSPECT OR SHOW INFORMATION --
--
-- Show document symbols (<leader>Sd) and workspace symbols (<leader>Sw) are defined in the `lspconfig.lua` file.

-- Inspect AST in a new split window
map("n", inspect_prefix .. "t", ":InspectTree<CR>", { desc = "[i]nspect AST (treesitter)" })
-- Inspect highlight group under cursor
map("n", inspect_prefix .. "h", ":Inspect<CR>", { desc = "[i]nspect  [h]ighlight group under cursor" })
-- Inspect document symbols (raw JSON from LSP server only)
map("n", inspect_prefix .. "s", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP client attached to current buffer", vim.log.levels.WARN)
    return
  end

  -- Use the first LSP client that supports document symbols
  local client = clients[1]
  for _, c in ipairs(clients) do
    if c:supports_method("textDocument/documentSymbol") then
      client = c
      break
    end
  end

  if not client:supports_method("textDocument/documentSymbol") then
    vim.notify("LSP client doesn't support document symbols", vim.log.levels.WARN)
    return
  end

  client:request("textDocument/documentSymbol", vim.lsp.util.make_position_params(0, client.offset_encoding), function(err, result)
    if err then
      vim.notify("LSP Error: " .. vim.json.encode(err), vim.log.levels.ERROR)
      return
    end

    -- Format and copy JSON content to clipboard
    local json_content = vim.fn.json_encode(result)
    -- Pretty format the JSON by decoding and re-encoding with jq if available, otherwise use as-is
    local formatted_json = json_content
    if vim.fn.executable("jq") == 1 then
      local handle = io.popen("echo '" .. json_content:gsub("'", "'\\''") .. "' | jq .")
      if handle then
        local result_jq = handle:read("*a")
        handle:close()
        if result_jq and result_jq ~= "" then
          formatted_json = result_jq:gsub("\n$", "") -- Remove trailing newline
        end
      end
    end
    vim.fn.setreg("+", formatted_json)
    vim.notify("Document symbols JSON copied to clipboard", vim.log.levels.INFO)
  end, 0)
end, { desc = "[i]nspect document [s]ymbols (raw JSON from LSP)" })

-- Inspect workspace symbols (raw JSON from LSP server only)
map("n", inspect_prefix .. "S", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP client attached to current buffer", vim.log.levels.WARN)
    return
  end

  -- Use the first LSP client that supports workspace symbols
  local client = clients[1]
  for _, c in ipairs(clients) do
    if c:supports_method("workspace/symbol") then
      client = c
      break
    end
  end

  if not client:supports_method("workspace/symbol") then
    vim.notify("LSP client doesn't support workspace symbols", vim.log.levels.WARN)
    return
  end

  -- Request workspace symbols with empty query to get all symbols
  client:request("workspace/symbol", { query = "" }, function(err, result)
    if err then
      vim.notify("LSP Error: " .. vim.json.encode(err), vim.log.levels.ERROR)
      return
    end

    -- Format and copy JSON content to clipboard
    local json_content = vim.fn.json_encode(result)
    -- Pretty format the JSON by decoding and re-encoding with jq if available, otherwise use as-is
    local formatted_json = json_content
    if vim.fn.executable("jq") == 1 then
      local handle = io.popen("echo '" .. json_content:gsub("'", "'\\''") .. "' | jq .")
      if handle then
        local result_jq = handle:read("*a")
        handle:close()
        if result_jq and result_jq ~= "" then
          formatted_json = result_jq:gsub("\n$", "") -- Remove trailing newline
        end
      end
    end
    vim.fn.setreg("+", formatted_json)
    vim.notify("Workspace symbols JSON copied to clipboard", vim.log.levels.INFO)
  end, 0)
end, { desc = "[i]nspect workspace [S]ymbols (raw JSON from LSP)" })

-- Diagnostic keymaps
map("n", show_prefix .. "q", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [q]uickfix list" })
-- Show web-devicons
map("n", show_prefix .. "i", ":NvimWebDeviconsHiTest<CR>", { desc = "[S]how web-dev[i]cons" })
-- Show LSP output panel
map("n", show_prefix .. "o", ":OutputPanel<CR>", { desc = "[S]how LSP [o]utput panel" })
-- Show LSP diagnostics
map("n", show_prefix .. "db", diaglist.open_buffer_diagnostics, { desc = "[S]how [d]iagnostics for [b]uffer" })
