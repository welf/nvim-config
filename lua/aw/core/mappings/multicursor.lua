-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set
-- set Multicursor prefix
local mc_prefix = "<leader>M"

local mc = require("multicursor-nvim")

-- MULTICURSOR --
-- https://github.com/jake-stewart/multicursor.nvim
--
-- Add cursor below the main cursor.
map({ "n", "v" }, "<A-Up>", function()
  mc.addCursor("k")
end, { desc = "Add cursor below the main cursor" })

-- Add cursor above the main cursor.
map({ "n", "v" }, "<A-Down>", function()
  mc.addCursor("j")
end, { desc = "Add cursor above the main cursor" })

-- Add a cursor and jump to the next word under cursor.
map({ "n", "v" }, mc_prefix .. "a", function()
  mc.addCursor("*")
end, { desc = "[a]dd a cursor and jump to the next word under cursor" })
map({ "n", "v" }, "<C-n>", function()
  mc.addCursor("*")
end, { desc = "Add a cursor and jump to the [n]ext word under cursor" })

-- Jump to the next word under cursor but do not add a cursor.
map({ "n", "v" }, mc_prefix .. "s", function()
  mc.skipCursor("*")
end, { desc = "[s]kip and jump to the next word under cursor" })
map({ "n", "v" }, "<C-s>", function()
  mc.skipCursor("*")
end, { desc = "[s]kip and jump to the next word under cursor" })

-- Rotate the main cursor.
map({ "n", "v" }, "<right>", mc.nextCursor, { desc = "Make next cursor the main" })

map({ "n", "v" }, "<left>", mc.prevCursor, { desc = "Make previous cursor the main" })

-- Delete the main cursor.
map({ "n", "v" }, mc_prefix .. "x", mc.deleteCursor, { desc = "Delete the main cursor" })

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add/remove cursors with control + left click" })

-- Stop other cursors from moving to reposition the main cursor.
map({ "n", "v" }, mc_prefix .. "q", function()
  if mc.cursorsEnabled() then
    -- Stop other cursors from moving.
    -- This allows you to reposition the main cursor.
    mc.disableCursors()
  else
    mc.addCursor()
  end
end, { desc = "Stop other cursors to reposition the main" })

-- Clear all cursors.
map("n", "<ESC>c", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- Default <ESC>c handler.
  end
end, { desc = "[c]lear all cursors" })

-- Align cursor columns.
map("n", mc_prefix .. "A", mc.alignCursors, { desc = "[A]lign cursor columns" })

-- Split visual selections by regex.
map("v", mc_prefix .. "S", mc.splitCursors, { desc = "[S]plit visual selections by regex" })

-- Insert for each line of visual selections.
map("v", mc_prefix .. "i", mc.insertVisual, { desc = "[i]nsert for each line of visual selections" })

-- Append for each line of visual selections.
map("v", mc_prefix .. "a", mc.appendVisual, { desc = "[a]ppend for each line of visual selections" })

-- Match new cursors within visual selections by regex.
map("v", mc_prefix .. "m", mc.matchCursors, { desc = "[m]atch new cursors within visual selections by regex" })

-- Rotate visual selection contents forward.
map("v", mc_prefix .. "r", function()
  mc.transposeCursors(1)
end, { desc = "[r]otate visual selection contents forward" })

-- Rotate visual selection contents backwards.
map("v", mc_prefix .. "R", function()
  mc.transposeCursors(-1)
end, { desc = "[R]otate visual selection contents backwards" })
