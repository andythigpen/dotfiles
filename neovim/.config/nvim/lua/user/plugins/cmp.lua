return {
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
}
