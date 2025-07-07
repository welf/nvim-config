return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  -- these dependencies will only be loaded when cmp loads
  -- dependencies are always lazy-loaded unless specified otherwise
  dependencies = {
    "hrsh7th/cmp-buffer",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    "windwp/nvim-autopairs",
    "kdheepak/cmp-latex-symbols",
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          "rafamadriz/friendly-snippets",
          config = function(_, opts)
            if opts then
              require("luasnip").config.setup(opts)
            end
            vim.tbl_map(function(type)
              require("luasnip.loaders.from_" .. type).lazy_load()
            end, { "vscode", "snipmate", "lua" })
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip").filetype_extend("ruby", { "rails" })
            -- friendly-snippets - enable standardized comments snippets
            require("luasnip").filetype_extend("c", { "cdoc" })
            require("luasnip").filetype_extend("javascript", { "jsdoc" })
            require("luasnip").filetype_extend("lua", { "luadoc" })
            require("luasnip").filetype_extend("python", { "pydoc" })
            require("luasnip").filetype_extend("ruby", { "rdoc" })
            require("luasnip").filetype_extend("rust", { "rustdoc" })
            require("luasnip").filetype_extend("typescript", { "tsdoc" })
          end,
        },
      },
    },
  },
  opts = {
    sources = {
      -- set group index to 0 to skip loading LuaLS completions
      { name = "lazydev", group_index = 0 },
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "luasnip", keyword_length = 2 },
      {
        name = "buffer",
        keyword_length = 3,
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
      { name = "emoji" },
      { name = "nerdfont" },
      { name = "greek" },
      { name = "treesitter" },
      {
        name = "latex_symbols",
        option = {
          strategy = 0, -- mixed
        },
        { name = "crates" },
      },
    },
    experimental = {
      native_menu = false,
      -- ghost_text = false,
    },
  },
  config = function()
    local lsp_zero = require("lsp-zero")
    local cmp_action = lsp_zero.cmp_action()

    -- See `:help cmp`
    local cmp = require("cmp")
    -- local cmp_format = require("lsp-zero").cmp_format({ details = false })

    local luasnip = require("luasnip")
    luasnip.config.setup({})

    local lspkind = require("lspkind")
    lspkind.init()

    -- this is the function that loads the extra snippets
    -- from rafamadriz/friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      enabled = function()
        -- Disable completion in telescope prompts
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
        if buftype == "prompt" then
          return false
        end
        return true
      end,
      preselect = cmp.PreselectMode.None,
      -- -- Make the first item in completion menu always be selected
      -- preselect = "item",
      -- completion = {
      --   completeopt = "menu,menuone,noinsert",
      -- },
      -- Add sources for completion
      sources = {
        -- { name = "copilot", group_index = 2 },
        -- { name = "render-markdown" },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "luasnip", max_item_count = 5, group_index = 1 },
        { name = "nvim_lsp", max_item_count = 20, group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "vim-dadbod-completion", group_index = 1 },
        { name = "path", group_index = 2 },
        {
          name = "buffer",
          keyword_length = 3,
          group_index = 2,
          max_item_count = 5,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      },
      formatting = {
        expandable_indicator = true,
        -- changing the order of fields so the icon is the first
        fields = { "menu", "abbr", "kind" },
        format = lspkind.cmp_format({
          mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          menu = { -- adds a menu icon to the completion menu
            copilot = "🤖",
            nvim_lsp = "💎",
            luasnip = "🚀",
            buffer = "📝",
            path = "📁",
            cmdline = "💻",
          },
          before = function(entry, vim_item) -- for tailwind css autocomplete
            if vim_item.kind == "Color" and entry.completion_item.documentation then
              local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
              if r then
                local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
                local group = "Tw_" .. color
                if vim.fn.hlID(group) < 1 then
                  vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
                end
                vim_item.kind = "⬤" -- or "⬤", or "■", or anything
                vim_item.kind_hl_group = group
                return vim_item
              end
            end
            -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
            -- or just show the icon
            vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
            return vim_item
          end,
        }),
      },
      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          -- If you didn't select any item and the option table contains `select = true`,
          -- `nvim-cmp` will automatically select the first item.
          select = false,
        }),

        -- Select next item
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Select previous item
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Manually trigger a completion from nvim-cmp.
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),

        -- Think of <C-Tab> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <C-Tab> will move you to the right of each of the expansion locations.
        -- <C-S-Tab> is similar, except moving you backwards.
        ["<C-Tab>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-S-Tab>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      }),
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      view = {
        entries = "bordered",
      },
      window = {
        completion = cmp.config.window.bordered({
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
          col_offset = -3, -- align the abbr and word on cursor
          side_padding = 1,
          scrollbar = true,
        }),
        documentation = cmp.config.window.bordered({
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,Search:None",
          max_width = 80,
          max_height = 12,
        }),
      },
    })

    -- Custom highlight groups for better aesthetics
    local highlights = {
      CmpPmenu = { bg = "#1e1e2e", fg = "#cdd6f4" },
      CmpSel = { bg = "#45475a", fg = "#cdd6f4", bold = true },
      CmpBorder = { fg = "#6c7086" },
      CmpDoc = { bg = "#181825", fg = "#cdd6f4" },
      CmpDocBorder = { fg = "#6c7086" },
    }

    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end

    -- Integraite nvim-autopairs with cmp
    local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if not presentAutopairs then
      return
    end
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  end,
}
