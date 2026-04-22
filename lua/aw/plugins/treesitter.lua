return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Wrap nvim_buf_set_extmark to catch out-of-range errors
      local original_set_extmark = vim.api.nvim_buf_set_extmark
      vim.api.nvim_buf_set_extmark = function(buffer, ns_id, line, col, opts)
        local ok, result = pcall(original_set_extmark, buffer, ns_id, line, col, opts)
        if
          not ok
          and (
            result:match("Invalid 'end_row': out of range")
            or result:match("Invalid 'end_col': out of range")
            or result:match("Invalid 'col': out of range")
          )
        then
          return nil
        elseif not ok then
          error(result)
        end
        return result
      end

      local parsers = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "eex",
        "elixir",
        "graphql",
        "heex",
        "html",
        "jinja",
        "javascript",
        "json",
        "json5",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "systemverilog",
        "vim",
        "vimdoc",
        "yaml",
      }

      require("nvim-treesitter").install(parsers)

      vim.treesitter.language.register("tsx", { "javascript", "typescript.tsx" })
      vim.treesitter.language.register("systemverilog", { "verilog", "systemverilog" })
      vim.treesitter.language.register("json", "jsonc")

      local indent_disabled = { python = true, css = true, toml = true }
      local max_filesize = 100 * 1024 -- 100 KB

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("aw-treesitter-start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if not lang or lang == "" then
            return
          end

          local ok_add = pcall(vim.treesitter.language.add, lang)
          if not ok_add then
            return
          end

          local ok_stat, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok_stat and stats and stats.size > max_filesize then
            return
          end

          local ok_start = pcall(vim.treesitter.start, buf, lang)
          if not ok_start then
            return
          end

          if indent_disabled[lang] then
            vim.bo[buf].indentexpr = ""
          else
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
          vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local" })

          if lang == "ruby" then
            vim.bo[buf].syntax = "ON"
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {
      enable_close = true,
      enable_rename = true,
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
