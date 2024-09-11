return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  -- these dependencies will only be loaded when cmp loads
  -- dependencies are always lazy-loaded unless specified otherwise
  dependencies = {
    "hrsh7th/cmp-buffer",
    "saadparwaiz1/cmp_luasnip",
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
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
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
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
      { name = "buffer", keyword_length = 3 },
    },
    -- experimental = {
    --   ghost_text = false,
    -- },
  },
  config = function()
    local lsp_zero = require("lsp-zero")
    -- See `:help cmp`
    local cmp = require("cmp")
    -- local cmp_format = require("lsp-zero").cmp_format({ details = false })
    local luasnip = require("luasnip")

    local cmp_action = lsp_zero.cmp_action()
    luasnip.config.setup({})

    -- this is the function that loads the extra snippets
    -- from rafamadriz/friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      -- -- Make the first item in completion menu always be selected
      -- preselect = "item",
      -- completion = {
      --   completeopt = "menu,menuone,noinsert",
      -- },
      -- Add sources for completion
      sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "buffer", keyword_length = 3, group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", keyword_length = 2, group_index = 2 },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        -- changing the order of fields so the icon is the first
        fields = { "menu", "abbr", "kind" },
        -- Customize menu
        format = function(entry, item)
          local menu_icon = {
            copilot = "",
            nvim_lsp = "",
            buffer = "",
            path = "",
            nvim_lua = "",
            luasnip = "⋗",
          }

          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- Select next item
        ["<Tab>"] = cmp_action.tab_complete(),
        -- Select previous item
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),

        -- Manually trigger a completion from nvim-cmp.
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
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
    })
  end,
}
