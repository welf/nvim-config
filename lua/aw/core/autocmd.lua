-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Enable matching parentheses highlighting
vim.opt.showmatch = true     -- Briefly highlight matching brackets/parentheses
vim.opt.matchtime = 2        -- Time to show matching bracket (in tenths of a second)

-- Start the LSP server for bash files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.lsp.start({
      name = "bash-language-server",
      cmd = { "bash-language-server", "start" },
    })
  end,
})

-- `noice` settings (nvim floating command line)
local noice_hl = vim.api.nvim_create_augroup("NoiceHighlights", {})
local noice_cmd_types = {
  CmdLine = "Constant",
  Input = "Constant",
  Calculator = "Constant",
  Lua = "Constant",
  Filter = "Constant",
  Rename = "Constant",
  Substitute = "NoiceCmdlinePopupBorderSearch",
  Help = "Todo",
}
vim.api.nvim_clear_autocmds({ group = noice_hl })
vim.api.nvim_create_autocmd("BufEnter", {
  group = noice_hl,
  desc = "redefinition of noice highlight groups",
  callback = function()
    for type, hl in pairs(noice_cmd_types) do
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, {})
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, { link = hl })
    end
    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", {})
    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = "Constant" })
  end,
})

-- Notification settings
local notify_hl = vim.api.nvim_create_augroup("NotifyHighlights", {})
vim.api.nvim_clear_autocmds({ group = notify_hl })
vim.api.nvim_create_autocmd("BufEnter", {
  group = notify_hl,
  desc = "redefinition of notify icon colours",
  callback = function()
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", {})
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { link = "Character" })
  end,
})

-- GitSigns highlight settings
local gs_hl = vim.api.nvim_create_augroup("GitSignsHighlight", {})
vim.api.nvim_clear_autocmds({ group = gs_hl })
vim.api.nvim_create_autocmd("BufEnter", {
  group = gs_hl,
  desc = "redefinition of gitsigns highlight groups",
  callback = function()
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChangeLn" })
    vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChangeNr" })
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDeleteLn" })
    vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDeleteNr" })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GitSignsAdd" })
    vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { link = "GitSignsAddLn" })
    vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { link = "GitSignsAddNr" })
  end,
})

-- Set visual wrapping options for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  desc = "Enable visual line wrapping for markdown",
  callback = function(args)
    -- Set window-local options for the current window
    vim.opt_local.wrap = true      -- Enable visual line wrapping
    vim.opt_local.linebreak = true -- Wrap lines at word boundaries
    -- Also set buffer-local textwidth to guide wrapping
    vim.bo[args.buf].textwidth = 120
    
  end,
})

-- =============================================================================
-- RUST DEVELOPMENT OPTIMIZATIONS
-- =============================================================================

local rust_augroup = vim.api.nvim_create_augroup("RustOptimizations", { clear = true })

-- Save *.rs files on InsertLeave to trigger rust-analyzer
vim.api.nvim_create_autocmd("InsertLeave", {
  group = rust_augroup,
  pattern = "*.rs",
  desc = "Save *.rs files on InsertLeave to trigger rust-analyzer",
  callback = function()
    if vim.bo.modified then
      vim.cmd("write")
    end
  end,
})

-- Auto-format Rust files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = rust_augroup,
  pattern = "*.rs",
  desc = "Auto-format Rust files on save",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Enhanced Rust file settings
vim.api.nvim_create_autocmd("FileType", {
  group = rust_augroup,
  pattern = "rust",
  desc = "Enhanced settings for Rust files",
  callback = function()
    -- Better text width for Rust (common community standard)
    vim.opt_local.textwidth = 100
    
    -- Enable spell check in comments
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    
    -- Enhanced folding for Rust
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldnestmax = 10
    
    -- Enhanced fold keymaps with error handling for Rust
    vim.keymap.set('n', 'za', function()
      local ok, _ = pcall(vim.cmd, 'normal! za')
      if not ok then
        vim.notify('No fold found at cursor', vim.log.levels.INFO)
      end
    end, { buffer = true, desc = 'Toggle fold' })
    
    vim.keymap.set('n', 'zA', function()
      -- Force create folds if none exist by setting lower foldlevel
      local current_foldlevel = vim.wo.foldlevel
      if current_foldlevel >= 99 then
        vim.wo.foldlevel = 0  -- Close all folds
      else
        vim.wo.foldlevel = 99  -- Open all folds
      end
    end, { buffer = true, desc = 'Toggle all folds in buffer' })
    
    vim.keymap.set('n', 'zc', function()
      local ok, _ = pcall(vim.cmd, 'normal! zc')
      if not ok then
        vim.notify('No fold found at cursor', vim.log.levels.INFO)
      end
    end, { buffer = true, desc = 'Close fold' })
    
    vim.keymap.set('n', 'zo', function()
      local ok, _ = pcall(vim.cmd, 'normal! zo')
      if not ok then
        vim.notify('No fold found at cursor', vim.log.levels.INFO)
      end
    end, { buffer = true, desc = 'Open fold' })
    
    vim.keymap.set('n', 'zC', 'zC', { buffer = true, desc = 'Close all folds' })
    vim.keymap.set('n', 'zO', 'zO', { buffer = true, desc = 'Open all folds' })
    vim.keymap.set('n', 'zR', function()
      vim.wo.foldlevel = 99
    end, { buffer = true, desc = 'Open all folds in buffer' })
    vim.keymap.set('n', 'zM', function()
      vim.wo.foldlevel = 0
    end, { buffer = true, desc = 'Close all folds in buffer' })
    
    -- Set up better indentation for Rust
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Smart Cargo.toml handling
vim.api.nvim_create_autocmd("BufWritePost", {
  group = rust_augroup,
  pattern = "Cargo.toml",
  desc = "Reload rust-analyzer workspace when Cargo.toml changes",
  callback = function()
    vim.notify("Cargo.toml updated - reloading workspace...", vim.log.levels.INFO)
    vim.cmd("RustLsp reloadWorkspace")
  end,
})
