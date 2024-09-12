-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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
