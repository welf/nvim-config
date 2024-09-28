-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- WINDOW NAVIGATION AND RESIZING --
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
-- Resize windows with ALT+<hjkl>
map("n", "<A-l>", [[<cmd>vertical resize +1<cr>]], { desc = "Increase window width" })
map("n", "<A-h>", [[<cmd>vertical resize -1<cr>]], { desc = "Decrease window width" })
map("n", "<A-k>", [[<cmd>horizontal resize +1<cr>]], { desc = "Increase window height" })
map("n", "<A-j>", [[<cmd>horizontal resize -1<cr>]], { desc = "Decrease window height" })
