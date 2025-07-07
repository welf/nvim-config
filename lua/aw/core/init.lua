-- Execute a command `:set laststatus=3` to enable the global statusline
vim.opt.laststatus = 3

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
  autoEnableHints = false,
})
-- Disable inlay endhints by default. Toggle them with `<leader>th`
require("lsp-endhints").disable()

-- Set the color of LSP inlay hints. It should be set after `lsp-endhints` setup call
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#70758c", italic = true })
-- -- Enable inlay hints from LSPs
-- vim.lsp.inlay_hint.enable(true)

require("aw.core.autocmd")
require("aw.core.mappings.basic")
require("aw.core.mappings.debug")
require("aw.core.mappings.folds")
require("aw.core.mappings.git")
require("aw.core.mappings.info")
require("aw.core.mappings.move-lines")
require("aw.core.mappings.multicursor")
require("aw.core.mappings.next-prev")
require("aw.core.mappings.pairs")
require("aw.core.mappings.rust-cargo")
require("aw.core.mappings.select-clear-dismiss")
require("aw.core.mappings.telescope")
require("aw.core.mappings.toggle")
require("aw.core.mappings.window")
