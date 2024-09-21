-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set
local gitsigns = require("gitsigns")

-- NEXT/PREVIOUS NAVIGATION
--
--  Use <Tab> and <S-Tab> to navigate through buffers
map("n", "gb", ":bnext<CR>", { desc = "Go to next buffer" })
map("n", "gB", ":bprev<CR>", { desc = "Go to previous buffer" })
-- Git hunk navigation
-- Go to next git change
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gitsigns.nav_hunk("next")
  end
end, { desc = "Jump to next git [c]hange" })
-- Go to previous git change
map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gitsigns.nav_hunk("prev")
  end
end, { desc = "Jump to previous git [c]hange" })

-- WINDOW NAVIGATION AND RESIZING
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Resize windows with =, -, +, and _
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make the window bigger vertically" })
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make the window smaller vertically" })
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make the window bigger horizontally" })
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make the window smaller horizontally" })

-- TOGGLE, OPEN, AND CLOSE
--
-- Toggle symbols outline window
map("n", "<leader>to", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
-- Toogle Navbuddy explorer
map("n", "<leader>tn", require("nvim-navbuddy").open, { desc = "Toggle NavBuddy" })
-- Toggle Copilot
map("n", "<leader>tC", "<cmd>Copilot toggle<CR>", { desc = "Toggle [C]opilot" })
-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
  -- Diagnostic keymaps
  map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })
end, { desc = "[o]pen file [l]ocation in file explorer" })
-- Toggles git actions
map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[t]oggle git show [b]lame line" })
map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[t]oggle git show [d]eleted" })
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

-- SELECT, CLEAR, AND DISMISS
--
-- Select all content of the file (Ctrl-a)
map("n", "<C-a>", "gg0vG$", { desc = "Select [A]ll" })
-- Clear highlights on search when pressing `<Esc>h` in normal mode
--  See `:help hlsearch`
map("n", "<ESC>h", ":nohlsearch<CR>", { desc = "Clear search [h]ighlights" })
-- Dismiss notify popups with <Ctrl-c>
map("n", "<ESC>n", function()
  require("notify").dismiss()
end, { desc = "Dismiss [n]otify popup" })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
map("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
map("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
map("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Better escape to normal mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Move lines up/down
map("n", "<A-Down>", ":m .+1<CR>", { desc = "Move line down" })
map("n", "<A-j>", ":m .+1<CR>", { desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>", { desc = "Move line up" })
map("n", "<A-k>", ":m .-2<CR>", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- folds
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

-- Terminal keymaps
map("n", "<A-i>", ":FTermToggle<CR>", { desc = "Toggle Terminal" })
map("v", "<A-i>", ":FTermToggle<CR>", { desc = "Toggle Terminal" })
map("t", "<A-i>", "<C-\\><C-n>:FTermToggle<CR>", { desc = "Toggle Terminal" })
map("n", "<A-o>", ":FTermOpen<CR>", { desc = "Open Terminal" })
map("v", "<A-o>", ":FTermOpen<CR>", { desc = "Open Terminal" })
map("t", "<A-w>", "<C-\\><C-n>:FTermClose<CR>", { desc = "Close Terminal but preserve terminal session" })
map("t", "<A-e>", "<C-\\><C-n>:FTermExit<CR>", { desc = "Exit Terminal and remove terminal session" })
-- -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- -- is not what someone will guess without a bit more experience.
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Add keymaps to the Claude AI
vim.keymap.set("v", "<leader>Ci", ":'<,'>ClaudeImplement ", { desc = "Claude Implement" })
vim.keymap.set("n", "<leader>Cx", ":ClaudeCancel<CR>", { silent = true, desc = "Claude Cancel" })
vim.keymap.set("n", "<leader>Cc", ":ClaudeChat<CR>", { silent = true, desc = "Claude Chat" })
-- Delete default Claude keymaps
vim.keymap.del("n", "<leader>cc")
vim.keymap.del("v", "<leader>ci")
vim.keymap.del("n", "<leader>cx")

-- GIT
--
-- Open Neogit
map("n", "<leader>gs", require("neogit").open, { desc = "[g]it [s]tatus", silent = true, noremap = true })
map("n", "<leader>gc", ":Neogit commit<CR>", { desc = "[g]it [c]ommit", silent = true, noremap = true })
map("n", "<leader>gp", ":Neogit pull<CR>", { desc = "[g]it [p]ull", silent = true, noremap = true })
map("n", "<leader>gP", ":Neogit push<CR>", { desc = "[g]it [P]ush", silent = true, noremap = true })
-- Git actions
-- visual mode
map("v", "<leader>hs", function()
  gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "stage git hunk" })
map("v", "<leader>hr", function()
  gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "reset git hunk" })
-- normal mode
map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
map("n", "<leader>hD", function()
  gitsigns.diffthis("@")
end, { desc = "git [D]iff against last commit" })
map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer (git add)" })
map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })

-- TELESCOPE
--
-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[s]earch Git [b]ranches" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elections" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[s]earch recent files (\".\" for repeat)" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Show open buffers" })
-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = true,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })
-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live grep in open files",
  })
end, { desc = "[s]earch [/] in open files" })
-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[s]earch [n]eovim files" })

-- DEBUGGING
--
-- See `:help nvim-dap`
-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>d>", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map("n", "<Leader>dd", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { desc = "Debugger set conditional breakpoint" })
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- -- Scroll in command line suggestions with Ctrl-j and Ctrl-k
-- vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
--   if not require("noice.lsp").scroll(4) then
--     return "<c-j>"
--   end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
--   if not require("noice.lsp").scroll(-4) then
--     return "<c-k>"
--   end
-- end, { silent = true, expr = true })
