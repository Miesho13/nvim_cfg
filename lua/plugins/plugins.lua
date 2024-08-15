return {
    {'nvim-telescope/telescope.nvim', tag = '0.1.8'},
    {"nvim-treesitter/nvim-treesitter"},
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
    {'nvim-tree/nvim-web-devicons'},
    -- LSP
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

    {"nvim-lua/plenary.nvim"},

    -- Theme
    {"ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
    {"Shatur/neovim-ayu"},
    -- complition
}

