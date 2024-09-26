-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Terminal keymaps
map("n", "<leader>tt", ":FTermToggle<CR>", { desc = "[t]oggle [t]erminal" })
map("v", "<leader>tt", ":FTermToggle<CR>", { desc = "[t]oggle [t]erminal" })
map("t", "<A-t>", "<C-\\><C-n>:FTermToggle<CR>", { desc = "[t]oggle [t]erminal" })
map("n", "<A-t>", ":FTermOpen<CR>", { desc = "Open [t]erminal" })
map("v", "<A-t>", ":FTermOpen<CR>", { desc = "Open [t]erminal" })
map("t", "<A-w>", "<C-\\><C-n>:FTermClose<CR>", { desc = "Close Terminal but preserve terminal session" })
map("t", "<A-e>", "<C-\\><C-n>:FTermExit<CR>", { desc = "[E]xit Terminal and remove terminal session" })
-- -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- -- is not what someone will guess without a bit more experience.
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
