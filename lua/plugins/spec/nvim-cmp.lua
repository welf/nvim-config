return {
	"hrsh7th/nvim-cmp",
	-- these dependencies will only be loaded when cmp loads
	-- dependencies are always lazy-loaded unless specified otherwise
	dependencies = {
		"hrsh7th/cmp-buffer",
		'saadparwaiz1/cmp_luasnip',
		"hrsh7th/cmp-nvim-lsp",
		'hrsh7th/cmp-path',
		'rafamadriz/friendly-snippets',
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local lsp_zero = require('lsp-zero')
		local cmp = require('cmp')
		local cmp_action = lsp_zero.cmp_action()

		-- this is the function that loads the extra snippets
		-- from rafamadriz/friendly-snippets
		require('luasnip.loaders.from_vscode').lazy_load()

		cmp.setup({
			sources = {
				{ name = 'copilot' },
				{ name = 'path' },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip', keyword_length = 2 },
				{ name = 'buffer',  keyword_length = 3 },
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				-- confirm completion item
				['<Enter>'] = cmp.mapping.confirm({ select = true }),

				-- trigger completion menu
				['<C-Space>'] = cmp.mapping.complete(),

				-- scroll up and down the documentation window
				['<C-u>'] = cmp.mapping.scroll_docs(-4),
				['<C-d>'] = cmp.mapping.scroll_docs(4),

				-- navigate between snippet placeholders
				['<C-f>'] = cmp_action.luasnip_jump_forward(),
				['<C-b>'] = cmp_action.luasnip_jump_backward(),
			}),
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
		})
	end
}
