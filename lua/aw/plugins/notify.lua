return {
  "rcarriga/nvim-notify",
  opts = {
    background_colour = "#21283b",
    timeout = 5000,
    render = "minimal",
    stages = "fade_in_slide_out",
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = true })
    end,
  },
}
