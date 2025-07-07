local opts = {
  panel = {
    enabled = true, -- preview suggestions in a split window
    auto_refresh = false, -- suggestions are refreshed manually (<M-r>) or on panel open (Default: false)
    keymap = {
      jump_prev = "<M-[>", -- Use Alt+[ to match suggestion nav
      jump_next = "<M-]>", -- Use Alt+] to match suggestion nav
      accept = "<M-Enter>", -- Use Alt+Enter to accept suggestion from panel
      refresh = "<M-r>", -- Use Alt+r to refresh suggestions
      open = "<M-CR>", -- Use Alt+CR (same as default) to open panel
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
      accept = "<M-l>", -- Use Meta key like in README examples
      accept_word = "<M-;>",
      accept_line = "<M-'>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<M-x>", -- Or use <C-]> like in README? Default seems <C-]>
    },
  },
  -- Specify filetypes for attaching copilot. If not specified, copilot will attach to all filetypes.
  filetypes = {
    cvs = false,
    help = false,
    gitcommit = true,
    gitrebase = true,
    hgcommit = true,
    markdown = true,
    svn = false,
    typr = false,
    yaml = true,
    ["."] = false,
  },
  -- logger = {
  --   file = vim.fn.stdpath("log") .. "/copilot-lua.log",
  --   file_log_level = vim.log.levels.OFF,
  --   print_log_level = vim.log.levels.WARN,
  --   trace_lsp = "off", -- "off" | "messages" | "verbose"
  --   trace_lsp_progress = false,
  --   log_lsp_messages = false,
  -- },
  copilot_node_command = "node", -- Node.js version must be > 20 (as per README)
  -- workspace_folders = {}, -- Add specific workspace folders if needed
  copilot_model = "gpt-4o-copilot", -- Specify model. Default is "gpt-35-turbo". "gpt-4o-copilot" is also supported per docs.
  -- root_dir = function() -- Default root_dir function
  --   return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  -- end,
  -- should_attach = function(_, bufname) -- Example custom attach logic
  --   if string.match(bufname, "env") then
  --     return false
  --   end
  --   return true
  -- end,
  -- server = { -- Default server config
  --   type = "nodejs", -- "nodejs" | "binary"
  --   custom_server_filepath = nil,
  -- },
  server_opts_overrides = {
    trace = "verbose", -- You have LSP tracing enabled
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
  event = { "InsertEnter", "BufReadPre", "BufNewFile" },
  opts = opts,
  config = function()
    require("copilot").setup(opts)
    -- -- autocommand to attach copilot to the current buffer
    -- vim.cmd([[autocmd BufReadPre * Copilot]])
  end,
}
