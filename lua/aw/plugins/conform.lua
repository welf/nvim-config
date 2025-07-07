-- Autoformat
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
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
      -- Explicitly disable LSP formatting for markdown to ensure prettier runs
      if vim.bo[bufnr].filetype == "markdown" then
        return {
          timeout_ms = 500,
          lsp_format = false, -- Use conform formatters only (prettier)
        }
      end

      -- Default behavior for other filetypes
      local lsp_format_opt = "fallback"
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = true -- let LSP format these files
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt, -- Use fallback for others not disabled
      }
    end,
    -- Add global formatter configurations here
    formatters = {
      -- Removed biome global config, specific config will be in formatters_by_ft
    },
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
      markdown = { "prettier", args = { "--print-width", "120" } }, -- Use prettier with specific width
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
