return {
    "nvimtools/none-ls.nvim",
    cond = false,
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        local user_lsp = require("user.lsp")
        null_ls.setup({
            on_attach = user_lsp.on_attach,
            sources = {
                -- null_ls.builtins.formatting.black,
                -- null_ls.builtins.formatting.isort.with({ extra_args = { "--profile", "black" } }),
                -- null_ls.builtins.formatting.prettier,
                -- require("none-ls.diagnostics.eslint"),
            },
        })
    end,
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
