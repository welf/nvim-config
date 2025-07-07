return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    render_markdown = {
      enabled = true, -- enable or disable the plugin on startup
      render_modes = { "n", "c", "t" }, -- render modes to use for rendering (normal, command, terminal)
      injections = {
        gitcommit = {
          enabled = true,
          query = [[
                ((message) @injection.content
                    (#set! injection.combined)
                    (#set! injection.include-children)
                    (#set! injection.language "markdown"))
            ]],
        },
      }, -- Treesitter Injections
      heading = { border = true },
    },
  },
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
}
