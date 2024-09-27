-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Disable arrow keys in normal mode
map("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
map("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
map("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
map("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Better escape to normal mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- INSERT BLANK LINES --
--
-- Insert a blank line below in normal mode
map("n", "<Enter>", "o<Esc>", { desc = "Insert a blank line below the cursor" })
-- Insert a blank line above in normal mode
map("n", "<S-Enter>", "O<Esc>", { desc = "Insert a blank line above the cursor" })

-- OPEN FILE LOCATION --
--
-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
end, { desc = "[o]pen file [l]ocation in file explorer" })
