return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")
    local rmv = require("nvim-treesitter-textobjects.repeatable_move")

    local map = vim.keymap.set

    -- Select textobjects (x, o modes). `lookahead = true` is the default on main.
    local select_bindings = {
      { "a=", "@assignment.outer", "Select outer part of an assignment" },
      { "i=", "@assignment.inner", "Select inner part of an assignment" },
      { "l=", "@assignment.lhs", "Select left hand side of an assignment" },
      { "r=", "@assignment.rhs", "Select right hand side of an assignment" },
      { "aR", "@return.outer", "Select outer part of a return statement" },
      { "iR", "@return.inner", "Select inner part of a return statement" },
      { "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
      { "ia", "@parameter.inner", "Select inner part of a parameter/argument" },
      { "ai", "@conditional.outer", "Select outer part of a conditional" },
      { "ii", "@conditional.inner", "Select inner part of a conditional" },
      { "al", "@loop.outer", "Select outer part of a loop" },
      { "il", "@loop.inner", "Select inner part of a loop" },
      { "af", "@call.outer", "Select outer part of a function call" },
      { "if", "@call.inner", "Select inner part of a function call" },
      { "am", "@function.outer", "Select outer part of a method/function definition" },
      { "im", "@function.inner", "Select inner part of a method/function definition" },
      { "ac", "@class.outer", "Select outer part of a class" },
      { "ic", "@class.inner", "Select inner part of a class" },
      { "at", "@comment.outer", "Select outer part of a comment" },
      { "it", "@comment.inner", "Select inner part of a comment" },
      { "ab", "@block.outer", "Select outer part of a block" },
      { "ib", "@block.inner", "Select inner part of a block" },
    }
    for _, b in ipairs(select_bindings) do
      local lhs, query, desc = b[1], b[2], b[3]
      map({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = desc })
    end

    -- Move: next start
    local move_next_start = {
      { "]f", "@function.outer", "textobjects", "Next function start" },
      { "]c", "@class.outer", "textobjects", "Next class start" },
      { "]a", "@parameter.inner", "textobjects", "Next parameter start" },
      { "]i", "@conditional.outer", "textobjects", "Next conditional start" },
      { "]l", "@loop.outer", "textobjects", "Next loop start" },
      { "]b", "@block.outer", "textobjects", "Next block start" },
      { "]s", "@scope", "locals", "Next scope" },
      { "]z", "@fold", "folds", "Next fold" },
    }
    for _, b in ipairs(move_next_start) do
      local lhs, query, group, desc = b[1], b[2], b[3], b[4]
      map({ "n", "x", "o" }, lhs, function()
        move.goto_next_start(query, group)
      end, { desc = desc })
    end

    -- Move: next end
    local move_next_end = {
      { "]F", "@function.outer", "Next function end" },
      { "]C", "@class.outer", "Next class end" },
      { "]A", "@parameter.inner", "Next parameter end" },
      { "]I", "@conditional.outer", "Next conditional end" },
      { "]L", "@loop.outer", "Next loop end" },
      { "]B", "@block.outer", "Next block end" },
    }
    for _, b in ipairs(move_next_end) do
      local lhs, query, desc = b[1], b[2], b[3]
      map({ "n", "x", "o" }, lhs, function()
        move.goto_next_end(query, "textobjects")
      end, { desc = desc })
    end

    -- Move: previous start
    local move_prev_start = {
      { "[f", "@function.outer", "Previous function start" },
      { "[c", "@class.outer", "Previous class start" },
      { "[a", "@parameter.inner", "Previous parameter start" },
      { "[i", "@conditional.outer", "Previous conditional start" },
      { "[l", "@loop.outer", "Previous loop start" },
      { "[b", "@block.outer", "Previous block start" },
    }
    for _, b in ipairs(move_prev_start) do
      local lhs, query, desc = b[1], b[2], b[3]
      map({ "n", "x", "o" }, lhs, function()
        move.goto_previous_start(query, "textobjects")
      end, { desc = desc })
    end

    -- Move: previous end
    local move_prev_end = {
      { "[F", "@function.outer", "Previous function end" },
      { "[C", "@class.outer", "Previous class end" },
      { "[A", "@parameter.inner", "Previous parameter end" },
      { "[I", "@conditional.outer", "Previous conditional end" },
      { "[L", "@loop.outer", "Previous loop end" },
      { "[B", "@block.outer", "Previous block end" },
    }
    for _, b in ipairs(move_prev_end) do
      local lhs, query, desc = b[1], b[2], b[3]
      map({ "n", "x", "o" }, lhs, function()
        move.goto_previous_end(query, "textobjects")
      end, { desc = desc })
    end

    -- Swap next / previous
    local swap_next = {
      { "<leader>wa", "@parameter.inner", "Swap parameter with next" },
      { "<leader>wf", "@function.outer", "Swap function with next" },
      { "<leader>wb", "@block.outer", "Swap block with next" },
    }
    for _, b in ipairs(swap_next) do
      local lhs, query, desc = b[1], b[2], b[3]
      map("n", lhs, function()
        swap.swap_next(query)
      end, { desc = desc })
    end

    local swap_prev = {
      { "<leader>wA", "@parameter.inner", "Swap parameter with previous" },
      { "<leader>wF", "@function.outer", "Swap function with previous" },
      { "<leader>wB", "@block.outer", "Swap block with previous" },
    }
    for _, b in ipairs(swap_prev) do
      local lhs, query, desc = b[1], b[2], b[3]
      map("n", lhs, function()
        swap.swap_previous(query)
      end, { desc = desc })
    end

    -- Repeat last move in original / opposite direction
    map({ "n", "x", "o" }, ";", rmv.repeat_last_move)
    map({ "n", "x", "o" }, ",", rmv.repeat_last_move_opposite)

    -- Make builtin f/F/t/T repeatable with ; and ,
    map({ "n", "x", "o" }, "f", rmv.builtin_f_expr, { expr = true })
    map({ "n", "x", "o" }, "F", rmv.builtin_F_expr, { expr = true })
    map({ "n", "x", "o" }, "t", rmv.builtin_t_expr, { expr = true })
    map({ "n", "x", "o" }, "T", rmv.builtin_T_expr, { expr = true })
  end,
}
