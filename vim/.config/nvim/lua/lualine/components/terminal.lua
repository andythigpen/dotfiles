-- Based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filetype.lua
local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({
	highlight = "lualine.highlight",
	utils = "lualine.utils.utils",
})
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
	colored = true,
	icon_only = true,
	term_name = nil,
	icon_running = nil,
	icon_default = nil,
}

function M:init(options)
	M.super.init(self, options)
	self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
	local ok, terminal = pcall(require, "user.terminal")
	if ok then
		local status = terminal.status(self.options.term_name)
		if status == 2 then
			return "running"
		elseif status == 1 then
			return "configured"
		end
	end
	return ""
end

local icon_hl_cache = {}

function M:apply_icon()
	if not self.options.icons_enabled then
		return
	end

	local icon, icon_highlight_group
	local ok, terminal = pcall(require, "user.terminal")
	if ok then
		local status = terminal.status(self.options.term_name)
		if status == 2 then
			icon = self.options.icon_running or ""
			if terminal.is_visible(self.options.term_name) then
				icon_highlight_group = "TermStatusFocused"
			else
				icon_highlight_group = "TermStatusRunning"
			end
		elseif status == 1 then
			icon = self.options.icon_default or ""
			icon_highlight_group = "TermStatusDefault"
		end

		if icon and icon_highlight_group and self.options.colored then
			local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, "fg")
			if highlight_color then
				local default_highlight = self:get_default_hl()
				local icon_highlight = icon_hl_cache[highlight_color]
				if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. "_normal") then
					icon_highlight = modules.highlight.create_component_highlight_group(
						{ fg = highlight_color },
						icon_highlight_group,
						self.options,
						false
					)
					icon_hl_cache[highlight_color] = icon_highlight
				end

				icon = modules.highlight.component_format_highlight(icon_highlight) .. icon .. default_highlight
			end
		end
	end

	if not icon then
		return
	end

	if self.options.icon_only then
		self.status = icon
	else
		self.status = icon .. " " .. self.status
	end
end

return M
