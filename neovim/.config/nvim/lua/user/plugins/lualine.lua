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
                    'filename',
                    path = 1,
                    fmt = function(filename)
                        if string.sub(filename, 1, string.len('term://')) == 'term://' then
                            local termname = 'terminal'
                            local prefix = '#toggleterm#'
                            local start = string.find(filename, prefix, 1, true)
                            if start ~= nil then
                                termname = termname .. ' ' .. string.sub(filename, start + string.len(prefix))
                            end
                            return termname
                        end
                        return filename
                    end,
                    symbols = {
                        modified = ' ',
                        readonly = ' ',
                    },
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
            lualine_y = {
                {
                    -- LSP client status
                    function()
                        local buf = vim.api.nvim_get_current_buf()
                        local clients = vim.tbl_values(vim.lsp.get_active_clients({ buffer = 0 }))
                        local attached = vim.tbl_filter(function(v)
                            return v.attached_buffers[buf]
                        end, clients)
                        local total = vim.tbl_count(attached)
                        if total > 1 then
                            return total .. ' LSP'
                        elseif total == 1 then
                            ---@diagnostic disable-next-line: undefined-field
                            return clients[1].name
                        end
                        return ''
                    end,
                    icon = '󱘖',
                    on_click = function()
                        vim.cmd.LspInfo()
                    end,
                },
                'filetype',
                'progress',
            },
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
