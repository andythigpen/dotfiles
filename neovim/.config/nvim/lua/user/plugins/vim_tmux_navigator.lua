return {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    config = function()
        vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
}
