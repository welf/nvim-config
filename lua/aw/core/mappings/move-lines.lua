-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Move lines up/down
map("n", "<A-Down>", ":m .+1<CR>", { desc = "Move line down" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>", { desc = "Move line up" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

map("n", "<A-J>", ":m .+1<CR>", { desc = "Move line down" })
map("v", "<A-J>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("i", "<A-J>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("n", "<A-K>", ":m .-2<CR>", { desc = "Move line up" })
map("v", "<A-K>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
