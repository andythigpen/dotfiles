return {
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
            hover = {
                enabled = true,
                silent = true,
            },
            progress = {
                enabled = true,
            },
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,     -- requires hrsh7th/nvim-cmp
            },
        },
        notify = {
            enabled = true,
        },
        presets = {
            bottom_search = false,            -- use a classic bottom cmdline for search
            command_palette = true,           -- position the cmdline and popupmenu together
            long_message_to_split = true,     -- long messages will be sent to a split
            inc_rename = false,               -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true,            -- add a border to hover docs and signature help
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
            {
                filter = {
                    event = "notify.info",
                    kind = "",
                    find = "Toggling hidden files",
                },
                opts = { skip = true },
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    }
}
