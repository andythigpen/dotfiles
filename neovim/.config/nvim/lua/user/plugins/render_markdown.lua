return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = { lsp = { enabled = true } },
        file_types = { 'markdown', 'gitcommit' },
        heading = {
            left_pad = 1,
            position = 'inline',
        },
    },
}
