
require('luasnip.config').setup{
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
}

-- keymappings
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-jump-prev", {})

-- loads snippets (snipmate format) from directories named "snippets" in the runtimepath
require("luasnip.loaders.from_snipmate").load()

-- load snippets defined in lua
-- require('user.snippets.all')


local luasnip = require("luasnip")

function _G.snippets_clear(initial)
	for m, _ in pairs(luasnip.snippets) do
		package.loaded["snippets."..m] = nil
	end
	luasnip.snippets = setmetatable({}, {
		__index = function(t, k)
			local ok, m = pcall(require, "snippets." .. k)
			if not ok and not string.match(m, "^module.*not found:") then
				error(m)
			end
			t[k] = ok and m or {}

			-- load snippets from snipmate-library
			require("luasnip.loaders.from_snipmate").load({include={k}})
			return t[k]
		end
	})
  if not initial then
    print('Reloaded snippets')
  end
end

_G.snippets_clear(true)

vim.cmd [[
augroup snippets_clear
au!
au BufWritePost */.config/nvim/lua/snippets/*.lua,*/.config/nvim/snippets/*.snippets lua _G.snippets_clear()
augroup END
]]

function _G.edit_ft(ext)
	-- returns table like {"lua", "all"}
	local fts = require("luasnip.util.util").get_snippet_filetypes()
	vim.ui.select(fts, {
		prompt = "Select which filetype to edit:"
	}, function(item, idx)
		-- selection aborted -> idx == nil
		if idx then
      if ext == "lua" then
        vim.cmd("edit ~/.config/nvim/lua/snippets/" .. item .. ".lua")
      else
        vim.cmd("edit ~/.config/nvim/snippets/" .. item .. ".snippets")
      end
		end
	end)
end

vim.cmd [[command! LuaSnipEditLua :lua _G.edit_ft('lua')]]
vim.cmd [[command! LuaSnipEdit :lua _G.edit_ft('snippets')]]


-- add custom local snippets below here
