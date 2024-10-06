local prefix = "<leader>a"

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatAdapter",
  callback = function(args)
    if args.data.adapter == nil or vim.tbl_isempty(args.data) then
      return
    end
    vim.g.llm_name = args.data.adapter.name
  end,
})

local roles = {
  llm = "  CodeCompanion",
  user = "  Me",
}

local keymaps = {
  close = { modes = { n = "q", i = "<C-c>" } },
  stop = { modes = { n = "<C-c>" } },
}

local deepseek_coder = function()
  return require("codecompanion.adapters").extend("ollama", {
    name = "deepseek_coder",
    schema = {
      model = {
        default = "deepseek-coder-v2:latest",
      },
    },
  })
end

local codestral = function()
  return require("codecompanion.adapters").extend("ollama", {
    name = "codestral",
    schema = {
      model = {
        default = "codestral:latest",
      },
    },
  })
end

local anthropic = function()
  return require("codecompanion.adapters").extend("anthropic", {
    env = {
      api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline",
    },
  })
end

local gemini = function()
  return require("codecompanion.adapters").extend("gemini", {
    env = {
      api_key = "cmd:op read op://personal/Gemini_API/credential --no-newline",
    },
  })
end

local openai = function()
  return require("codecompanion.adapters").extend("openai", {
    env = {
      api_key = "cmd:op read op://personal/OpenAI_API/credential --no-newline",
    },
  })
end

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },
    dependencies = {
      "jellydn/spinner.nvim", -- Show loading spinner when request is started
      -- "tpope/vim-sleuth", -- Automatically detects which indents should be used in the current buffer
      {
        "echasnovski/mini.diff",
        version = false,
        event = "VeryLazy",
        config = function()
          require("mini.diff").setup()
        end,
      },
    },
    opts = {
      adapters = {
        deepseek_coder = deepseek_coder,
        codestral = codestral,
        anthropic = anthropic,
        gemini = gemini,
        openai = openai,
      },
      strategies = {
        chat = {
          adapter = "copilot",
          roles = roles,
          keymaps = keymaps,
        },
        inline = { adapter = "copilot" },
        agent = {
          adapter = "codestral",
          tools = {
            opts = {
              auto_submit_errors = true,
            },
          },
        },
      },
      inline = {
        layout = "buffer", -- vertical|horizontal|buffer
      },
      display = {
        diff = {
          close_chat_at = 500,
          provider = "mini_diff",
        },
        chat = {
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
          },
          show_settings = true,
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion [a]ction picker" },
      { prefix .. "n", "<cmd>CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "Start [n]ew CodeCompanion chat" },
      { prefix .. "+", "<cmd>CodeCompanionAdd<CR>", mode = { "n", "v" }, desc = "Add selected text to CodeCompanion" },
      { prefix .. "i", "<cmd>CodeCompanion<CR>", mode = { "n", "v" }, desc = "Inline CodeCompanion Prompt" },
      { prefix .. "o", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "[o]pen CodeCompanion chat prompt" },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    config = function(_, options)
      require("codecompanion").setup(options)

      -- Show loading spinner when request is started
      local spinner = require("spinner")
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            spinner.show()
          end
          if request.match == "CodeCompanionRequestFinished" then
            spinner.hide()
          end
        end,
      })
    end,
  },
}
