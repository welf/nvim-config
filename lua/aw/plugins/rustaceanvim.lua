return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
  event = { "BufReadPre *.rs", "BufNewFile *.rs" },
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  config = function(_, opts)
    local mason_registry = require("mason-registry")
    local codelldb = mason_registry.get_package("codelldb")
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
    local cfg = require("rustaceanvim.config")

    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    }
    vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
  end,
  opts = {
    server = {
      on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
      settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            buildScripts = {
              enable = true,
            },
            features = "all",
          },
          check = {
            command = "clippy", -- rust-analyzer.check.command (default: "check")
            features = "all",
            allTargets = true,
            workspace = true,
          },
          checkOnSave = true,
          completion = {
            autoimport = { enable = true },
            autoself = { enable = true },
            callable = {
              snippets = "add_parentheses", -- default: "fill_arguments"
            },
            fullFunctionSignatures = { enable = true },
            postfix = { enable = true },
            termSearch = { enable = true },
            typing = { autoClosingAngleBrackets = { enable = true } },
            workspace = {
              symbol = {
                search = {
                  kind = "only_types", -- default "only_types"
                },
              },
            },
          },
          debug = { openDebugPane = true },
          diagnostics = {
            enable = true,
            experimental = { enable = true },
            styleLints = { enable = true },
          },
          highlightRelated = { references = { enable = true } },
          hover = {
            actions = {
              enable = true,
              references = { enable = true },
              show = {
                enumVariants = 10,
                fields = 10,
                traitAssocItems = 5,
              },
            },
          },
          imports = {
            enforce = true,
            granularity = { group = "crate" },
            prefix = "self",
          },
          interpret = { tests = true },
          inlayHints = {
            bindingModeHints = { enable = true },
            closureCaptureHints = { enable = false },
            closureReturnTypeHints = { enable = "always" },
            discriminantHints = { enable = "always" },
            expressionAdjustmentHints = { enable = "always" },
            implicitDrops = { enable = false },
            lifetimeElisionHints = {
              enable = "skip_trivial",
              useParameterNames = true,
            },
            -- maxLength = "null",
            rangeExclusiveHints = { enable = true },
            reborrowHints = { enable = "always" },
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
          lens = {
            debug = { enable = true },
            enable = true,
            forceCustomCommands = true,
            implementations = { enable = true },
            location = "above_name",
            references = {
              adt = { enable = true },
              enumVariant = { enable = true },
              method = { enable = true },
              trait = { enable = true },
            },
            run = { enable = true },
          },
          procMacro = {
            enable = true,
            attributes = { enable = true },
            -- "server": "ra_lsp_server"
          },
          restartServerOnConfigChange = true,
          semanticHighlighting = {
            operator = { enable = true },
            punctuation = {
              enable = true,
              separate = {
                macro = { bang = true },
              },
              specialization = { enable = true },
            },
          },
          typing = { autoClosingBrackets = { enable = true } },
        },
      },
    },
  },
}
