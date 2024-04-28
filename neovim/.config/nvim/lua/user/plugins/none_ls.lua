return {
    "nvimtools/none-ls.nvim",
    cond = false,
    config = function()
        local null_ls = require("null-ls")
        local user_lsp = require("user.lsp")
        null_ls.setup({
            on_attach = user_lsp.on_attach,
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort.with({ extra_args = { "--profile", "black" } }),
                null_ls.builtins.formatting.prettier,
            },
        })
    end,
    ft = { "python", "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
}
