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

-- Diagnostic keymaps
map("n", show_prefix .. "q", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [q]uickfix list" })
-- Show web-devicons
map("n", show_prefix .. "i", ":NvimWebDeviconsHiTest<CR>", { desc = "[S]how web-dev[i]cons" })
-- Show LSP diagnostics
map("n", show_prefix .. "db", diaglist.open_buffer_diagnostics, { desc = "[S]how [d]iagnostics for [b]uffer" })
map("n", show_prefix .. "dw", diaglist.open_all_diagnostics, { desc = "[S]how [d]iagnostics for [w]orkspace" })
