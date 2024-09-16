-- Autoformat
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[f]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {
        c = true,
        cpp = true,
        rust = true,
      }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = true -- let LSP format these files
      else
        lsp_format_opt = "fallback"
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      css = { "biome" },
      html = { "biome" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      json = { "biome" },
      jsx = { "biome" },
      lua = { "stylua" },
      scss = { "biome" }, -- You can also customize some of the format options for the filetype
      -- rust = { "rustfmt", lsp_format = "fallback" },
      tsx = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      yaml = { "biome" },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
