return {
  "saecki/crates.nvim",
  tag = "stable",
  ft = { "toml" },
  config = function()
    require("crates").setup({
      completion = {
        cmp = {
          enabled = true,
        },
        -- Crate name completion
        crates = {
          enabled = true, -- disabled by default
          max_results = 8, -- The maximum number of search results to display
          min_chars = 2, -- The minimum number of charaters to type before completions begin appearing
        },
      },
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          -- the same on_attach function as for your other lsp's
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    })
    require("cmp").setup.buffer({
      sources = { { name = "crates" } },
    })
  end,
}
