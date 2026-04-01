-- Minimal custom functions + commands

local M = {}

function M.grep(patern)

    local origin_win = vim.api.nvim_get_current_win()
    local origin_buf = vim.api.nvim_get_current_buf()

    vim.cmd("botright split")
    vim.cmd("resize 20")

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    local output = vim.fn.system({"grep", "-rn", patern})
    local lines = vim.split(output, "\n", { trimempty = true })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines);
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })

    vim.api.nvim_set_hl(0, "GrepMatch", { fg = "#db0202" })
    vim.api.nvim_set_hl(0, "GrepPath", { fg = "#18a035" })

    vim.fn.matchadd("GrepMatch", patern)
    vim.fn.matchadd("Number", [[^[^:]\+:\zs\d\+\ze:]])
    vim.fn.matchadd("GrepPath", [[^\zs[^:]\+\ze:]])

    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
        noremap = true,
        silent = true,
        callback = function()
            local line = vim.api.nvim_get_current_line()
            local filepath, linenum = line:match("^([^:]+):(%d+):")
            if not (filepath and linenum) then
                print("No jumpable location on this line")
                return
            end

            local grep_win = vim.api.nvim_get_current_win()
            local grep_pos = vim.api.nvim_win_get_cursor(grep_win)

            -- jump to origin window, open file there, go to line
            vim.api.nvim_set_current_win(origin_win)
            vim.cmd("keepalt keepjumps drop " .. vim.fn.fnameescape(filepath))
            vim.api.nvim_win_set_cursor(origin_win, { tonumber(linenum), 0 })

            -- immediately return to grep window and restore cursor position
            vim.api.nvim_set_current_win(grep_win)
            vim.api.nvim_win_set_cursor(grep_win, grep_pos)
        end,
    })


end

vim.api.nvim_create_user_command("Grep", function(opts)
  M.grep(opts.args)
end, { nargs = "*" })

return M
