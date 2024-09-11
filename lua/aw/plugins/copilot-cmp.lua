return {
  "zbirenbaum/copilot-cmp",
  dependencies = {
    "onsails/lspkind.nvim",
  },
  -- -- Setup is done in lua/aw/plugins/cmp.lua
  -- config = function()
  --   local cmp = require("copilot_cmp")
  --   local lspkind = require("lspkind")
  --
  --   lspkind.init({
  --     symbol_map = {
  --       Copilot = "",
  --     },
  --   })
  --
  --   cmp.setup({
  --     formatting = {
  --       format = lspkind.cmp_format({
  --         mode = "symbol",
  --         max_width = 50,
  --         symbol_map = { Copilot = "" }
  --       })
  --     },
  --     sources = {
  --       -- Copilot Source
  --       { name = "copilot",  group_index = 2 },
  --       -- Other Sources
  --       { name = "nvim_lsp", group_index = 2 },
  --       { name = "path",     group_index = 2 },
  --       { name = "luasnip",  group_index = 2 },
  --     },
  --   })
  -- end
}
