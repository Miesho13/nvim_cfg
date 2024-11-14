return {
    {
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        },

        config = function()
            local lsp = require("lsp-zero")
            lsp.extend_lspconfig()

            lsp.preset('recommended')
            lsp.setup()

            lsp.on_attach(function(client, bufnr)
              lsp.default_keymaps({buffer = bufnr})
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                -- Replace the language servers listed here
                -- with the ones you want to install
                ensure_installed = {'clangd'},
                handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                }
                 
            })

            vim.diagnostic.config( {
                virtual_text = false,  -- Disable inline diagnostic text
                signs = true,          -- Enable signs in the gutter for errors/warnings
                underline = true,      -- Enable underlining for errors/warnings
                update_in_insert = false, -- Disable diagnostics while in insert mode
            })

            require'lspconfig'.clangd.setup{} 
        end,
    },
}
