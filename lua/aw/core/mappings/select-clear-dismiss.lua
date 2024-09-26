-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- SELECT, CLEAR, AND DISMISS --
--
-- Select all content of the file (Ctrl-a)
map("n", "<C-a>", "gg0vG$", { desc = "Select [a]ll" })
-- Clear highlights on search when pressing `<Esc>h` in normal mode
--  See `:help hlsearch`
map("n", "<ESC>h", ":nohlsearch<CR>", { desc = "Clear search [h]ighlights" })
-- Dismiss notify popup(s)
map("n", "<ESC>p", function()
  require("notify").dismiss()
end, { desc = "Dismiss notify [p]opup" })
-- "<ESC>c": Clear all cursors (defined in MULTICURSOR section).
