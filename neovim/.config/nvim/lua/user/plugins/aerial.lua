return {
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
    end
}
