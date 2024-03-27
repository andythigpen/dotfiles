return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>b", "<cmd>Telescope buffers<cr>",                desc = "Telescope buffers" },
        { "<leader>r", "<cmd>Telescope oldfiles only_cwd=true<cr>", desc = "Telescope recent files" },
        { "<C-p>",     "<cmd>Telescope find_files<cr>",             desc = "Telescope files" },
        { "<C-g>",     "<cmd>Telescope live_grep<cr>",              desc = "Telescope grep" },
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
}
