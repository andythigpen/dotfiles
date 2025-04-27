return {
    display_text = {
        new = " ",
    },
    patterns = {
        -- typescript
        ['(.*)%.ts$'] = {
            {
                alternate = '[1].test.ts',
                description = 'test',
                condition = function(m)
                    return string.find(m, '%.test%.ts$') == nil
                end,
            },
        },
        ['(.*)%.test%.ts$'] = '[1].ts',

        -- go
        ['(.*)%.go$'] = {
            {
                alternate = '[1]_test.go',
                description = 'test',
                condition = function(m)
                    return string.find(m, '_test%.go$') == nil
                end,
            },
        },
        ['(.*)_test%.go$'] = '[1].go',

        -- c
        ['(.*)%.c$'] = {
            {
                alternate = '[1].h',
                description = 'header',
            },
        },
        ['(.*)%.h$'] = {
            {
                alternate = '[1].c',
                description = 'source',
                excludes = 'source',
            },
            {
                alternate = '[1].cpp',
                description = 'source',
                excludes = 'source',
            },
        },

        -- cpp
        ['(.*)%.cpp$'] = {
            {
                alternate = '[1].hpp',
                description = 'header',
                excludes = 'header',
            },
            {
                alternate = '[1].h',
                description = 'header',
                excludes = 'header',
            },
        },
        ['(.*)%.hpp$'] = {
            {
                alternate = '[1].cpp',
                description = 'source',
            },
        },

        -- ruby
        ['(.*)%.rb$'] = {
            {
                alternate = '[1].rb',
                description = 'spec',
                condition = function(m)
                    return string.find(m, '_spec%.rb$') == nil
                end,
                transform = function(m)
                    local spec_dir = require('user.alternate.transformers').find_upward_dir('spec', m)
                    local filename = vim.fn.fnamemodify(m, ":t")
                    return spec_dir .. '/' .. filename .. '_spec'
                end
            },
        },
        ['(.*)_spec%.rb$'] = {
            {
                alternate = '[1].rb',
                description = 'source',
                transform = function(m)
                    local lib_dir = require('user.alternate.transformers').find_upward_dir('lib', m)
                    local filename = vim.fn.fnamemodify(m, ":t")
                    return lib_dir .. '/' .. filename
                end,
            },
        },

        -- python
        ['(.*)%.py$'] = {
            {
                alternate = '[1].py',
                description = 'test',
                condition = function(m)
                    return string.find(vim.fn.fnamemodify(m, ':t'), '^test_') == nil
                end,
                transform = function(m)
                    local dir = vim.fn.fnamemodify(m, ":h")
                    local filename = vim.fn.fnamemodify(m, ":t")
                    return dir .. '/test_' .. filename
                end,
            },
            {
                alternate = '[1].py',
                description = 'source',
                condition = function(m)
                    return string.find(vim.fn.fnamemodify(m, ':t'), '^test_') ~= nil
                end,
                transform = function(m)
                    local dir = vim.fn.fnamemodify(m, ":h")
                    local filename = vim.fn.fnamemodify(m, ":t"):gsub('^test_', '')
                    return dir .. '/' .. filename
                end,
            },
        },

        -- rego
        ['(.*)%.rego'] = {
            {
                alternate = '[1]_test.rego',
                description = 'test',
                condition = function(m)
                    return string.find(m, '_test%.rego$') == nil
                end,
            },
        },
        ['(.*)_test%.rego$'] = '[1].rego',
    },
}
