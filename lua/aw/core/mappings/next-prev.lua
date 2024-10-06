-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set
-- -- get required plugins
-- local git = require("gitsigns")

-- NEXT/PREVIOUS NAVIGATION --
--
-- Go to next buffer
map("n", "]b", ":bnext<CR>", { desc = "Go to next buffer" })
-- Go to previous buffer
map("n", "[b", ":bprev<CR>", { desc = "Go to previous buffer" })
-- Go to next git hunk
-- NOTE: These mappings are set by `mini.diff` plugin: `]h` (next hunk), `[h` (prev hunk)
--
-- map("n", "]h", function()
--   if vim.wo.diff then
--     vim.cmd.normal({ "]h", bang = true })
--   else
--     git.nav_hunk("next")
--   end
-- end, { desc = "Jump to next git [h]hunk" })
-- Go to previous git hunk
-- map("n", "[h", function()
--   if vim.wo.diff then
--     vim.cmd.normal({ "[h", bang = true })
--   else
--     git.nav_hunk("prev")
--   end
-- end, { desc = "Jump to previous git [h]hunk" })
