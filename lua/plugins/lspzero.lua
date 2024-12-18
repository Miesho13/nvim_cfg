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


            -- nvim-cmp setup
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    -- Format completion menu with icons and colors
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',  -- Show symbol and text
                        maxwidth = 50,         -- Max width of the popup
                        ellipsis_char = '...', -- Truncate long entries
                        menu = {
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            path = "[Path]",
                        },
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                experimental = {
                    ghost_text = true,  -- Show inline ghost text (like VSCode)
                },
        })

        end,
    },
}
