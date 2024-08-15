return {
    "nvim-telescope/telescope.nvim",
    config = function()
        require('telescope').setup{ }
        local tele = require("telescope.builtin")
        vim.keymap.set('n', "<leader><leader>", tele.find_files, {})
        vim.keymap.set('n', "<leader>g",  tele.git_files, {})
        vim.keymap.set('n', "<leader>fg", tele.live_grep, {})
        vim.keymap.set('n', "<leader>fb", tele.buffers, {})
        vim.keymap.set('n', "<leader>fh", tele.help_tags, {})
        vim.keymap.set('n', "<leader>ff", tele.grep_string, {})
    end,
}
