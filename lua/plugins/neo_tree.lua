return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    window = {
                        mappings = {
                            ["<space>"] = "preview", -- Map spacebar to open preview
                        },
                    },
                    use_libuv_file_watcher = true, -- Use libuv for better file updates
                },
            })

        vim.keymap.set("n", "<leader>b", function()
            vim.cmd("Neotree float") -- Open Neo-tree in floating mode
        end)

        end,
    }
}

