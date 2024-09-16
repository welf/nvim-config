local opts = {
  enable_close = true, -- Auto close tags
  enable_rename = true, -- Auto rename pairs of tags
  enable_close_on_slash = false, -- Auto close on trailing </
  -- aliases = {
  --   ["your language here"] = "html",
  -- },
  -- -- Also override individual filetype configs, these take priority.
  -- -- Empty by default, useful if one of the "opts" global settings
  -- -- doesn't work well in a specific filetype
  -- per_filetype = {
  --   ["html"] = {
  --     enable_close = false,
  --   },
  -- },
}

return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup(opts)
  end,
}
