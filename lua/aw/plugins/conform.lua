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
      local filename = vim.api.nvim_buf_get_name(bufnr)
      
      -- Skip formatting for .claude/agents files to preserve YAML structure
      if filename:match("%.claude/agents/") then
        return false
      end
      
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {
        c = true,
        cpp = true,
        rust = true,
      }
      -- Use dprint + table compactor for markdown formatting with LSP fallback.
      -- Higher timeout: on a fresh machine dprint downloads/compiles its
      -- markdown wasm plugin on first run (cached afterwards).
      if vim.bo[bufnr].filetype == "markdown" then
        return {
          timeout_ms = 5000,
          lsp_format = "fallback",
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
      prettier = {
        prepend_args = { "--prose-wrap", "always", "--print-width", "120" },
      },
      -- Use the in-repo dprint config so a fresh clone formats markdown
      -- identically with no external setup. A bare "md" extension is passed
      -- to --stdin (the buffer file may not exist on disk yet, e.g. the
      -- first save of a brand-new file).
      dprint = {
        args = {
          "fmt",
          "--stdin",
          "md",
          "--config",
          vim.fn.stdpath("config") .. "/dprint.json",
        },
      },
      -- Post-formatting step: rewrite GFM tables with single-space cell
      -- padding so one wide cell can't blow up the whole column (and its
      -- separator dashes). Runs as a plain Lua script via `nvim -l`, so it
      -- needs no runtime beyond Neovim itself. Must come after dprint in the
      -- markdown chain so its compact output is what gets written.
      compact_tables = {
        command = vim.v.progpath,
        args = { "-l", vim.fn.stdpath("config") .. "/scripts/compact-md-tables.lua" },
        stdin = true,
      },
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
      markdown = { "dprint", "compact_tables" }, -- dprint formats, then tables are compacted (see formatters section)
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
