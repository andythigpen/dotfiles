return {
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
}
