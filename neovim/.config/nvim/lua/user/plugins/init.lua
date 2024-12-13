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

    --#region snippets
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        config = function()
            require("user.snippets")
        end,
    },
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

    --#region DAP
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("user.debugger")
        end
    },
    --#endregion
}
