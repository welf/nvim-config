-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Add keymaps to the Claude AI
map("v", "<leader>Ci", ":'<,'>ClaudeImplement ", { desc = "Claude Implement" })
map("n", "<leader>Cx", ":ClaudeCancel<CR>", { silent = true, desc = "Claude Cancel" })
map("n", "<leader>Cc", ":ClaudeChat<CR>", { silent = true, desc = "Claude Chat" })
-- Delete default Claude keymaps
vim.keymap.del("n", "<leader>cc")
vim.keymap.del("v", "<leader>ci")
vim.keymap.del("n", "<leader>cx")
