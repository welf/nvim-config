-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

-- Copy last notification to clipboard
map("n", "<leader><C-n>", function()
  local notify = require("notify")
  local history = notify.history()
  if #history > 0 then
    local last_notification = history[#history]
    local text = last_notification.message
    if type(text) == "table" then
      text = table.concat(text, "\n")
    end
    vim.fn.setreg("+", text)
    vim.notify("Copied last notification to clipboard", vim.log.levels.INFO)
  else
    vim.notify("No notifications found", vim.log.levels.WARN)
  end
end, { desc = "Copy last notification to clipboard" })

-- Better escape to normal mode
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })


-- OPEN FILE LOCATION --
--
-- Open file's folder in file explorer
map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand("%:p:h"))
end, { desc = "[o]pen file [l]ocation in file explorer" })

-- Copy relative path to clipboard
map("n", "<leader><C-y>", function()
  local full_path = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  local relative_path = vim.fn.fnamemodify(full_path, ":~:.")
  
  -- If still absolute, try to make it relative to cwd
  if vim.startswith(relative_path, "/") then
    relative_path = vim.fn.substitute(full_path, "^" .. vim.fn.escape(cwd, "/") .. "/", "", "")
  end
  
  vim.fn.setreg("+", relative_path)
  vim.notify("Copied relative path: " .. relative_path)
end, { desc = "Copy relative path to clipboard" })

-- FILE EXPLORER --
--
-- Toggle neo-tree explorer (force override any existing mapping)
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle NeoTree [e]xplorer", remap = false, silent = true })
