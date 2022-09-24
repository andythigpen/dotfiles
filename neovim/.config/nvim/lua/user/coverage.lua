local keymap = vim.keymap.set

local coverage = require("coverage")

coverage.setup({
	auto_reload = true,
	load_coverage_cb = function(ftype)
		require("notify")(
			"Loaded " .. ftype .. " coverage",
			vim.log.levels.INFO,
			{ render = "minimal", timeout = 1000, hide_from_history = true }
		)
	end,
	highlights = {
		summary_normal = { link = "Normal" },
		summary_cursor_line = { link = "NormalFloat" },
	},
})

keymap("n", "<space>cl", function()
	coverage.load(true)
end, { silent = true })
keymap("n", "<space>cc", coverage.clear, { silent = true })
keymap("n", "<space>ct", coverage.toggle, { silent = true })
keymap("n", "<space>cs", coverage.summary, { silent = true })
