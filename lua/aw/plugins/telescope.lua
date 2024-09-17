return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  opts = {
    -- You can put your default mappings / updates / etc. in here
    --  All the info you're looking for is in `:help telescope.setup()`
    defaults = {
      selection_caret = " ",
      entry_prefix = " ",
      file_ignore_patterns = { "node_modules" },
      mappings = {
        -- i = {
        --   ["<C-j>"] = require("telescope.actions").move_selection_next,
        --   ["<C-k>"] = require("telescope.actions").move_selection_previous
        -- },
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
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!
  end,
}
