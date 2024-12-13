-- from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals.lua
P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return require("plenary.reload").reload_module(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

local ui_open = vim.ui.open
vim.ui.open = function(v)
    -- open URLs on host machine when ssh'd into another machine
    if vim.env.SSH_CLIENT ~= nil and string.match(v, '[a-z]*://[^ >,;]*') then
        return vim.system({ 'open-on-host', v }, { timeout = 10000 })
    end
    return ui_open(v)
end

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end
})
