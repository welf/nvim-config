-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

map("n", "zR", require("ufo").openAllFolds, {
  desc = "Open all folds",
})
map("n", "zM", require("ufo").closeAllFolds, {
  desc = "Close all folds",
})
map("n", "zr", require("ufo").openFoldsExceptKinds, {
  desc = "Open all folds except for the current one",
})
map("n", "<leader>K", function()
  local _ = require("ufo").peekFoldedLinesUnderCursor()
end, {
  desc = "Preview folded maps",
})
