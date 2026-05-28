vim.lsp.config('pyright', {
    settings = {
        python = {
            analysis = {
                useLibraryCodeForTypes = true,
            },
            venvPath = "/home/andyt/.local/share/virtualenvs",
        },
    },
})
