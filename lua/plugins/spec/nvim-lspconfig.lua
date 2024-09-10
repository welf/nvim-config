return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  config = function()
    local lsp_zero = require("lsp-zero")

    -- lsp_attach is where you enable features that only work
    -- if there is a language server active in the file
    local lsp_attach = function(client, bufnr)
      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = bufnr, desc = "Show LSP info" })
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = bufnr, desc = "Go to definition" })
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = bufnr, desc = "Go to Declaration" })
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = bufnr, desc = "Go to implementation" })
      vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = bufnr, desc = "Go to type definition" })
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = bufnr, desc = "Find references" })
      vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = bufnr, desc = "Show signature help" })
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr, desc = "Rename" })
      vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { buffer = bufnr, desc = "Format" })
      vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = bufnr, desc = "Show code actions" })
    end

    lsp_zero.extend_lspconfig({
      sign_text = true,
      lsp_attach = lsp_attach,
      float_border = "rounded",
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    local lsp_capabilities = vim.tbl_deep_extend("force", require("cmp_nvim_lsp").default_capabilities(), {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })

    lsp_zero.extend_lspconfig({
      capabilities = lsp_capabilities,
    })

    -- require("mason").setup({})
    require("mason-lspconfig").setup({
      -- Replace the language servers listed here
      -- with the ones you want to install
      ensure_installed = { "lua_ls" },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            on_init = function(client)
              lsp_zero.nvim_lua_settings(client, {})
            end,
          })
        end,
        rust_analyzer = lsp_zero.noop,
      },
    })

    -- -- These are just examples. Replace them with the language
    -- -- servers you have installed in your system
    -- require('lspconfig').gleam.setup({})
    -- require('lspconfig').ocamllsp.setup({})

    vim.g.rustaceanvim = {
      server = {
        capabilities = lsp_zero.get_capabilities(),
      },
    }
  end,
}
