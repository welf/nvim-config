-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {}, -- WARN: DON'T activate rust-analyzer here!!!
  --
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`tsserver`) will work just fine
  -- tsserver = {},
  --

  taplo = {},
  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
        diagnostics = { globals = { "vim", "hs" } },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

local lsp_attach = function(client, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

  -- Find references for the word under your cursor.
  map("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map("<leader>go", require("telescope.builtin").lsp_type_definitions, "[o]pen type definition")

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  -- map("<leader>Sd", require("telescope.builtin").lsp_document_symbols, "[V]iew [d]ocument symbols")

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  -- map("<leader>Sw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[V]iew [w]orkspace symbols")

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  -- map("<leader>cr", vim.lsp.buf.rename, "[r]ename the variable under cursor")

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  -- map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
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

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
      end,
    })
    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, "[t]oggle inlay [h]ints")
    end
  end
end

local navbuddy_config = function()
  local navbuddy = require("nvim-navbuddy")
  local actions = require("nvim-navbuddy.actions")

  navbuddy.setup({
    window = {
      border = "single", -- "rounded", "double", "solid", "none"
      -- or an array with eight chars building up the border in a clockwise fashion
      -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
      size = "60%", -- Or table format example: { height = "40%", width = "100%"}
      position = "50%", -- Or table format example: { row = "100%", col = "0%"}
      scrolloff = nil, -- scrolloff value within navbuddy window
      sections = {
        left = {
          size = "20%",
          border = nil, -- You can set border style for each section individually as well.
        },
        mid = {
          size = "40%",
          border = nil,
        },
        right = {
          -- No size option for right most section. It fills to
          -- remaining area.
          border = nil,
          preview = "leaf", -- Right section can show previews too.
          -- Options: "leaf", "always" or "never"
        },
      },
    },
    node_markers = {
      enabled = true,
      icons = {
        leaf = "  ",
        leaf_selected = " → ",
        branch = " ",
      },
    },
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
    use_default_mappings = true, -- If set to false, only mappings set
    -- by user are set. Else default
    -- mappings are used for keys
    -- that are not set by user
    mappings = {
      ["<esc>"] = actions.close(), -- Close and cursor to original location
      ["q"] = actions.close(),

      ["j"] = actions.next_sibling(), -- down
      ["k"] = actions.previous_sibling(), -- up

      ["h"] = actions.parent(), -- Move to left panel
      ["l"] = actions.children(), -- Move to right panel
      ["0"] = actions.root(), -- Move to first panel

      ["v"] = actions.visual_name(), -- Visual selection of name
      ["V"] = actions.visual_scope(), -- Visual selection of scope

      ["y"] = actions.yank_name(), -- Yank the name to system clipboard "+
      ["Y"] = actions.yank_scope(), -- Yank the scope to system clipboard "+

      ["i"] = actions.insert_name(), -- Insert at start of name
      ["I"] = actions.insert_scope(), -- Insert at start of scope

      ["a"] = actions.append_name(), -- Insert at end of name
      ["A"] = actions.append_scope(), -- Insert at end of scope

      ["r"] = actions.rename(), -- Rename currently focused symbol

      ["d"] = actions.delete(), -- Delete scope

      ["f"] = actions.fold_create(), -- Create fold of current scope
      ["F"] = actions.fold_delete(), -- Delete fold of current scope

      ["c"] = actions.comment(), -- Comment out current scope

      ["<enter>"] = actions.select(), -- Goto selected symbol
      ["o"] = actions.select(),

      ["J"] = actions.move_down(), -- Move focused node down
      ["K"] = actions.move_up(), -- Move focused node up

      ["s"] = actions.toggle_preview(), -- Show preview of current node

      ["<C-v>"] = actions.vsplit(), -- Open selected node in a vertical split
      ["<C-s>"] = actions.hsplit(), -- Open selected node in a horizontal split

      ["t"] = actions.telescope({ -- Fuzzy finder at current level.
        layout_config = { -- All options that can be
          height = 0.60, -- passed to telescope.nvim's
          width = 0.60, -- default can be passed here.
          prompt_position = "top",
          preview_width = 0.50,
        },
        layout_strategy = "horizontal",
      }),

      ["g?"] = actions.help(), -- Open mappings help window
    },
    lsp = {
      auto_attach = true, -- If set to true, you don't need to manually use attach function
      preference = nil, -- list of lsp server names in order of preference
    },
    source_buffer = {
      follow_node = true, -- Keep the current node in focus on the source buffer
      highlight = true, -- Highlight the currently focused node
      reorient = "smart", -- "smart", "top", "mid" or "none"
      scrolloff = nil, -- scrolloff value when navbuddy is open
    },
    custom_hl_group = nil, -- "Visual" or any other hl group to use instead of inverted colors
  })
