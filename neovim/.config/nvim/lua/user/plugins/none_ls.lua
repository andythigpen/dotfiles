return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort.with({ extra_args = { "--profile", "black" } }),
                null_ls.builtins.formatting.prettier,
            },
        })
    end,
    ft = { "python", "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
