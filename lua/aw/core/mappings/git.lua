-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- get required plugins
local git = require("gitsigns")

-- GIT --
--
-- git status
map("n", "<leader>gs", require("neogit").open, { desc = "[g]it [s]tatus", silent = true, noremap = true })
-- git commit
map("n", "<leader>gc", ":Neogit commit<CR>", { desc = "[g]it [c]ommit", silent = true, noremap = true })
-- git pull
map("n", "<leader>gp", ":Neogit pull<CR>", { desc = "[g]it [p]ull", silent = true, noremap = true })
-- git push
map("n", "<leader>gP", ":Neogit push<CR>", { desc = "[g]it [P]ush", silent = true, noremap = true })
-- blame current line
map("n", "<leader>hb", git.blame_line, { desc = "git [b]lame line" })
-- diff against index
map("n", "<leader>hd", git.diffthis, { desc = "git [d]iff against index" })
-- diff against last commit
map("n", "<leader>hD", function()
  git.diffthis("@")
end, { desc = "git [D]iff against last commit" })
-- preview hunk
map("n", "<leader>hp", git.preview_hunk, { desc = "git [p]review hunk" })
-- reset hunk
map("n", "<leader>hr", git.reset_hunk, { desc = "git [r]eset hunk" })
map("v", "<leader>hr", function()
  git.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "git [r]eset hunk" })
-- reset buffer
map("n", "<leader>hR", git.reset_buffer, { desc = "git [R]eset buffer" })
-- stage hunk
map("n", "<leader>hs", git.stage_hunk, { desc = "git [s]tage hunk" })
map("v", "<leader>hs", function()
  git.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "git [s]tage hunk" })
-- stage buffer
map("n", "<leader>hS", git.stage_buffer, { desc = "git [S]tage buffer (git add)" })
-- undo stage hunk
map("n", "<leader>hu", git.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
