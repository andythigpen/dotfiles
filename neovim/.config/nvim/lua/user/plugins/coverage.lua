return {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<space>cl", function() require("coverage").load(true) end,             desc = "load coverage report" },
        { "<space>cc", function() require("coverage").clear() end,                desc = "clear coverage report" },
        { "<space>ct", function() require("coverage").toggle() end,               desc = "toggle coverage signs" },
        { "<space>cs", function() require("coverage").summary() end,              desc = "show coverage summary" },
        { "]u",        function() require("coverage").jump_next("uncovered") end, desc = "jump to next uncovered sign" },
        { "[u",        function() require("coverage").jump_prev("uncovered") end, desc = "jump to prev uncovered sign" },
    },
    opts = {
        auto_reload = true,
        load_coverage_cb = function(ftype)
            require("notify")(
                "Loaded " .. ftype .. " coverage",
                vim.log.levels.INFO,
                { render = "minimal", timeout = 1000, hide_from_history = true }
            )
        end,
    },
}
