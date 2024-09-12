-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<ESC>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostic keymaps
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Dismiss notify popups with <Esc>
map("n", "<Esc>", function()
  require("notify").dismiss()
end, { desc = "Dismiss notify popup and clear hlsearch" })

-- Toggle symbols outline window
map("n", "<leader>to", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

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

-- Resize windows with =, -, +, and _
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make the window bigger vertically" })
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make the window smaller vertically" })
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make the window bigger horizontally" })
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make the window smaller horizontally" })

-- Better escape to normal mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
end, { desc = "[o]pen file [l]ocation in file explorer" })

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
map("n", "<leader>it", ":InspectTree<CR>", { desc = "Show the highlight groups under the cursor (treesitter)" })
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
map("n", "<leader>th", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [h]ints" })
map("v", "<leader>th", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [h]ints" })

-- Add keymaps to the Claude AI
vim.keymap.set("v", "<leader>Ci", ":'<,'>ClaudeImplement ", { noremap = true, desc = "Claude Implement" })
vim.keymap.set("n", "<leader>Cc", ":ClaudeChat<CR>", { noremap = true, silent = true, desc = "Claude Chat" })

local gitsigns = require("gitsigns")

-- Navigation
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gitsigns.nav_hunk("next")
  end
end, { desc = "Jump to next git [c]hange" })

map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gitsigns.nav_hunk("prev")
  end
end, { desc = "Jump to previous git [c]hange" })

-- Actions
-- visual mode
map("v", "<leader>hs", function()
  gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "stage git hunk" })
map("v", "<leader>hr", function()
  gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "reset git hunk" })
-- normal mode
map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
map("n", "<leader>hD", function()
  gitsigns.diffthis("@")
end, { desc = "git [D]iff against last commit" })
map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer (git add)" })
map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
-- Toggles
map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[t]oggle git show [b]lame line" })
map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[t]oggle git show [D]eleted" })

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
