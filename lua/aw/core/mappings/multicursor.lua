-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- set shorter name for keymap function
local map = vim.keymap.set

local mc = require("multicursor-nvim")

-- MULTICURSOR --
-- https://github.com/jake-stewart/multicursor.nvim
--
-- Add cursor below the main cursor.
map({ "n", "v" }, "<C-Up>", function()
  mc.addCursor("k")
end, { desc = "Add cursor below the main cursor" })

-- Add cursor above the main cursor.
map({ "n", "v" }, "<C-Down>", function()
  mc.addCursor("j")
end, { desc = "Add cursor above the main cursor" })

-- Add a cursor and jump to the next word under cursor.
map({ "n", "v" }, "<C-n>", function()
  mc.addCursor("*")
end, { desc = "Add a cursor and jump to the next word under cursor" })

-- Jump to the next word under cursor but do not add a cursor.
map({ "n", "v" }, "<C-s>", function()
  mc.skipCursor("*")
end, { desc = "Jump to the next word under cursor but do not add a cursor" })

-- Rotate the main cursor.
map({ "n", "v" }, "<right>", mc.nextCursor, { desc = "Make next cursor the main" })

map({ "n", "v" }, "<left>", mc.prevCursor, { desc = "Make previous cursor the main" })

-- Delete the main cursor.
map({ "n", "v" }, "<leader>x", mc.deleteCursor, { desc = "Delete the main cursor" })

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add and remove cursors with control + left click" })

-- Stop other cursors from moving to reposition the main cursor.
map({ "n", "v" }, "<C-q>", function()
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
end, { desc = "Clear all cursors" })

-- Align cursor columns.
map("n", "<leader>a", mc.alignCursors, { desc = "Align cursor columns" })

-- Split visual selections by regex.
map("v", "S", mc.splitCursors, { desc = "Split visual selections by regex" })

-- Insert for each line of visual selections.
map("v", "I", mc.insertVisual, { desc = "Insert for each line of visual selections" })

-- Append for each line of visual selections.
map("v", "A", mc.appendVisual, { desc = "Append for each line of visual selections" })

-- Match new cursors within visual selections by regex.
map("v", "M", mc.matchCursors, { desc = "Match new cursors within visual selections by regex" })

-- Rotate visual selection contents forward.
map("v", "<leader>r", function()
  mc.transposeCursors(1)
end, { desc = "Rotate visual selection contents forward" })

-- Rotate visual selection contents backwards.
map("v", "<leader>R", function()
  mc.transposeCursors(-1)
end, { desc = "Rotate visual selection contents backwards" })
