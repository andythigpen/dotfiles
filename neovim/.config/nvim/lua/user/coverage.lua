local keymap = vim.keymap.set

local coverage = require("coverage")

coverage.setup({
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
