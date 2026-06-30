local M = {}

local build_def_cmd = "./build.sh"
local ns_id = vim.api.nvim_create_namespace("build_output")

-- Define highlight groups
vim.api.nvim_set_hl(0, "MyErrorText",   { fg = "#ff5555", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "MyWarningText", { fg = "#ffaa00", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "MyPathText",    { fg = "#7a6146", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "MyNumberText",  { fg = "#0a86d3", bg = "NONE", bold = false })

local function apply_highlights(buf, line_nr, line_text)
    vim.api.nvim_buf_clear_namespace(buf, ns_id, line_nr - 1, line_nr)
    
    if line_text:match("error:") then
        local start, end_pos = line_text:find("error:")
        vim.api.nvim_buf_add_highlight(buf, ns_id, "MyErrorText", line_nr - 1, start - 1, end_pos)
    end
    
    if line_text:match("warning:") then
        local start, end_pos = line_text:find("warning:")
        vim.api.nvim_buf_add_highlight(buf, ns_id, "MyWarningText", line_nr - 1, start - 1, end_pos)
    end
    
    local path_pattern = "(/[%w%./%-_]+%.%w+)"
    for path in line_text:gmatch(path_pattern) do
        local start = line_text:find(path, 1, true)
        if start then
            vim.api.nvim_buf_add_highlight(buf, ns_id, "MyPathText", line_nr - 1, start - 1, start + #path - 1)
        end
    end
end

local function split_lines(data)
    local lines = vim.split(data, "\n")
    if lines[#lines] == "" then
        table.remove(lines)
    end
    return lines
end

function M.build(params)

    local origin_win = vim.api.nvim_get_current_win()
    local origin_buf = vim.api.nvim_get_current_buf()

    vim.cmd("botright split")
    vim.cmd("resize 20")

    local build_cmd = build_def_cmd
    if params ~= "" then
        build_cmd = params
    end
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    -- Set options
    vim.api.nvim_win_set_option(0, "wrap", true)
    vim.api.nvim_set_option_value("filetype", "c", { buf = buf })

    local obj = vim.system({build_cmd}, {
        stdout = function(_, data)
            if data then
                local lines = split_lines(data)
                vim.schedule(function() 
                    local line_before = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)

                    for i, line in ipairs(lines) do
                        apply_highlights(buf, line_before + i, line)
                    end

                    local line_count = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_win_set_cursor(0, {line_count, 0})
                end)
            end
        end,
        stderr = function(_, data)
            if data then
                local lines = split_lines(data)
                vim.schedule(function() 
                    local line_before = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)

                    for i, line in ipairs(lines) do
                        apply_highlights(buf, line_before + i, line)
                    end

                    local line_count = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_win_set_cursor(0, {line_count, 0})
                end)
            end
        end, 
        }, function(result)
            vim.schedule(function()
                local status_line = ""

                if result.code == 0 then
                    status_line = "Ok return status " .. result.code 
                else
                    status_line = "Err return status " .. result.code 
                end

                vim.api.nvim_buf_set_lines(buf, -1, -1, false, {status_line})

                -- Move cursor to end
                local line_count = vim.api.nvim_buf_line_count(buf)
                vim.api.nvim_win_set_cursor(0, {line_count, 0})
            end)
        end)

        vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
            noremap = true,
            silent = true,
            callback = function()
                local line = vim.api.nvim_get_current_line()
                local filepath, linenum = string.match(line, "([^:%s]+%.%a+):(%d+):%d+")

                if filepath and linenum then
                    vim.api.nvim_set_current_win(origin_win)

                    vim.cmd("edit " .. filepath)
                    vim.cmd(linenum)
                else
                    print("No jumpable location on this line")
                end
            end
        })
end

vim.api.nvim_create_user_command("Build", function(opts)
    M.build(opts.args)
end, { nargs = "*" })

vim.keymap.set("n", "<leader>c", function()
    M.build("")
end, { desc = "Oscillo build" })

return M
