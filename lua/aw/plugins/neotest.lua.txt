return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "jfpedroza/neotest-elixir",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand("%:p:h")) .. " --watch",
          jestConfigFile = function(file)
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            end
            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          env = { CI = true },
          cwd = function(_)
            return vim.fn.getcwd()
          end,
          jest_test_discovery = false,
        }),
        require("neotest-elixir")({
          -- -- The Mix task to use to run the tests
          -- -- Can be a function to return a dynamic value.
          -- -- Default: "test"
          -- mix_task = { "my_custom_task" },
          --
          -- -- Other formatters to pass to the test command as the formatters are overridden
          -- -- Can be a function to return a dynamic value.
          -- -- Default: {"ExUnit.CLIFormatter"}
          -- extra_formatters = { "ExUnit.CLIFormatter", "ExUnitNotifier" },
          --
          -- -- Extra test block identifiers
          -- -- Can be a function to return a dynamic value.
          -- -- Block identifiers "test", "feature" and "property" are always supported by default.
          -- -- Default: {}
          -- extra_block_identifiers = { "test_with_mock" },
          --
          -- -- Extra arguments to pass to mix test
          -- -- Can be a function that receives the position, to return a dynamic value
          -- -- Default: {}
          -- args = { "--trace" },
          --
          -- -- Command wrapper
          -- -- Must be a function that receives the mix command as a table, to return a dynamic value
          -- -- Default: function(cmd) return cmd end
          -- post_process_command = function(cmd)
          --   return vim.tbl_flatten({ { "env", "FOO=bar" }, cmd })
          -- end,
          --
          -- Delays writes so that results are updated at most every given milliseconds
          -- Decreasing this number improves snappiness at the cost of performance
          -- Can be a function to return a dynamic value.
          -- Default: 1000
          write_delay = 1000,
        }),
        require("rustaceanvim.neotest"),
      },
      discovery = {
        enabled = false,
      },
    })
  end,
}
