-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set
map("i", "<%", "<% %><Esc>2hi", { noremap = true, silent = true })
