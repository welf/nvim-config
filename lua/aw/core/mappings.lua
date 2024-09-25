-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- get required plugins
local git = require("gitsigns")
local mc = require("multicursor-nvim")

-- INSERT BLANK LINES --
--
-- Insert a blank line below in normal mode
map("n", "<Enter>", "o<Esc>", { desc = "Insert a blank line below the cursor" })
-- Insert a blank line above in normal mode
map("n", "<S-Enter>", "O<Esc>", { desc = "Insert a blank line above the cursor" })

-- NEXT/PREVIOUS NAVIGATION --
--
-- Go to next buffer
map("n", "]b", ":bnext<CR>", { desc = "Go to next buffer" })
-- Go to previous buffer
map("n", "[b", ":bprev<CR>", { desc = "Go to previous buffer" })
-- Go to next git hunk
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    git.nav_hunk("next")
  end
end, { desc = "Jump to next git [c]hange" })
-- Go to previous git hunk
map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    git.nav_hunk("prev")
  end
end, { desc = "Jump to previous git [c]hange" })

-- WINDOW NAVIGATION AND RESIZING --
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Resize windows with =, -, +, and _
map("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make the window bigger vertically" })
map("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make the window smaller vertically" })
map("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make the window bigger horizontally" })
map("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make the window smaller horizontally" })

-- TOGGLE, OPEN, AND CLOSE --
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

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
map("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
map("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
map("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Better escape to normal mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

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
map("v", "<leader>Ci", ":'<,'>ClaudeImplement ", { desc = "Claude Implement" })
map("n", "<leader>Cx", ":ClaudeCancel<CR>", { silent = true, desc = "Claude Cancel" })
map("n", "<leader>Cc", ":ClaudeChat<CR>", { silent = true, desc = "Claude Chat" })
-- Delete default Claude keymaps
vim.keymap.del("n", "<leader>cc")
vim.keymap.del("v", "<leader>ci")
vim.keymap.del("n", "<leader>cx")

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
end, { desc = "[/] Fuzzily search in current buffer" })
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

-- DEBUGGING --
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

-- MULTICURSOR --
-- https://github.com/jake-stewart/multicursor.nvim
--
-- Add cursor below the main cursor.
map({ "n", "v" }, "<C-Up>", function()
  mc.addCursor("k")
end, { desc = "Add cursor below the main cursor" })

-- Add cursor above the main cursor.
map({ "n", "v" }, "<C-Down>", function()
  mc.addCursor("j")
end, { desc = "Add cursor above the main cursor" })

-- Add a cursor and jump to the next word under cursor.
map({ "n", "v" }, "<C-n>", function()
  mc.addCursor("*")
end, { desc = "Add a cursor and jump to the next word under cursor" })

-- Jump to the next word under cursor but do not add a cursor.
map({ "n", "v" }, "<C-s>", function()
  mc.skipCursor("*")
end, { desc = "Jump to the next word under cursor but do not add a cursor" })

-- Rotate the main cursor.
map({ "n", "v" }, "<right>", mc.nextCursor, { desc = "Make next cursor the main" })

map({ "n", "v" }, "<left>", mc.prevCursor, { desc = "Make previous cursor the main" })

-- Delete the main cursor.
map({ "n", "v" }, "<leader>x", mc.deleteCursor, { desc = "Delete the main cursor" })

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add and remove cursors with control + left click" })

-- Stop other cursors from moving to reposition the main cursor.
map({ "n", "v" }, "<C-q>", function()
  if mc.cursorsEnabled() then
    -- Stop other cursors from moving.
    -- This allows you to reposition the main cursor.
    mc.disableCursors()
  else
    mc.addCursor()
  end
end, { desc = "Stop other cursors to reposition the main" })

-- Clear all cursors.
map("n", "<ESC>c", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- Default <ESC>c handler.
  end
end, { desc = "Clear all cursors" })

-- Align cursor columns.
map("n", "<leader>a", mc.alignCursors, { desc = "Align cursor columns" })

-- Split visual selections by regex.
map("v", "S", mc.splitCursors, { desc = "Split visual selections by regex" })

-- Insert for each line of visual selections.
map("v", "I", mc.insertVisual, { desc = "Insert for each line of visual selections" })

-- Append for each line of visual selections.
map("v", "A", mc.appendVisual, { desc = "Append for each line of visual selections" })

-- Match new cursors within visual selections by regex.
map("v", "M", mc.matchCursors, { desc = "Match new cursors within visual selections by regex" })

-- Rotate visual selection contents forward.
map("v", "<leader>r", function()
  mc.transposeCursors(1)
end, { desc = "Rotate visual selection contents forward" })

-- Rotate visual selection contents backwards.
map("v", "<leader>R", function()
  mc.transposeCursors(-1)
end, { desc = "Rotate visual selection contents backwards" })

-- Inspect cursor position.
map("n", "<leader>Vi", ":Inspect<CR>", { desc = "[i]nspect cursor position" })
