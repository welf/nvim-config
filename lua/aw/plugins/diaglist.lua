return {
  "onsails/diaglist.nvim",
  event = "BufRead",
  config = function()
    require("diaglist").init({
      debug = false,
      -- increase for noisy servers
      debounce_ms = 150,
    })
  end,
}
