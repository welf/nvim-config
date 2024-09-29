-- Automatically add closing tags for HTML and JSX
return {
  "windwp/nvim-ts-autotag",
  event = "BufReadPre",
  opts = {
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    -- enable_close_on_slash = true, -- Auto close on trailing </
  },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
