-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- get required plugins
local git = require("gitsigns")

-- TOGGLE, OPEN, AND CLOSE --
--
-- Toggle symbols outline window
map("n", "<leader>to", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
-- Toogle Navbuddy explorer
map("n", "<leader>tn", require("nvim-navbuddy").open, { desc = "Toggle NavBuddy" })
-- Toggle Copilot
map("n", "<leader>tC", "<cmd>Copilot toggle<CR>", { silent = true, desc = "Toggle [C]opilot" })
-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
  -- Diagnostic keymaps
  map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })
end, { desc = "[o]pen file [l]ocation in file explorer" })
-- Toggles git actions
map("n", "<leader>tb", git.toggle_current_line_blame, { desc = "[t]oggle git show [b]lame line" })
map("n", "<leader>td", git.toggle_deleted, { desc = "[t]oggle git show [d]eleted" })
-- Toggle LSP diagnostics
local diaglist = require("diaglist")
map("n", "<leader>cb", diaglist.open_buffer_diagnostics, { desc = "Open [b]uffer [c]ode diagnostics" })
map("n", "<leader>cw", diaglist.open_all_diagnostics, { desc = "Open [w]orkspace [c]ode diagnostics" })
-- Show LspInfo
map("n", "<leader>ci", ":LspInfo<CR>", { desc = "Show LSP [i]nfo" })
-- Toggle LSP inline end hints on and off
map("n", "<leader>te", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [e]nd hints" })
map("v", "<leader>te", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [e]nd hints" })
-- Toggle lsp_lines plugin on and off
map("n", "<leader>tl", require("lsp_lines").toggle, { desc = "[t]oggle [l]sp lines" })
-- Toggle colorizer
map("n", "<leader>tc", function()
  require("nvim-highlight-colors").toggle()
end, { desc = "[t]oggle [c]olorizer" })
-- Toggle treesitter inspect AST in a new split window
map("n", "<leader>it", ":InspectTree<CR>", { desc = "Show the highlight groups under the cursor (treesitter)" })
map("n", "<leader>ii", ":Inspect<CR>", { desc = "Show the parsed syntax tree (treesitter)" })
-- Show web-devicons
map("n", "<leader>tI", ":NvimWebDeviconsHiTest<CR>", { desc = "Show web-devicons" })
-- Toggle render markdown preview
map("n", "<leader>tm", ":RenderMarkdown toggle<CR>", { desc = "[T]oggle render [m]arkdown preview" })
-- Toggle terminal (<leader>tt) is defined in the TERMINAL section
