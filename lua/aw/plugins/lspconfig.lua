--[[
═══════════════════════════════════════════════════════════════════════════════════════════════════
                                    LSP CONFIGURATION
═══════════════════════════════════════════════════════════════════════════════════════════════════

This module configures Language Server Protocol (LSP) support for Neovim using:
- nvim-lspconfig: Core LSP configuration
- mason.nvim: LSP server installation and management  
- lsp-zero: Simplified LSP setup and defaults
- Additional UI and navigation enhancements

Key Features:
- Automatic LSP server installation via Mason
- Telescope integration for LSP navigation
- Document highlighting and inlay hints
- Code navigation with nvim-navbuddy
- Comprehensive language support (Rust, TypeScript, Lua, etc.)

LSP Server Override Configuration:
  - cmd (table): Override the default command used to start the server
  - filetypes (table): Override the default list of associated filetypes for the server  
  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  - settings (table): Language server specific settings
--]]

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    --                                 LSP INSTALLER & MANAGER
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    { "williamboman/mason.nvim", config = true }, -- Must be loaded before mason-lspconfig
    "williamboman/mason-lspconfig.nvim", -- Bridges mason.nvim with nvim-lspconfig
    { "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- Ensures additional tools are installed

    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    --                                  UI & STATUS COMPONENTS
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    { "j-hui/fidget.nvim", tag = "legacy", opts = {} }, -- LSP progress notifications
    { "nvim-lua/lsp-status.nvim" }, -- Status info for lualine integration

    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    --                              LSP ENHANCEMENTS & INTEGRATIONS
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    "hrsh7th/cmp-nvim-lsp", -- Completion source for LSP
    {
      "SmiteshP/nvim-navbuddy", -- Code structure navigation and outline
      dependencies = {
        "SmiteshP/nvim-navic", -- Context breadcrumbs for winbar/statusline
        "MunifTanjim/nui.nvim", -- UI component library
      },
      config = function()
        local navbuddy = require("nvim-navbuddy")
        local actions = require("nvim-navbuddy.actions")
        navbuddy.setup({
          -- Automatically attach to LSP clients
          lsp = { auto_attach = true },

          -- Window appearance and positioning
          window = { border = "single", size = "60%", position = "50%" },

          -- Visual indicators for navigation tree
          node_markers = {
            enabled = true,
            icons = { leaf = "  ", leaf_selected = " → ", branch = " " },
          },

          -- LSP symbol icons for different code elements
          icons = {
            File = "󰈙 ",
            Module = " ",
            Namespace = "󰌗 ",
            Package = " ",
            Class = "󰌗 ",
            Method = "󰆧 ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = "󰕘",
            Interface = "󰕘",
            Function = "󰊕 ",
            Variable = "󰆧 ",
            Constant = "󰏿 ",
            String = " ",
            Number = "󰎠 ",
            Boolean = "◩ ",
            Array = "󰅪 ",
            Object = "󰅩 ",
            Key = "󰌋 ",
            Null = "󰟢 ",
            EnumMember = " ",
            Struct = "󰌗 ",
            Event = " ",
            Operator = "󰆕 ",
            TypeParameter = "󰊄 ",
          },
          use_default_mappings = true,
          mappings = {
            ["<esc>"] = actions.close(),
            ["q"] = actions.close(),
            ["j"] = actions.next_sibling(),
            ["k"] = actions.previous_sibling(),
            ["h"] = actions.parent(),
            ["l"] = actions.children(),
            ["0"] = actions.root(),
            ["v"] = actions.visual_name(),
            ["V"] = actions.visual_scope(),
            ["y"] = actions.yank_name(),
            ["Y"] = actions.yank_scope(),
            ["i"] = actions.insert_name(),
            ["I"] = actions.insert_scope(),
            ["a"] = actions.append_name(),
            ["A"] = actions.append_scope(),
            ["r"] = actions.rename(),
            ["d"] = actions.delete(),
            ["f"] = actions.fold_create(),
            ["F"] = actions.fold_delete(),
            ["c"] = actions.comment(),
            ["<enter>"] = actions.select(),
            ["o"] = actions.select(),
            ["J"] = actions.move_down(),
            ["K"] = actions.move_up(),
            ["s"] = actions.toggle_preview(),
            ["<C-v>"] = actions.vsplit(),
            ["<C-s>"] = actions.hsplit(),
            ["t"] = actions.telescope({
              layout_strategy = "horizontal",
              layout_config = { height = 0.60, width = 0.60, prompt_position = "top", preview_width = 0.50 },
            }),
            ["g?"] = actions.help(),
          },
          source_buffer = { follow_node = true, highlight = true, reorient = "smart" },
        })
      end,
    },
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" }, -- Simplified LSP configuration helper
  },

  config = function()
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════
    --                                    MAIN CONFIGURATION
    -- ═══════════════════════════════════════════════════════════════════════════════════════════════════

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                     ON_ATTACH FUNCTION
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- This function is called whenever an LSP client attaches to a buffer.
    -- It sets up keymaps, document highlighting, and other buffer-local LSP features.
    local on_attach = function(client, bufnr)
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                               HELPER FUNCTION FOR KEYMAPS
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      -- Convenience function to create LSP-specific keymaps with consistent description prefix
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                                   DEFAULT LSP KEYMAPS
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      -- Apply lsp-zero's sensible default keymaps (gd, K, etc.)
      require("lsp-zero").default_keymaps({ buffer = bufnr })

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                            TELESCOPE-ENHANCED LSP NAVIGATION
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      map("<leader>sS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch workspace [S]ymbols")

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                                 CORE LSP ACTIONS
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" }) -- Normal and visual modes
      map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                              DOCUMENT HIGHLIGHTING
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      -- Automatically highlight references to the symbol under the cursor
      if client:supports_method("textDocument/documentHighlight") then
        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
        -- Clear highlights when LSP detaches
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("lsp-detach-highlight", { clear = true }),
          callback = function(event)
            if event.buf == bufnr then
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = bufnr })
            end
          end,
        })
      end

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                                INLAY HINTS TOGGLE
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      -- Enable toggle for inlay hints (type annotations, parameter names, etc.)
      if client:supports_method("textDocument/inlayHint") then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, "[T]oggle Inlay [H]ints")
      end

      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      --                               LSP STATUS INTEGRATION
      -- ─────────────────────────────────────────────────────────────────────────────────────────────────
      -- Attach lsp-status for statusline integration
      require("lsp-status").on_attach(client)
    end

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                   MODULE REQUIREMENTS
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lsp_zero = require("lsp-zero")

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                  LSP-ZERO CONFIGURATION
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- Register our on_attach function to be called for all LSP clients
    lsp_zero.on_attach(on_attach)

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                  LSP CAPABILITIES SETUP
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- Configure capabilities to enable advanced LSP features and nvim-cmp integration
    local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Enable folding range capability for better code folding support
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                   LSP SERVERS TO INSTALL
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- List of LSP servers that mason-lspconfig will automatically install and configure
    local ensure_installed = {
      "arduino_language_server", -- Arduino development
      "biome", -- JavaScript/TypeScript linting and formatting
      "denols", -- Deno TypeScript/JavaScript runtime
      "emmet_language_server", -- HTML/CSS abbreviation expansion
      "htmx", -- HTMX hypermedia library support
      "lexical", -- Elixir language server
      "lua_ls", -- Lua language server (Neovim configuration)
      "marksman", -- Markdown language server
      "ruby_lsp", -- Ruby language server
      "taplo", -- TOML language server
      "tailwindcss", -- TailwindCSS utility-first framework
      "yamlls", -- YAML language server
    }

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                               MASON-LSPCONFIG SETUP
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      automatic_installation = true, -- Automatically install servers when opening relevant files
      handlers = {
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                  DEFAULT HANDLER
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- Applies to all servers unless they have a custom handler below
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,

        -- ═════════════════════════════════════════════════════════════════════════════════════════════
        --                               CUSTOM SERVER HANDLERS
        -- ═════════════════════════════════════════════════════════════════════════════════════════════

        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                     LUA_LS
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- Specialized configuration for Neovim Lua development
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                codeLens = { enable = true }, -- Enable code lens
                completion = { callSnippet = "Replace" }, -- Snippet completion behavior
                doc = { privateName = { "^_" } }, -- Private name pattern
                hint = { enable = true, setType = false, paramType = true, paramName = "Disable", semicolon = "Disable", arrayIndex = "Disable" }, -- Inlay hints config
                telemetry = { enable = false }, -- Disable telemetry
                diagnostics = { globals = { "vim" }, disable = { "missing-fields" } }, -- Neovim globals and disabled diagnostics
                -- Note: workspace.library is automatically configured by lsp-zero helper
              },
            },
          }))
        end,

        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                     YAMLLS
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- YAML language server with schema validation
        ["yamlls"] = function()
          lspconfig.yamlls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "/*.yaml", -- Kubernetes schema validation
                  ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.yml", -- GitLab CI schema validation
                },
              },
            },
          })
        end,

        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                     BIOME
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- JavaScript/TypeScript formatter and linter (fast Rust-based alternative to ESLint/Prettier)
        ["biome"] = function()
          lspconfig.biome.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "biome", "lsp-proxy" },
            filetypes = {
              "astro", -- Astro components
              "css", -- Cascading Style Sheets
              "graphql", -- GraphQL queries
              "javascript", -- JavaScript
              "javascriptreact", -- JSX
              "json", -- JSON files
              "jsonc", -- JSON with comments
              "svelte", -- Svelte components
              "typescript", -- TypeScript
              "typescript.tsx", -- TypeScript JSX
              "typescriptreact", -- TypeScript React
              "vue", -- Vue.js components
            },
            root_dir = lspconfig.util.root_pattern(".git", "package.json", "biome.json", "biome.jsonc"),
          })
        end,

        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                    MARKSMAN
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- Markdown language server for documentation editing
        ["marksman"] = function()
          lspconfig.marksman.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "marksman", "server" },
            filetypes = { "markdown", "markdown.mdx" },
            root_dir = lspconfig.util.root_pattern(".marksman.toml", ".git"),
          })
        end,

        -- Custom handler for emmet_language_server
        ["emmet_language_server"] = function()
          lspconfig.emmet_language_server.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              "css",
              "eruby",
              "html",
              "javascript",
              "javascriptreact",
              "less",
              "sass",
              "scss",
              "pug",
              "typescriptreact",
              "vue",
              "eelixir",
              "elixir",
              "heex",
              "surface",
            },
            -- Add init_options if needed
          })
        end,

        -- Custom handler for denols
        ["denols"] = function()
          lspconfig.denols.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "deno", "lsp" },
            root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", ".git"),
            filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "mdx" },
            init_options = {
              lint = true,
              unstable = true,
              suggest = { imports = { hosts = { ["https://deno.land"] = true } } },
            },
          })
        end,

        -- Custom handler for htmx
        ["htmx"] = function()
          lspconfig.htmx.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              "html",
              "htmldjango",
              "jinja.html",
              "erb",
              "handlebars",
              "php",
              "twig",
              "elixir",
              "eelixir",
              "heex",
              "surface",
              "templ",
              "astro",
              "vue",
              "svelte",
            }, -- Adjust as needed
            -- Add init_options if needed
          })
        end,

        -- Custom handler for tailwindcss
        ["tailwindcss"] = function()
          lspconfig.tailwindcss.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              "html",
              "htmldjango",
              "jinja.html",
              "erb",
              "handlebars",
              "php",
              "twig",
              "elixir",
              "eelixir",
              "heex",
              "surface",
              "templ",
              "astro",
              "vue",
              "svelte",
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "css",
              "scss",
              "less",
              "postcss",
            }, -- Adjust as needed
            settings = {
              tailwindCSS = {
                includeLanguages = { elixir = "html-eex", eelixir = "html-eex", heex = "html-eex", templ = "html" },
                classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                lint = { cssConflict = "warning" },
                validate = true,
              },
            },
            root_dir = lspconfig.util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "postcss.config.js",
              "package.json",
              ".git"
            ),
          })
        end,

        -- Custom handler for lexical (Elixir)
        ["lexical"] = function()
          lspconfig.lexical.setup({
            cmd = { "lexical" }, -- Ensure cmd is provided here
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "elixir", "eelixir", "heex", "surface" },
            root_dir = lspconfig.util.root_pattern("mix.exs", ".git"),
          })
        end,

        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        --                                  RUST_ANALYZER
        -- ─────────────────────────────────────────────────────────────────────────────────────────────
        -- Rust language server is managed by rustaceanvim plugin, so we disable it here
        ["rust_analyzer"] = lsp_zero.noop,
      },
    })

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                 ADDITIONAL LSP SERVERS
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- Set up additional LSP servers that are not managed by mason-lspconfig
    
    -- ─────────────────────────────────────────────────────────────────────────────────────────────────
    --                                      AST-GREP
    -- ─────────────────────────────────────────────────────────────────────────────────────────────────
    -- AST-based search and code analysis tool
    lspconfig.ast_grep.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { 'ast-grep', 'lsp' },
      filetypes = { "c", "cpp", "rust", "go", "java", "python", "javascript", "typescript", "html", "css", "kotlin", "dart", "lua" },
      root_dir = lspconfig.util.root_pattern('sgconfig.yaml', 'sgconfig.yml')
    })

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                 RUSTACEANVIM INTEGRATION
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- Merge our LSP capabilities with rustaceanvim if it's configured
    -- This ensures completion and other features work properly with Rust
    if vim.g.rustaceanvim and vim.g.rustaceanvim.server then
      vim.g.rustaceanvim.server.capabilities = vim.tbl_deep_extend("force", vim.g.rustaceanvim.server.capabilities or {}, capabilities)
    end

    -- ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
    --                                  FINALIZATION
    -- └─────────────────────────────────────────────────────────────────────────────────────────────────┘
    -- Note: Explicit lsp_zero.setup() call is not needed with mason-lspconfig handlers approach
  end,
}
