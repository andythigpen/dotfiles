return {
    'luukvbaal/statuscol.nvim',
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            ft_ignore = { 'dbee' },
            relculright = true,
            segments = {
                { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                {
                    sign = { name = { "Diagnostic" }, colwidth = 1, maxwidth = 1, auto = true },
                    click = "v:lua.ScSa"
                },
                { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
                {
                    sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
                    click = "v:lua.ScSa"
                },
                { text = { " " } },
            }
        })
    end,
}
