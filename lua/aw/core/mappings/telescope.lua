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
map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "[s]earch buffer [s]ymbols (LSP)" })
map("n", "<leader>st", builtin.builtin, { desc = "[s]earch [t]elescope selections" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch by [g]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
map("n", "<leader>sr", builtin.lsp_references, { desc = "[s]earch [r]eferences" })
map("n", "<leader>s.", builtin.oldfiles, { desc = "[s]earch recent files (\".\" for repeat)" })
map("n", "<leader>sR", builtin.resume, { desc = "[s]earch [R]esume last" })
map("n", "mm", builtin.buffers, { desc = "Search buffers" })
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

-- Search in specific directory
map("n", "<leader>sD", function()
  local path = vim.fn.input("Search in directory (partial path ok): ", "", "dir")
  if path and path ~= "" then
    -- If path doesn't start with / or ./, treat as partial and use glob
    if not path:match("^[/.]") then
      path = "**/" .. path
    end
    builtin.live_grep({ search_dirs = {path} })
  end
end, { desc = "[s]earch in [D]irectory" })

-- AST grep search
map("n", "<leader>sa", function()
  require("telescope").extensions.ast_grep.ast_grep()
end, { desc = "[s]earch [a]st grep" })

-- TODO comments
map("n", "<leader>St", "<cmd>TodoTelescope<cr>", { desc = "[S]how [t]odos" })
map("n", "<leader>ST", "<cmd>TodoTrouble<cr>", { desc = "[S]how [T]odos (Trouble)" })
map("n", "<leader>Sf", "<cmd>TodoQuickFix<cr>", { desc = "[S]how todos quick[f]ix" })
map("n", "<leader>Sl", "<cmd>TodoLocList<cr>", { desc = "[S]how todos [l]ocation list" })
