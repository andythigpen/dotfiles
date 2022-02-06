-- Based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filetype.lua
local lualine_require = require('lualine_require')
local modules = lualine_require.lazy_require {
  highlight = 'lualine.highlight',
  utils = 'lualine.utils.utils',
}
local M = lualine_require.require('lualine.component'):extend()

local default_options = {
  colored = true,
  icon_only = false,
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
end

local function ultest_status()
  local ok, devicons = pcall(require, 'ultest')
  if ok then
    return vim.call('ultest#status')
  end
  return nil
end

function M.update_status()
  local status = ultest_status()
  if status == nil then
    return ''
  elseif status.running > 0 then
    local total = status.passed + status.failed
    return tostring(total) .. ' / ' .. tostring(status.tests)
  elseif status.failed > 0 then
    return tostring(status.failed)
  elseif status.passed > 0 then
    return tostring(status.passed)
  end
  return '﫳'
end

function M:apply_icon()
  if not self.options.icons_enabled then
    return
  end

  local icon, icon_highlight_group
  local ok, devicons = pcall(require, 'ultest')
  if ok then
    local status = vim.call('ultest#status')
    if status.running > 0 then
      icon = ''
    elseif status.failed > 0 then
      icon = '✖'
      icon_highlight_group = 'UltestFail'
    elseif status.passed > 0 then
      icon = '✔'
      icon_highlight_group = 'UltestPass'
    end

    if icon and icon_highlight_group and self.options.colored then
      local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, 'fg')
      local default_highlight = modules.highlight.format_highlight(self.options.self.section)
      local icon_highlight = self.options.self.section .. '_' .. icon_highlight_group
      if not modules.highlight.highlight_exists(icon_highlight .. '_normal') then
        icon_highlight = modules.highlight.create_component_highlight_group(
          { fg = highlight_color },
          icon_highlight_group,
          self.options
        )
      end

      icon = modules.highlight.component_format_highlight(icon_highlight) .. icon .. default_highlight
    end
  end

  if not icon then
    return
  end

  if self.options.icon_only then
    self.status = icon
  else
    self.status = icon .. ' ' .. self.status
  end
end

return M
