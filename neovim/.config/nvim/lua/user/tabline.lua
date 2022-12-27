-- tabline configuration

local colors = require("material.colors")
local function render(f)
    f.make_tabs(function(info)
        f.add({ " ", fg = colors.editor.contrast })
        f.set_fg(not info.current and colors.editor.fg or nil)

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

        P({ selection = colors.editor.selection, contrast = colors.editor.contrast })
        f.add({
            " ",
            bg = info.current and colors.editor.selection or colors.editor.contrast,
            fg = colors.editor.contrast,
        })
    end)
end

require("tabline_framework").setup({
    render = render,
    hl = { fg = colors.main.white, bg = colors.editor.contrast },
    hl_sel = { fg = colors.main.white, bg = colors.editor.selection },
    hl_fill = { fg = colors.main.white, bg = colors.editor.contrast },
})
