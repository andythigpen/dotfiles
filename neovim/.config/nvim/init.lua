require('user')

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- old vim plugin settings
vim.g.BufKillCreateMappings = 0
-- end old vim plugin settings

require("lazy").setup("user.plugins", {
    install = {
        colorscheme = { "catppuccin-mocha" },
    },
    ui = {
        custom_keys = {
            ["<c-f>"] = {
                function()
                    vim.cmd([[exe "normal! \<c-f>"]])
                end,
                desc = "scroll down",
            },
        },
    },
})
