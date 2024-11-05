-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- WINDOW NAVIGATION AND RESIZING --
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move focus to the left window" })
map("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move focus to the right window" })
map("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move focus to the lower window" })
map("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move focus to the upper window" })
-- Resize windows with ALT+<hjkl>
map("n", "<A-l>", require("smart-splits").resize_right, { desc = "Increase window width" })
map("n", "<A-h>", require("smart-splits").resize_left, { desc = "Decrease window width" })
map("n", "<A-k>", require("smart-splits").resize_up, { desc = "Increase window height" })
map("n", "<A-j>", require("smart-splits").resize_down, { desc = "Decrease window height" })
