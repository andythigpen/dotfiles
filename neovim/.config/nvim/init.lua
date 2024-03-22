require("user.global")
require("user.options")
require("user.keymaps")

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

require("lazy").setup({
    --#region colorscheme & UI plugins
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd([[colorscheme catppuccin-mocha]])
        end,
        opts = {
            custom_highlights = function(colors)
                return {
                    VirtColumn = { fg = colors.surface0 },
                    AerialNormal = { bg = colors.mantle },
                }
            end,
            integrations = {
                aerial = true,
                cmp = true,
                mason = true,
                neotest = true,
                neotree = true,
                notify = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            minimum_width = 20,
        },
    },
    {
        "stevearc/stickybuf.nvim",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
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
    },
    {
        "lukas-reineke/virt-column.nvim",
        opts = {
            highlight = "VirtColumn",
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<S-Enter>",
                function()
                    require('noice').redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "redirect cmdline",
            },
        },
        opts = {
            cmdline = {
                format = {
                    search_down = { kind = "search", pattern = "^/\\v", icon = " ", lang = "regex" },
                },
            },
            lsp = {
                progress = {
                    enabled = true,
                },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            notify = {
                enabled = true,
            },
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },

    -- {
    --     "kevinhwang91/nvim-ufo",
    --     dependencies = { "kevinhwang91/promise-async" },
    --     keys = {
    --         { "zR", function() require('ufo').openAllFolds() end,  desc = "open all folds" },
    --         { "zM", function() require('ufo').closeAllFolds() end, desc = "close all folds" },
    --     },
    -- },

    {
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
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                mode = "tabs",
                always_show_bufferline = false,
            },
        },
    },
    {
        'luukvbaal/statuscol.nvim',
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
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
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },
    --#endregion

    --#region fuzzy find
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>b", "<cmd>Telescope buffers<cr>",    desc = "Telescope buffers" },
            { "<C-p>",     "<cmd>Telescope find_files<cr>", desc = "Telescope files" },
            { "<C-g>",     "<cmd>Telescope live_grep<cr>",  desc = "Telescope grep" },
        },
        opts = function(_, opts)
            local actions = require("telescope.actions")
            local function clear_prompt()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-u>", true, true, true), "n", true)
            end
            opts.defaults = {
                sorting_strategy = 'ascending',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                    },
                },
                mappings = {
                    n = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<C-a>"] = actions.select_all,
                        ["<C-b>"] = actions.results_scrolling_up,
                        ["<C-f>"] = actions.results_scrolling_down,
                        ["<PageUp>"] = actions.preview_scrolling_up,
                        ["<PageDown>"] = actions.preview_scrolling_down,
                    },
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<C-u>"] = clear_prompt,
                        ["<C-a>"] = actions.select_all,
                        ["<C-b>"] = actions.results_scrolling_up,
                        ["<C-f>"] = actions.results_scrolling_down,
                        ["<PageUp>"] = actions.preview_scrolling_up,
                        ["<PageDown>"] = actions.preview_scrolling_down,
                    },
                },
            }
            opts.pickers = {
                buffers = {
                    results_title = false,
                    mappings = {
                        n = {
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                    sort_mru = true,
                    ignore_current_buffer = true,
                },
            }
            return opts
        end,
    },
    --#endregion

    --#region tmux
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        config = function()
            vim.g.tmux_navigator_disable_when_zoomed = 1
        end,
    },
    --#endregion

    --#region file & source navigation
    {
        "stevearc/aerial.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>t", "<cmd>AerialToggle<cr>" },
        },
        opts = {
            close_on_select = true,
            layout = {
                max_width = 50,
                min_width = 50,
                default_direction = "right",
            },
        },
        config = function(_, opts)
            require('aerial').setup(opts)
            -- require('user.winbar')
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            -- the highlight group(s) are customized here because neo-tree always overrides them using an autocmd
            local flavour = require("catppuccin").flavour
            local palette = require("catppuccin.palettes").get_palette(flavour)
            vim.cmd([[highlight link NeoTreeWinSeparator NONE]])
            vim.cmd([[highlight NeoTreeWinSeparator guifg=]] .. palette.base)
            vim.cmd([[highlight NeoTreeEndOfBuffer guifg=]] .. palette.mantle)
        end,
        opts = {
            enable_diagnostics = false,
            popup_border_style = "single",
            window = {
                mappings = {
                    ["x"] = "close_node",
                    ["o"] = "open",
                    ["<c-v>"] = "open_vsplit",
                    ["<c-x>"] = "cut_to_clipboard",
                    ["H"] = "none",
                    ["z"] = "none",
                    ["oc"] = "none",
                    ["od"] = "none",
                    ["og"] = "none",
                    ["om"] = "none",
                    ["on"] = "none",
                    ["os"] = "none",
                    ["ot"] = "none",
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(_)
                        -- auto close on file open
                        require("neo-tree").close_all()
                    end,
                },
            },
            filesystem = {
                bind_to_cwd = false,
                window = {
                    mappings = {
                        ["C"] = "set_root",
                        ["i"] = "toggle_hidden",
                        ["u"] = "navigate_up",
                    },
                },
            },
        },
        keys = {
            { "<leader>f", "<cmd>Neotree toggle reveal_force_cwd<cr>" },
        },
    },
    {
        "s1n7ax/nvim-window-picker",
        opts = {},
    },
    --#endregion

    --#region text editing
    {
        "qpkorr/vim-bufkill",
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    --#endregion

    --#region treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = { "ruby", "go", "python", "yaml" },
                },
                endwise = {
                    enable = true,
                },
                ensure_installed = {
                    "tsx",
                    "toml",
                    "json",
                    "yaml",
                    "html",
                    "ruby",
                    "python",
                    "dockerfile",
                    "css",
                    "go",
                    "gomod",
                    "lua",
                    "typescript",
                    "rust",
                    "cpp",
                    "c",
                    "bash",
                    "comment",
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25,
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
                -- context_commentstring = { -- nvim-ts-context-commentstring
                --     enable = true,
                -- },
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = { "BufWrite", "CursorHold" },
                },
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * method: eg 'v' or 'o'
                        -- and should return the mode ('v', 'V', or '<c-v>') or a table
                        -- mapping query_strings to modes.
                        selection_modes = {
                            -- ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V',  -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true of false
                        -- include_surrounding_whitespace = true,
                    },
                },
            })

            vim.treesitter.language.register("javascript", "tsx")
            vim.treesitter.language.register("typescript.tsx", "tsx")

            -- use treesitter for folding
            -- vim.wo.foldmethod = "expr"
            -- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
        end,
    },
    { "nvim-treesitter/playground" },
    { "RRethy/nvim-treesitter-endwise" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    --#endregion

    --#region completion & snippets
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        config = function()
            require("user.snippets")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        config = function()
            require("user.completion")
        end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities,
            })
        end
    },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    --#endregion

    --#region LSP
    { "neovim/nvim-lspconfig" },
    { "onsails/lspkind-nvim" },
    { "williamboman/mason.nvim", opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
            local user_lsp = require("user.lsp")
            require("mason-lspconfig").setup_handlers({
                user_lsp.configure_lsp,
            })
        end
    },
    --#endregion

    --#region git
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true,
        keys = {
            { "<leader>g", function() require("neogit").open() end },
        },
    },
    --#endregion

    --#region unit testing
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--cov" },
                    }),
                    -- require("neotest-vim-test")({
                    --     ignore_file_types = { "python", "vim", "lua" },
                    -- }),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                    }),
                    require("neotest-go")({
                        args = { "-race", "-covermode=atomic", "-coverprofile=coverage.out" },
                    }),
                    require("neotest-rust"),
                },
            })
        end,
        keys = {
            { "]t", function()
                require("neotest").jump.next({ status = "failed" })
            end },
            { "[t", function()
                require("neotest").jump.prev({ status = "failed" })
            end },
            { "<space>tn", function()
                require("neotest").run.run()
            end },
            { "<space>tf", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end },
            { "<space>ts", function()
                require("neotest").summary.toggle()
            end },
            { "<space>tl", function()
                require("neotest").run.run_last()
            end },
        },
    },

    { "nvim-neotest/neotest-python" },
    { "haydenmeade/neotest-jest" },
    { "nvim-neotest/neotest-go" },
    { "rouge8/neotest-rust" },
    --#endregion
}, {
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

-- require("user.lsp")
