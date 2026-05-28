return {
    "sindrets/diffview.nvim",
    opts = {
        enhanced_diff_hl = true,
        keymaps = {
            file_panel = {
                { "n", "q", function() require("diffview").close() end, { desc = "Close the current diffview" } },
            }
        }
        -- hooks = {
        --     diff_buf_read = function()
        --         vim.opt_local.foldlevel = 99
        --         vim.opt_local.foldenable = false
        --     end,
        --     diff_buf_win_enter = function()
        --         vim.opt_local.foldlevel = 99
        --         vim.opt_local.foldenable = false
        --     end,
        -- },
    }
}
