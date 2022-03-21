require("coverage").setup({
	highlights = {
		summary_normal = { link = "Normal" },
		summary_cursor_line = { link = "NormalFloat" },
	},
})

vim.cmd([[
nnoremap <silent> <space>cl :lua require('coverage').load(true)<CR>
nnoremap <silent> <space>cc :lua require('coverage').clear()<CR>
nnoremap <silent> <space>ct :lua require('coverage').toggle()<CR>
nnoremap <silent> <space>cs :lua require('coverage').summary()<CR>
]])
