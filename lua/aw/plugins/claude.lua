return {
  "pasky/claude.vim",
  lazy = false,
  config = function()
    -- Load API key from environment variable
    local api_key = os.getenv("ANTHROPIC_API_KEY")
    if api_key then
      vim.g.claude_api_key = api_key
    else
      vim.notify("ANTHROPIC_API_KEY environment variable is not set", vim.log.levels.WARN)
    end
  end,
}
