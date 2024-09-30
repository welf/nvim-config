-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Move lines up/down
map("n", "<A-S-Down>", ":m .+1<CR>", { desc = "Move line down" })
map("v", "<A-S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("i", "<A-S-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("n", "<A-S-Up>", ":m .-2<CR>", { desc = "Move line up" })
map("v", "<A-S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("i", "<A-S-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
