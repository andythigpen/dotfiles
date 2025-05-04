-- local "plugins" that aren't worth splitting out into a separate repo...
vim.api.nvim_create_autocmd('User', {
    callback = function(ev)
        if ev.match ~= 'VeryLazy' then
            return
        end
        require('user.alternate').setup()
        require('user.projects').setup()
        require('user.toggle').setup()
    end,
})
