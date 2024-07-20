return {
    "nvim-telescope/telescope.nvim",
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', "<leader><leader>", builtin.find_files, {})
    end,
}
