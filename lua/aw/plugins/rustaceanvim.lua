-- =============================================================================
-- Rustaceanvim Plugin Configuration
-- =============================================================================
-- Advanced Rust development experience with rust-analyzer LSP and CodeLLDB debugger
-- Features: Enhanced completions, inlay hints, code lenses, debugging support

return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Use stable version 5.x
  event = { "BufReadPre *.rs", "BufNewFile *.rs" },
  lazy = false, -- Plugin handles its own lazy loading
  ft = { "rust" },

  -- =============================================================================
  -- DEBUGGER SETUP
  -- =============================================================================
  config = function(_, opts)
    -- Configure CodeLLDB debugger adapter for Rust debugging
    local mason_registry = require("mason-registry")
    local codelldb = mason_registry.get_package("codelldb")
    
    -- Ensure CodeLLDB is installed via Mason
    if not codelldb:is_installed() then
      vim.notify("codelldb is not installed. Please run :MasonInstall codelldb")
      return
    end

    -- Setup debugger paths (codelldb:get_install_path() is deprecated)
    local codelldb_install_path = vim.fn.expand("$MASON/packages/codelldb")
    local extension_path = codelldb_install_path .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
    local cfg = require("rustaceanvim.config")

    -- Configure debugger adapter
    vim.g.rustaceanvim = {
      dap = {
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      },
      tools = {
        test_executor = "neotest", -- Use neotest for test execution
      },
    }
    
    -- Merge with user options
    vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
  end,

  -- =============================================================================
  -- RUST-ANALYZER LSP CONFIGURATION
  -- =============================================================================
  opts = {
    server = {
      -- LSP attachment callback - enables inlay hints
      on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,

      settings = {
        ["rust-analyzer"] = {
          
          -- =========================================================================
          -- CARGO CONFIGURATION
          -- =========================================================================
          cargo = {
            buildScripts = {
              enable = true, -- Enable build script analysis
            },
            features = "all", -- Analyze all cargo features
          },
          
          -- =========================================================================
          -- PERFORMANCE OPTIMIZATIONS
          -- =========================================================================
          cachePriming = {
            enable = true,    -- Enable cache priming for faster startup
            numThreads = 8,   -- Number of threads for cache priming
          },
          
          files = {
            excludeDirs = { ".direnv", "node_modules", "target/debug", "target/release" },
            watcher = "client", -- Use client-side file watching for better performance
          },

          -- =========================================================================
          -- CODE CHECKING & LINTING
          -- =========================================================================
          check = {
            command = "clippy", -- Use clippy instead of basic check
            features = "all",   -- Check all features
            allTargets = true,  -- Check all targets (bins, tests, examples)
            workspace = true,   -- Check entire workspace
          },
          checkOnSave = true, -- Run checks on file save

          -- =========================================================================
          -- CODE COMPLETION
          -- =========================================================================
          completion = {
            autoimport = { enable = true },     -- Auto-import suggestions
            autoself = { enable = true },       -- Auto-complete self parameter
            callable = {
              snippets = "add_parentheses",     -- Add () for functions (vs fill_arguments)
            },
            fullFunctionSignatures = { enable = true }, -- Show full function signatures
            postfix = { enable = true },        -- Enable postfix completions (.iter(), .unwrap(), etc)
            termSearch = { enable = true },     -- Search completion items by term
            typing = { 
              autoClosingAngleBrackets = { enable = true } -- Auto-close generic brackets
            },
            workspace = {
              symbol = {
                search = {
                  kind = "only_types", -- Limit workspace symbol search to types
                  limit = 256,         -- Limit number of search results for performance
                  scope = "workspace_and_dependencies", -- Search scope
                },
              },
            },
          },

          -- =========================================================================
          -- DEBUGGING
          -- =========================================================================
          debug = { 
            openDebugPane = true -- Automatically open debug pane when debugging
          },

          -- =========================================================================
          -- DIAGNOSTICS
          -- =========================================================================
          diagnostics = {
            enable = true,
            experimental = { enable = false }, -- Disable experimental diagnostics
            styleLints = { enable = true },    -- Enable style-related lints
          },

          -- =========================================================================
          -- REFERENCES & HIGHLIGHTING
          -- =========================================================================
          highlightRelated = { 
            references = { enable = true } -- Highlight related references
          },

          -- =========================================================================
          -- HOVER DOCUMENTATION
          -- =========================================================================
          hover = {
            actions = {
              enable = true,
              references = { enable = true },
              show = {
                enumVariants = 10,    -- Show up to 10 enum variants
                fields = 10,          -- Show up to 10 struct fields
                traitAssocItems = 5,  -- Show up to 5 trait associated items
              },
            },
          },

          -- =========================================================================
          -- IMPORT MANAGEMENT
          -- =========================================================================
          imports = {
            enforce = true,               -- Enforce import organization
            granularity = { group = "crate" }, -- Group imports by crate
            prefix = "self",              -- Use self:: prefix for local imports
          },

          -- =========================================================================
          -- TEST INTERPRETATION
          -- =========================================================================
          interpret = { 
            tests = true -- Enable test result interpretation
          },

          -- =========================================================================
          -- INLAY HINTS (inline type/parameter hints)
          -- =========================================================================
          inlayHints = {
            bindingModeHints = { enable = true },           -- Show binding modes (&, &mut)
            closureCaptureHints = { enable = false },       -- Disabled: can be noisy
            closureReturnTypeHints = { enable = "always" }, -- Always show closure return types
            discriminantHints = { enable = "always" },      -- Show enum discriminant values
            expressionAdjustmentHints = { enable = "always" }, -- Show type adjustments
            implicitDrops = { enable = false },             -- Disabled: too verbose
            
            -- Lifetime hints configuration
            lifetimeElisionHints = {
              enable = "skip_trivial",    -- Show only non-trivial lifetime hints
              useParameterNames = true,   -- Use parameter names in hints
            },
            
            rangeExclusiveHints = { enable = true },        -- Show range exclusivity hints
            reborrowHints = { enable = "always" },          -- Show reborrow hints
            
            -- Type hints configuration
            typeHints = {
              enable = true,
              hideClosureInitialization = false, -- Show closure initialization types
              hideNamedConstructor = false,      -- Show named constructor types
            },
          },

          -- =========================================================================
          -- CODE LENSES (inline actionable commands)
          -- =========================================================================
          lens = {
            debug = { enable = true },            -- Show debug lens
            enable = true,                        -- Enable code lenses
            forceCustomCommands = true,           -- Use custom commands
            implementations = { enable = true },   -- Show implementation lens
            location = "above_name",              -- Position lenses above item names
            
            -- Reference lenses configuration
            references = {
              adt = { enable = true },            -- Show references for ADTs
              enumVariant = { enable = true },    -- Show references for enum variants
              method = { enable = true },         -- Show references for methods
              trait = { enable = true },          -- Show references for traits
            },
            
            run = { enable = true },              -- Show run lens for executables
          },

          -- =========================================================================
          -- PROCEDURAL MACROS
          -- =========================================================================
          procMacro = {
            enable = true,
            attributes = { enable = true }, -- Enable proc macro attributes
          },

          -- =========================================================================
          -- SERVER BEHAVIOR
          -- =========================================================================
          restartServerOnConfigChange = true, -- Auto-restart when config changes

          -- =========================================================================
          -- SYNTAX HIGHLIGHTING
          -- =========================================================================
          semanticHighlighting = {
            operator = { enable = true }, -- Highlight operators
            punctuation = {
              enable = true,
              separate = {
                macro = { bang = true }, -- Separate macro bang highlighting
              },
              specialization = { enable = true }, -- Enable punctuation specialization
            },
          },

          -- =========================================================================
          -- TYPING ASSISTANCE
          -- =========================================================================
          typing = { 
            autoClosingBrackets = { enable = true } -- Auto-close brackets while typing
          },
        },
      },
    },
  },
}
