return {
    --#region colorscheme & UI plugins
    {
        "rcarriga/nvim-notify",
        opts = { minimum_width = 20 },
    },
    {
        "stevearc/stickybuf.nvim",
        config = true,
    },
    {
        "stevearc/dressing.nvim",
        config = true,
    },
    {
        "lukas-reineke/virt-column.nvim",
        opts = { highlight = "VirtColumn" },
    },
    {
        "s1n7ax/nvim-window-picker",
        config = true,
    },
    --#endregion

    --#region text editing
    {
        "qpkorr/vim-bufkill",
    },
    {
        "numToStr/Comment.nvim",
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        config = true,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    --#endregion

    --#region treesitter
    { "nvim-treesitter/playground" },
    { "RRethy/nvim-treesitter-endwise" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    --#endregion

    --#region completion & snippets
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        config = function()
            require("user.snippets")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        config = function()
            require("user.completion")
        end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities,
            })
        end
    },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    --#endregion

    --#region LSP
    { "neovim/nvim-lspconfig" },
    { "onsails/lspkind-nvim" },
    { "williamboman/mason.nvim", opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
            local user_lsp = require("user.lsp")
            require("mason-lspconfig").setup_handlers({
                user_lsp.configure_lsp,
            })
        end
    },
    --#endregion

    --#region git
    {
        "FabijanZulj/blame.nvim",
        config = true,
    },
    --#endregion

    --#region unit testing
    { "nvim-neotest/neotest-python" },
    { "haydenmeade/neotest-jest" },
    { "nvim-neotest/neotest-go" },
    { "rouge8/neotest-rust" },
    --#endregion
}
