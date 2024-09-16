local opts = {
  panel = {
    enabled = true, -- preview suggestions in a split window
    auto_refresh = true, -- suggestions are refreshed as you type in the buffer
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    -- When auto_trigger is `true`, copilot starts suggesting as soon as you enter insert mode.
    -- When auto_trigger is `false`, use the `next` or `prev` keymap to trigger copilot suggestion.
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = "<M-;>",
      accept_line = "<M-'>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  -- Specify filetypes for attaching copilot. If not specified, copilot will attach to all filetypes.
  filetypes = {
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = "node", -- Node.js version must be > 18.x
  server_opts_overrides = {
    trace = "verbose",
    settings = {
      advanced = {
        listCount = 10, -- #completions for panel
        inlineSuggestCount = 3, -- #completions for getCompletions
      },
    },
  },
}

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = opts,
  config = function()
    require("copilot").setup(opts)
  end,
}
