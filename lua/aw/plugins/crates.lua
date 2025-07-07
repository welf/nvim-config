-- =============================================================================
-- Crates.nvim Plugin Configuration
-- =============================================================================
-- Smart Cargo.toml dependency management with version hints and updates
-- Features: Version hints, dependency updates, crate documentation access

return {
  "saecki/crates.nvim",
  tag = "stable",
  event = { "BufRead Cargo.toml" },
  ft = { "toml" },
  dependencies = { 'nvim-lua/plenary.nvim' },
  
  config = function()
    require("crates").setup({
      -- Automatically show version hints in Cargo.toml
      smart_insert = true,
      insert_closing_quote = true,
      avoid_prerelease = true,
      autoload = true,
      autoupdate = true,
      loading_indicator = true,
      date_format = "%Y-%m-%d",
      thousands_separator = ",",
      notification_title = "Crates",
      
      -- Popup configuration
      popup = {
        autofocus = true,
        hide_on_select = true,
        copy_register = "+", -- Use system clipboard
        style = "minimal",
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
      },
      
      -- Text formatting
      text = {
        loading = "   Loading",
        version = "   %s",
        prerelease = "   %s",
        yanked = "   %s",
        nomatch = "   No match",
        upgrade = "   %s",
        error = "   Error fetching crate",
      },
      
      -- Completion integration
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
      
      -- LSP integration
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          -- Enable inlay hints for crate versions
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
        actions = true,
        completion = true,
        hover = true,
      },
      
      -- Null-ls integration disabled (null-ls is deprecated)
      null_ls = {
        enabled = false,
        name = "crates.nvim",
      },
    })
    
    -- Setup cmp source for Cargo.toml files
    require("cmp").setup.buffer({
      sources = { { name = "crates" } },
    })
    
    -- Set up autocommands for Cargo.toml files
    local augroup = vim.api.nvim_create_augroup("CratesNvim", { clear = true })
    
    vim.api.nvim_create_autocmd("BufRead", {
      group = augroup,
      pattern = "Cargo.toml",
      callback = function()
        require('crates').show()
      end,
    })
    
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      pattern = "Cargo.toml",
      callback = function()
        require('crates').reload()
      end,
    })
  end,
  
  -- Safe keymappings using <leader>rc* prefix (r=rust, c=crates)
  keys = {
    -- Toggle and reload
    { "<leader>rct", "<cmd>lua require('crates').toggle()<cr>", desc = "Toggle crate hints", ft = "toml" },
    { "<leader>rcr", "<cmd>lua require('crates').reload()<cr>", desc = "Reload crates", ft = "toml" },
    { "<leader>rcs", "<cmd>lua require('crates').show_popup()<cr>", desc = "Show crate popup", ft = "toml" },
    { "<leader>rci", "<cmd>lua require('crates').show_crate_popup()<cr>", desc = "Show crate info", ft = "toml" },
    { "<leader>rcf", "<cmd>lua require('crates').show_features_popup()<cr>", desc = "Show crate features", ft = "toml" },
    { "<leader>rcd", "<cmd>lua require('crates').show_dependencies_popup()<cr>", desc = "Show dependencies", ft = "toml" },
    
    -- Version management
    { "<leader>rcu", "<cmd>lua require('crates').update_crate()<cr>", desc = "Update crate", ft = "toml" },
    { "<leader>rcU", "<cmd>lua require('crates').update_all_crates()<cr>", desc = "Update all crates", ft = "toml" },
    { "<leader>rcg", "<cmd>lua require('crates').upgrade_crate()<cr>", desc = "Upgrade crate", ft = "toml" },
    { "<leader>rcG", "<cmd>lua require('crates').upgrade_all_crates()<cr>", desc = "Upgrade all crates", ft = "toml" },
    
    -- External resources
    { "<leader>rch", "<cmd>lua require('crates').open_homepage()<cr>", desc = "Open crate homepage", ft = "toml" },
    { "<leader>rcR", "<cmd>lua require('crates').open_repository()<cr>", desc = "Open crate repository", ft = "toml" },
    { "<leader>rcD", "<cmd>lua require('crates').open_documentation()<cr>", desc = "Open crate docs", ft = "toml" },
    { "<leader>rcC", "<cmd>lua require('crates').open_crates_io()<cr>", desc = "Open crates.io page", ft = "toml" },
    
    -- Visual mode operations for multiple crates
    { "<leader>rcu", "<cmd>lua require('crates').update_crates()<cr>", desc = "Update selected crates", mode = "v", ft = "toml" },
    { "<leader>rcg", "<cmd>lua require('crates').upgrade_crates()<cr>", desc = "Upgrade selected crates", mode = "v", ft = "toml" },
  },
}
