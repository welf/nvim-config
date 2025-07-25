-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap and setup lazy.nvim
require("aw.lazy")
-- Setup autocommands and mappings
require("aw.core")

-- Set neovim language to en_US
vim.api.nvim_exec2("language en_US", {})

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set indentation levels and widths
vim.opt.tabstop = 2
-- Number of spaces inserted when indenting
vim.opt.shiftwidth = 2
-- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.expandtab = true
-- Number of spaces inserted instead of a TAB character
vim.opt.softtabstop = 2

-- enable 24-bit color
vim.opt.termguicolors = true

-- Set line spacing (only works in GUI clients like Neovide)
vim.opt.linespace = 4

-- To appropriately highlight codefences returned from denols, you will need to augment vim.g.markdown_fenced languages
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Force neo-tree toggle mapping (load last to override any conflicts)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { 
  desc = "Toggle NeoTree Explorer", 
  silent = true, 
  noremap = true 
})