end
return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants

    { "williamboman/mason-lspconfig.nvim" },
    { "nvim-lua/lsp-status.nvim" },

    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} }, -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`

    -- Allows extra capabilities provided by nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
      config = navbuddy_config,
    },
  },
  opts = {
    inlay_hints = {
      enabled = true,
      exclude = {},
    },
    -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the code lenses.
    codelens = {
      enabled = true,
    },
    -- Enable lsp cursor word highlighting
    document_highlight = {
      enabled = true,
    },
    -- add any global capabilities here
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
    servers = servers,
    settings = {
      html = {
        format = {
          templating = true,
          wrapLineLength = 120,
          wrapAttributes = "auto",
        },
        hover = {
          documentation = true,
          references = true,
        },
      },
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    local lsp_zero = require("lsp-zero")
    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        local lsp_group_prefix = "<leader>c"
        local show_group_prefix = "<leader>S"

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
        map(lsp_group_prefix .. "R", require("telescope.builtin").lsp_references, "goto [R]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")
        map(lsp_group_prefix .. "I", require("telescope.builtin").lsp_implementations, "goto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("gf", require("telescope.builtin").lsp_type_definitions, "Type De[f]inition")
        map(lsp_group_prefix .. "d", require("telescope.builtin").lsp_type_definitions, "goto type [d]efinition")

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map(lsp_group_prefix .. "r", vim.lsp.buf.rename, "[r]ename the variable under cursor")

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map(lsp_group_prefix .. "a", vim.lsp.buf.code_action, "Show available [c]ode [a]ctions", { "n", "x" })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
        map(lsp_group_prefix .. "D", vim.lsp.buf.declaration, "goto [D]eclaration")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map(show_group_prefix .. "d", require("telescope.builtin").lsp_document_symbols, "[S]how [d]ocument symbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map(show_group_prefix .. "w", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]how [w]orkspace symbols")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
            end,
          })
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[t]oggle inlay [h]ints")
          end
        end
      end,
    })

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

    -- Ensure the servers and tools listed in lspconfig.opts.servers are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require("mason").setup()

    require("mason-lspconfig").setup({
      -- Replace the language servers listed here
      -- with the ones you want to install
      ensure_installed = {
        "arduino_language_server",
        "biome",
        "denols",
        "emmet_language_server",
        "htmx",
        "lexical", -- Elixir LSP
        "lua_ls",
        "ruby_lsp",
        "taplo",
        "tailwindcss",
        "yamlls",
      },
      handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup({
            capabilities = lsp_capabilities,
          })
        end,
        lua_ls = function()
          lspconfig.lua_ls.setup({
            on_init = function(client, bufnr)
              lsp_zero.nvim_lua_settings(client, {})
              lsp_zero.default_keymaps({ buffer = bufnr })

              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              })
            end,
          })
        end,
        ["yamlls"] = function()
          lspconfig.yamlls.setup({
            capabilities = lsp_capabilities,
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "/*.yaml",
                  -- Add the schema for gitlab piplines
                  -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.yml",
                },
              },
            },
          })
        end,
        -- this is the "custom handler" for `rust_analyzer`
        -- noop is an empty function that doesn't do anything
        rust_analyzer = lsp_zero.noop, -- NOTE: we don't activate rust-analyzer here!
      },
    })

    local lsp_status = require("lsp-status")

    lsp_zero.on_attach(function(client, bufnr)
      lsp_status.on_attach(client)
      lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    -- -- These are just examples. Replace them with the language
    -- -- servers you have installed in your system
    -- require('lspconfig').gleam.setup({})
    -- require('lspconfig').ocamllsp.setup({})
    lspconfig.emmet_language_server.setup({
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
        "eelxir",
        "heex",
        "eelexir",
        "surface",
      },
      -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
      -- **Note:** only the options listed in the table are supported.
      init_options = {
        ---@type table<string, string>
        includeLanguages = {},
        --- @type string[]
        excludeLanguages = {},
        --- @type string[]
        extensionsPath = {},
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
        preferences = {},
        --- @type boolean Defaults to `true`
        showAbbreviationSuggestions = true,
        --- @type "always" | "never" Defaults to `"always"`
        showExpandedAbbreviation = "always",
        --- @type boolean Defaults to `false`
        showSuggestionsAsSnippets = false,
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
        syntaxProfiles = {},
        --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
        variables = {},
      },
    })

    lspconfig.biome.setup({
      filetypes = { "css", "javascript", "javascriptreact", "less", "sass", "scss", "typescriptreact", "json" },
    })
    vim.g.rustaceanvim = {
      server = {
        capabilities = lsp_zero.get_capabilities(),
      },
    }

    -- Elixir LSP setup
    if not configs.lexical then
      configs.lexical = {
        default_config = {
          filetypes = { "elixir", "eelixir", "heex" },
          cmd = { "lexical" },
          root_dir = function(fname)
            return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
          end,
          -- optional settings
          settings = {},
        },
      }
    end

    lspconfig.lexical.setup({})

    -- TailwindCSS LSP setup
    lspconfig.tailwindcss.setup({
      init_options = {
        userLanguages = {
          elixir = "html-eex",
          eelixir = "html-eex",
          heex = "html-eex",
        },
      },
      cmd = { "tailwindcss-language-server", "--stdio" },
      filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "eruby", "eelixir", "heex", "surface", "elixir" },
      root_dir = function(fname)
        return lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "tailwind.config.tsx", ".git")(fname)
          or vim.loop.os_homedir()
      end,
    })
  end,
}
