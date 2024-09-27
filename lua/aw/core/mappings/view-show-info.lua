-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- VIEW OR SHOW INFORMATION --
--
-- Show document symbols (<leader>Sd) and workspace symbols (<leader>Sw) are defined in the `lspconfig.lua` file.
-- Inspect cursor position.
map("n", "<leader>ic", ":Inspect<CR>", { desc = "[i]nspect [c]ursor position" })

-- Diagnostic keymaps
map("n", "<leader>Sq", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [q]uickfix list" })
