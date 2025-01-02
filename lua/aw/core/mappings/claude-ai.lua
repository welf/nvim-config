-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Add keymaps to the Claude AI
-- map("v", "<leader>aI", ":'<,'>ClaudeImplement ", { desc = "[I]mplement with Claude AI" })
-- map("n", "<leader>ax", ":ClaudeCancel<CR>", { silent = true, desc = "Cancel Claude AI prompt" })
-- map("n", "<leader>aC", ":ClaudeChat<CR>", { silent = true, desc = "[C]hat with Claude AI" })
-- Delete default Claude keymaps
-- vim.keymap.del("n", "<leader>cc")
-- vim.keymap.del("v", "<leader>ci")
-- vim.keymap.del("n", "<leader>cx")
