local command = vim.api.nvim_create_user_command

-- create vim commands
command("FTermOpen", require("FTerm").open, { bang = true })
command("FTermClose", require("FTerm").close, { bang = true })
command("FTermExit", require("FTerm").exit, { bang = true })
command("FTermToggle", require("FTerm").toggle, { bang = true })

require("custom.remap")
