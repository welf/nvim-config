return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  init = function()
    local map = vim.keymap.set
    local builtin = require "telescope.builtin"

    map("n", "<leader>sa", function()
      builtin.find_files {
        follow = true,
        no_ignore = true,
        hidden = true,
        prompt_prefix = " 󱡴  ",
        prompt_title = "[S]earch [A]ll project files",
      }
    end, { desc = "Telescope search all files" })
    map("n", "<leader>sb", "<cmd>Telescope buffers<CR>", { desc = "[S]earch [B]uffers" })
    map("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "[S]earch [F]iles" })
    map("n", "<leader>so", "<cmd>Telescope oldfiles<CR>", { desc = "[S]earch previously [O]pened files" })
    map("n", "<leader>sc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "[S]earch in [C]urrent buffer" })
    map("n", "<leader>sw", "<cmd>Telescope live_grep<CR>", { desc = "[S]earch [W]ord (live grep)" })
    -- map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope terms" })
    -- map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope NvChad themes" })
    map("n", "<leader>sr", "<cmd>Telescope lsp_references<CR>", { desc = "[S]earch References" })
    map("n", "<leader>sm", "<cmd>Telescope marks<CR>", { desc = "[S]earch [M]arks" })
    map("n", "<leader>sh", "<cmd>Telescope highlights<CR>", { desc = "[S]earch [H]ighlights" })
    map("n", "<leader>sd", "<cmd>Telescope diagnostics<CR>", { desc = "[S]earch LSP [D]iagnostics" })
    map("n", "<leader>st", "<cmd>Telescope treesitter<CR>", { desc = "[S]earch [T]reeSitter symbols" })
    map("n", "<leader>sp", "<cmd>Telescope builtin<CR>", { desc = "[S]earch Telescope [P]ickers" })
    map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Search [G]it [C]ommits" })
    map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Search [G]it [S]tatus" })
    map("n", "<leader>s?", "<cmd>Telescope help_tags<CR>", { desc = "[S]earch help tags" })
  end,
  opts = {
    defaults = {
      selection_caret = " ",
      entry_prefix = " ",
      file_ignore_patterns = { "node_modules" },
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
    pickers = {
      oldfiles = {
        prompt_title = "Recent Files",
      },
      buffers = {
        prompt_title = "Open Buffers",
      },
      find_files = {
        prompt_title = "Files",
      },
      builtin = {
        prompt_title = "Builtin Pickers",
      },
    },
  },
}
