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
            require('lspconfig').clangd.setup({})
            lsp.preset('recommended')
            lsp.setup()

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


            -- copilition
        end,
    },
}
