return {
    'akinsho/toggleterm.nvim',
    keys = {
        {
            "<leader>1",
            function()
                local Terminal = require('toggleterm.terminal').Terminal
                local term     = Terminal:new({ count = 1 })
                term:toggle()
            end,
        },
        {
            "<leader>2",
            function()
                local Terminal = require('toggleterm.terminal').Terminal
                local term     = Terminal:new({ count = 2 })
                term:toggle()
            end,
        },
    },
    opts = {
        size = 15,
        winbar = {
            enabled = true,
        },
    },
}
