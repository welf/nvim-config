-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- WINDOW NAVIGATION AND RESIZING --
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Resize windows with =, -, +, and _
map("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make the window bigger vertically" })
map("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make the window smaller vertically" })
map("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make the window bigger horizontally" })
map("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make the window smaller horizontally" })
