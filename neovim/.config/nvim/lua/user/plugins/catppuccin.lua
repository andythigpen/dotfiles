return {
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
                CursorLineNr = { fg = colors.subtext0 },
                VirtColumn = { fg = colors.surface0 },
                AerialNormal = { bg = colors.mantle },
                PanelNormal = { bg = colors.mantle },
            }
        end,
        integrations = {
            aerial = true,
            cmp = true,
            mason = true,
            neogit = true,
            neotest = true,
            neotree = true,
            notify = true,
            telescope = {
                enabled = true,
            },
            treesitter = true,
            ufo = true,
            window_picker = true,
        },
    },
}
