return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { 'markdown', 'gitcommit' },
        heading = {
            position = 'inline',
        },
        anti_conceal = { enabled = false },
        win_options = {
            concealcursor = { rendered = 'nc' },
        },
    },
}
