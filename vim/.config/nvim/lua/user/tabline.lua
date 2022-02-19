-- tabline configuration

local colors = require("material.colors")
local function render(f)
	f.make_tabs(function(info)
		f.add({ " ", fg = colors.contrast })
		f.set_fg(not info.current and colors.fg or nil)

		f.add(info.index .. " ")

		if info.filename then
			f.add(info.modified and "+")
			f.add(info.filename)
			f.add({
				" " .. f.icon(info.filename),
				fg = info.current and f.icon_color(info.filename) or nil,
			})
		else
			f.add(info.modified and "[+]" or "[-]")
		end

		f.add({
			" ",
			bg = info.current and colors.selection or colors.contrast,
			fg = colors.contrast,
		})
	end)
end

require("tabline_framework").setup({
	render = render,
	hl = { fg = colors.white, bg = colors.contrast },
	hl_sel = { fg = colors.white, bg = colors.selection },
	hl_fill = { fg = colors.white, bg = colors.contrast },
})
