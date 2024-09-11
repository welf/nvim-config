-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<ESC>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostic keymaps
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
map("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
map("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
map("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Better escape to normal mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
end, { desc = "[O]pen file [L]ocation in file explorer" })

-- Select all content of the file (Ctrl-a)
map("n", "<C-a>", "gg0vG$", { desc = "Select [A]ll" })

-- Move lines up/down
map("n", "<A-Down>", ":m .+1<CR>", { desc = "Move line down" })
map("n", "<A-j>", ":m .+1<CR>", { desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>", { desc = "Move line up" })
map("n", "<A-k>", ":m .-2<CR>", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- treesitter inspect
map("n", "<leader>it", ":InspectTree<CR>", { desc = "Show the highlight groups under the cursor (tresitter)" })
map("n", "<leader>ii", ":Inspect<CR>", { desc = "Show the parsed syntax tree (treesitter)" })

-- folds
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

-- Terminal keymaps
map("n", "<A-i>", ":FTermToggle<CR>", { desc = "Toggle Terminal" })
map("v", "<A-i>", ":FTermToggle<CR>", { desc = "Toggle Terminal" })
map("t", "<A-i>", "<C-\\><C-n>:FTermToggle<CR>", { desc = "Toggle Terminal" })
map("n", "<A-o>", ":FTermOpen<CR>", { desc = "Open Terminal" })
map("v", "<A-o>", ":FTermOpen<CR>", { desc = "Open Terminal" })
map("t", "<A-w>", "<C-\\><C-n>:FTermClose<CR>", { desc = "Close Terminal but preserve terminal session" })
map("t", "<A-e>", "<C-\\><C-n>:FTermExit<CR>", { desc = "Exit Terminal and remove terminal session" })

-- Toggle LSP inline end hints on and off
map("n", "<leader>th", require("lsp-endhints").toggle, { desc = "[T]oggle inlay [H]ints" })
map("v", "<leader>th", require("lsp-endhints").toggle, { desc = "[T]oggle inlay [H]ints" })

-- -- Scroll in command line suggestions with Ctrl-j and Ctrl-k
-- vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
--   if not require("noice.lsp").scroll(4) then
--     return "<c-j>"
--   end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
--   if not require("noice.lsp").scroll(-4) then
--     return "<c-k>"
--   end
-- end, { silent = true, expr = true })
