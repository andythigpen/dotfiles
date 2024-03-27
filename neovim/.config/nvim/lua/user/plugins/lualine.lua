return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            component_separators = '',
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = {
                {
                    'mode',
                    fmt = function(str) return str:sub(1, 1) end,
                    separator = { left = '' },
                    padding = { left = 0, right = 1 },
                },
            },
            lualine_b = {
                'branch',
                'diagnostics',
            },
            lualine_c = {
                {
                    'filename', path = 1,
                },
                '%=', --[[ add center components here in place of this comment ]]
            },
            lualine_x = {
                {
                    function()
                        return require("noice").api.statusline.mode.get()
                    end,
                    cond = function()
                        return require("noice").api.statusline.mode.has()
                    end,
                    color = { fg = "#ff9e64" },
                },
                {
                    '%{&ft == "toggleterm" ? "terminal (".b:toggle_number.")" : ""}',
                },
            },
            lualine_y = { 'filetype', 'progress' },
            lualine_z = {
                { 'location', separator = { right = '' }, left_padding = 2 },
            },
        },
        inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
    },
}
