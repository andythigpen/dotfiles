return {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<space>cl", function() require("coverage").load(true) end },
        { "<space>cc", function() require("coverage").clear() end },
        { "<space>ct", function() require("coverage").toggle() end },
        { "<space>cs", function() require("coverage").summary() end },
        { "]u",        function() require("coverage").jump_next("uncovered") end },
        { "[u",        function() require("coverage").jump_prev("uncovered") end },
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
