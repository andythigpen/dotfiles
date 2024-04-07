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
    },
}
