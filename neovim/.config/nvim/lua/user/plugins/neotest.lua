return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    args = { "--cov" },
                }),
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
        { "]t",        function() require("neotest").jump.next({ status = "failed" }) end },
        { "[t",        function() require("neotest").jump.prev({ status = "failed" }) end },
        { "<space>tn", function() require("neotest").run.run() end },
        { "<space>tf", function() require("neotest").run.run(vim.fn.expand("%")) end },
        { "<space>tc", function() require("neotest").output_panel.clear() end },
        { "<space>tt", function() require("neotest").output_panel.toggle() end },
        { "<space>ts", function() require("neotest").summary.toggle() end },
        { "<space>tl", function() require("neotest").run.run_last() end },
    },
}
