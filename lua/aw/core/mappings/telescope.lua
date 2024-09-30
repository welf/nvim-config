-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- TELESCOPE --
--
-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
-- map("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
map("n", "<leader>sb", builtin.git_branches, { desc = "[s]earch Git [b]ranches" })
map("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
map("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elections" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch by [g]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
map("n", "<leader>s.", builtin.oldfiles, { desc = "[s]earch recent files (\".\" for repeat)" })
map("n", "<leader><space>", builtin.buffers, { desc = "Show open buffers" })
-- Slightly advanced example of overriding default behavior and theme
map("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = true,
  }))
end, { desc = "Fuzzily search in current buffer" })
-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
map("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live grep in open files",
  })
end, { desc = "[s]earch [/] in open files" })
-- Shortcut for searching your Neovim configuration files
map("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[s]earch [n]eovim files" })
