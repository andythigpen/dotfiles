return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "nvim-neotest/neotest-python", ft = "python" },
        { "haydenmeade/neotest-jest",    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" } },
        { "nvim-neotest/neotest-go",     ft = "go" },
        { "rouge8/neotest-rust",         ft = "rust" },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    args = { "--cov" },
                }),
                require("neotest-jest")({}),
                require("neotest-go")({
                    args = { "-race", "-covermode=atomic", "-coverprofile=coverage.out" },
                }),
                require("neotest-rust"),
            },
            icons = {
                unknown = '',
            },
            summary = {
                follow = false,
                expand_errors = false,
                mappings = {
                    output = "K",
                    next_failed = "<C-J>",
                    prev_failed = "<C-K>",
                    watch = "W",
                    mark = "m",
                    clear_marked = "<C-m>",
                    expand = { "<LeftMouse>", "	" },
                    jumpto = "<CR>",
                },
            },
        })
    end,
    keys = {
        { "]t",        function() require("neotest").jump.next({ status = "failed" }) end, desc = "jump to next failed test" },
        { "[t",        function() require("neotest").jump.prev({ status = "failed" }) end, desc = "jump to previous failed test" },
        { "<space>tn", function() require("neotest").run.run() end,                        desc = "run nearest test" },
        { "<space>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,      desc = "run file tests" },
        { "<space>tc", function() require("neotest").output_panel.clear() end,             desc = "clear test panel" },
        { "<space>tt", function() require("neotest").output_panel.toggle() end,            desc = "toggle test panel" },
        { "<space>ts", function() require("neotest").summary.toggle() end,                 desc = "toggle test summary" },
        { "<space>tl", function() require("neotest").run.run_last() end,                   desc = "run last test" },
    },
}
