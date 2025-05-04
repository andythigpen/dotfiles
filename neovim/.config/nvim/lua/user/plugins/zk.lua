return {
    "zk-org/zk-nvim",
    config = function()
        require("zk").setup({
            picker = "telescope",
            lsp = {
                config = {
                    cmd = { "zk", "lsp" },
                    name = "zk",
                    on_attach = require("user.lsp").on_attach,
                },
            },
        })
    end
}
