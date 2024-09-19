return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    require("rainbow-delimiters.setup").setup({
      strategy = {
        -- Use global strategy by default
        [""] = rainbow_delimiters.strategy["global"],
        -- Use local for lisp languages
        commonlisp = rainbow_delimiters.strategy["local"],
        -- -- Pick the strategy for LaTeX dynamically based on the buffer size
        -- latex = function(bufnr)
        --     -- Disabled for very large files, global strategy for large files,
        --     -- local strategy otherwise
        --     local line_count = vim.api.nvim_buf_line_count(bufnr)
        --     if line_count > 10000 then
        --         return nil
        --     elseif line_count > 1000 then
        --         return rainbow.strategy['global']
        --     end
        --     return rainbow.strategy['local']
        -- end,
        --
        -- -- For every language the query `rainbow-delimiters` is defined, which matches a
        -- -- reasonable set of parentheses and similar delimiters for each language.  In
        -- -- addition there are the following extra queries for certain languages:
        --   - `latex`
        --   - `rainbow-blocks` -- Matches `\begin` and `\end` instructions `lua`
        --   - `rainbow-blocks` -- Matches keyword delimiters like like `function` and `end`, in addition to parentheses
        -- - `javascript`
        --   - `rainbow-delimiters-react` -- Includes React support, set by default for Javascript files
        --   - `rainbow-parens` -- Only parentheses without React tags
        --   - `rainbow-tags-react` -- Only React tags without parentheses
        -- - `query`
        --   - `rainbow-blocks` -- Highlight named nodes and identifiers in addition to parentheses (useful for |:InspectTree|)
        -- - `tsx`
        --   - `rainbow-parens` -- Just Typescript highlighting without React tags
        --   - `rainbow-tags-react` -- Only React tags without Typescript highlighting
        -- - `typescript`
        --   - `rainbow-parens` -- Just Typescript highlighting without React tags
        -- - `verilog`
        --   - `rainbow-blocks` -- Matches keyword delimiters like `begin` and `end`, in addition to parentheses
      },
      query = {
        [""] = "rainbow-delimiters",
        latex = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      -- blacklist = { "c", "cpp" },
    })
  end,
}
