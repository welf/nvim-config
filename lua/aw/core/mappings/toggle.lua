-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Set prefix for the toggle group
local toggle_prefix = "<leader>t"
-- Set prefix for the LSP group
local lsp_prefix = "<leader>c"

-- get required plugins
local git = require("gitsigns")
local diaglist = require("diaglist")

-- TOGGLE, OPEN, AND CLOSE --
--
-- Toggle symbols outline window
map("n", toggle_prefix .. "o", "<cmd>Outline<CR>", { desc = "[t]oggle [o]utline" })

-- Toogle Navbuddy explorer
map("n", toggle_prefix .. "N", require("nvim-navbuddy").open, { desc = "[t]oggle [N]avBuddy" })

-- Toggle Copilot
map("n", toggle_prefix .. "C", "<cmd>Copilot toggle<CR>", { silent = true, desc = "[t]oggle [C]opilot on/off for buffer" })

-- Toggles git actions
map("n", toggle_prefix .. "b", git.toggle_current_line_blame, { desc = "[t]oggle git show [b]lame line" })
map("n", toggle_prefix .. "d", git.toggle_deleted, { desc = "[t]oggle git show [d]eleted" })

-- Toggle LSP diagnostics
map("n", lsp_prefix .. "b", diaglist.open_buffer_diagnostics, { desc = "[b]uffer code diagnostics" })
map("n", lsp_prefix .. "w", diaglist.open_all_diagnostics, { desc = "[w]orkspace code diagnostics" })

-- Show LspInfo
map("n", lsp_prefix .. "i", ":LspInfo<CR>", { desc = "Show LSP [i]nfo" })

-- Toggle LSP inline end hints on and off
map("n", toggle_prefix .. "E", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [E]nd hints" })
map("v", toggle_prefix .. "E", require("lsp-endhints").toggle, { desc = "[t]oggle inlay [E]nd hints" })

-- Toggle lsp_lines plugin on and off
map("n", toggle_prefix .. "l", require("lsp_lines").toggle, { desc = "[t]oggle [l]sp lines" })

-- Toggle colorizer
map("n", toggle_prefix .. "c", function()
  require("nvim-highlight-colors").toggle()
end, { desc = "[t]oggle [c]olorizer" })

-- Toggle render markdown preview
map("n", toggle_prefix .. "m", ":RenderMarkdown toggle<CR>", { desc = "[t]oggle [m]arkdown preview" })

-- Toggle code actions preview
map({ "n", "v" }, toggle_prefix .. "p", require("actions-preview").code_actions, { desc = "[t]oggle [c]ode actions [p]review" })

-- Toggle terminal (<leader>tt) is defined in the TERMINAL section
