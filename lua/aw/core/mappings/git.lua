-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- get required plugins
local git = require("gitsigns")

-- Set prefix for the git group
local git_prefix = "<leader>g"
-- GIT --
--
-- git status
map("n", git_prefix .. "s", require("neogit").open, { desc = "[g]it [s]tatus", silent = true, noremap = true })

-- git commit
map("n", git_prefix .. "c", ":Neogit commit<CR>", { desc = "[g]it [c]ommit", silent = true, noremap = true })

-- git pull
map("n", git_prefix .. "p", ":Neogit pull<CR>", { desc = "[g]it [p]ull", silent = true, noremap = true })

-- git push
map("n", git_prefix .. "P", ":Neogit push<CR>", { desc = "[g]it [P]ush", silent = true, noremap = true })

-- blame current line
map("n", git_prefix .. "b", git.blame_line, { desc = "git [b]lame line" })

-- diff against index
map("n", git_prefix .. "d", git.diffthis, { desc = "git [d]iff against index" })

-- diff against last commit
map("n", git_prefix .. "D", function()
  git.diffthis("@")
end, { desc = "git [D]iff against last commit" })

-- preview hunk
map("n", git_prefix .. "v", git.preview_hunk, { desc = "git pre[v]iew hunk" })

-- reset hunk
map("n", git_prefix .. "r", git.reset_hunk, { desc = "git [r]eset hunk" })
map("v", git_prefix .. "r", function()
  git.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "git [r]eset hunk" })

-- reset buffer
map("n", git_prefix .. "R", git.reset_buffer, { desc = "git [R]eset buffer" })

-- stage hunk
map("n", git_prefix .. "h", git.stage_hunk, { desc = "git stage [h]unk" })
map("v", git_prefix .. "h", function()
  git.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "git stage [h]unk" })

-- stage buffer
map("n", git_prefix .. "S", git.stage_buffer, { desc = "git [S]tage buffer (git add)" })

-- undo stage hunk
map("n", git_prefix .. "u", git.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
