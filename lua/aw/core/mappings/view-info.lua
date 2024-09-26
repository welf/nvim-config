-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- VIEW INFORMATION --
--
-- View document symbols (<leader>Vd) and workspace symbols (<leader>Vw) are defined in the `lspconfig.lua` file.
-- Inspect cursor position.
map("n", "<leader>Vi", ":Inspect<CR>", { desc = "[i]nspect cursor position" })
