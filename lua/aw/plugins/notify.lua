return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 5000,
    render = "minimal",
    stages = "fade_in_slide_out",
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  },
}
