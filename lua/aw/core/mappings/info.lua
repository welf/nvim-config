-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- INSPECT OR SHOW INFORMATION --
--
-- Show document symbols (<leader>Sd) and workspace symbols (<leader>Sw) are defined in the `lspconfig.lua` file.

-- Inspect AST in a new split window
map("n", "<leader>it", ":InspectTree<CR>", { desc = "[i]nspect AST (treesitter)" })
-- Inspect highlight group under cursor
map("n", "<leader>ih", ":Inspect<CR>", { desc = "[i]nspect  [h]ighlight group under cursor" })

-- Diagnostic keymaps
map("n", "<leader>Sq", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [q]uickfix list" })

-- Show web-devicons
map("n", "<leader>Si", ":NvimWebDeviconsHiTest<CR>", { desc = "[S]how web-dev[i]cons" })
