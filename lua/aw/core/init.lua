local command = vim.api.nvim_create_user_command

-- create vim commands
command("FTermOpen", require("FTerm").open, { bang = true })
command("FTermClose", require("FTerm").close, { bang = true })
command("FTermExit", require("FTerm").exit, { bang = true })
command("FTermToggle", require("FTerm").toggle, { bang = true })

-- Enable inlay endhints
require("lsp-endhints").setup({
  icons = {
    type = "󰜁 ",
    parameter = "󰏪 ",
    offspec = " ", -- hint kind not defined in official LSP spec
    unknown = " ", -- hint kind is nil
  },
  label = {
    padding = 1,
    marginLeft = 0,
    bracketedParameters = true,
  },
  autoEnableHints = true,
})
-- Disable inlay endhints by default. Toggle them with `<leader>th`
require("lsp-endhints").disable()

-- Set the color of LSP inlay hints. It should be set after `lsp-endhints` setup call
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#70758c", italic = true })
-- -- Enable inlay hints from LSPs
-- vim.lsp.inlay_hint.enable(true)

-- tresitter folding options
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

require("aw.core.autocmd")
require("aw.core.mappings")
