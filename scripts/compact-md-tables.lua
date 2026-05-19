-- Compact GFM markdown tables: strip column-alignment padding.
--
---@diagnostic disable: no-unknown
--
-- Reads markdown from stdin, writes compacted markdown to stdout. Used as a
-- conform.nvim formatter step that runs *after* the base markdown formatter
-- (dprint). Aligning formatters pad every cell in a column to the width of
-- that column's widest cell, so a single huge cell blows up the whole column
-- (and emits a wall of dashes in the separator row). This step rewrites every
-- table row with single-space cell padding: short rows stay short, the wide
-- cell stays on its own line, and the separator collapses to `| --- | --- |`.
--
-- Run as a plain Lua script via `nvim -l`, so there is no external runtime
-- dependency beyond Neovim itself.

local input = io.read("*a") or ""

local ends_with_nl = input:sub(-1) == "\n"
local body = ends_with_nl and input:sub(1, -2) or input

local lines = {}
for line in (body .. "\n"):gmatch("([^\n]*)\n") do
  lines[#lines + 1] = line
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Split a table row's content into raw cells, splitting only on *unescaped*
-- pipes. A backslash escapes the following character (so `\|` stays inside a
-- cell, as GFM requires for literal pipes).
local function split_cells(content)
  local cells, cur = {}, {}
  local i, n = 1, #content
  while i <= n do
    local c = content:sub(i, i)
    if c == "\\" and i < n then
      cur[#cur + 1] = content:sub(i, i + 1)
      i = i + 2
    elseif c == "|" then
      cells[#cells + 1] = table.concat(cur)
      cur = {}
      i = i + 1
    else
      cur[#cur + 1] = c
      i = i + 1
    end
  end
  cells[#cells + 1] = table.concat(cur)
  -- Drop the empty fragments created by a leading / trailing pipe.
  if #cells > 1 and trim(cells[1]) == "" then
    table.remove(cells, 1)
  end
  if #cells > 1 and trim(cells[#cells]) == "" then
    table.remove(cells, #cells)
  end
  return cells
end

-- A delimiter cell is `---`, optionally with alignment colons: `:--`, `--:`,
-- `:-:`.
local function is_delim_cell(c)
  return trim(c):match("^:?%-+:?$") ~= nil
end

-- True when `content` is a GFM delimiter row (every cell is a delimiter cell).
-- Requires a pipe so a lone `---` thematic break is never mistaken for one.
local function is_delim_row(content)
  if not content:find("|", 1, true) then
    return false
  end
  local cells = split_cells(content)
  if #cells == 0 then
    return false
  end
  for _, c in ipairs(cells) do
    if not is_delim_cell(c) then
      return false
    end
  end
  return true
end

-- Collapse a delimiter cell to `---` while preserving its alignment colons.
local function compact_delim_cell(c)
  local t = trim(c)
  local left = t:sub(1, 1) == ":"
  local right = t:sub(-1) == ":"
  if left and right then
    return ":---:"
  elseif left then
    return ":---"
  elseif right then
    return "---:"
  end
  return "---"
end

-- Rewrite one table line with single-space cell padding, preserving the
-- line's leading indentation (tables nested in lists / blockquotes).
local function compact_table_line(line, is_delim)
  local indent, content = line:match("^(%s*)(.*)$")
  local cells = split_cells(content)
  local parts = {}
  for _, c in ipairs(cells) do
    parts[#parts + 1] = is_delim and compact_delim_cell(c) or trim(c)
  end
  return indent .. "| " .. table.concat(parts, " | ") .. " |"
end

-- Length of a leading run of `ch` (3+ means a code fence marker).
local function fence_run(stripped, ch)
  local pat = ch == "`" and "^(`+)" or "^(~+)"
  return stripped:match(pat)
end

local out = {}
local in_fence = false
local fence_marker = nil
local i = 1

while i <= #lines do
  local line = lines[i]
  local stripped = trim(line)

  if in_fence then
    -- Never touch the contents of a fenced code block.
    out[#out + 1] = line
    local marker = fence_marker or ""
    local close = fence_run(stripped, marker:sub(1, 1))
    if close and #close >= #marker and stripped == close then
      in_fence, fence_marker = false, nil
    end
    i = i + 1
  else
    local ticks = fence_run(stripped, "`")
    local tildes = fence_run(stripped, "~")
    if (ticks and #ticks >= 3) or (tildes and #tildes >= 3) then
      in_fence = true
      fence_marker = ticks and #ticks >= 3 and ticks or tildes
      out[#out + 1] = line
      i = i + 1
    elseif i > 1 and is_delim_row(stripped) then
      -- Line `i` is a delimiter row and line `i-1` (already in `out`) is its
      -- header. Recompact the header, the delimiter, then the body rows.
      local header = lines[i - 1]
      if trim(header) ~= "" and header:find("|", 1, true) then
        out[#out] = compact_table_line(header, false)
        out[#out + 1] = compact_table_line(line, true)
        i = i + 1
        while i <= #lines do
          local row = lines[i]
          local rstripped = trim(row)
          if rstripped == "" or not row:find("|", 1, true) then
            break
          end
          local bt = fence_run(rstripped, "`") or fence_run(rstripped, "~")
          if bt and #bt >= 3 then
            break
          end
          out[#out + 1] = compact_table_line(row, false)
          i = i + 1
        end
      else
        out[#out + 1] = line
        i = i + 1
      end
    else
      out[#out + 1] = line
      i = i + 1
    end
  end
end

io.write(table.concat(out, "\n"))
if ends_with_nl then
  io.write("\n")
end
