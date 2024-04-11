local M = {}

---@param upward_dir string
---@param m string
M.find_upward_dir = function(upward_dir, m)
    local dir = vim.fn.fnamemodify(m, ':~:.:h')
    local results = vim.fs.find(upward_dir, {
        upward = true,
        path = dir,
        stop = vim.fn.getcwd(),
        type = 'directory',
    })
    if #results == 1 then
        return results[1]
    end
    return upward_dir
end

return M
