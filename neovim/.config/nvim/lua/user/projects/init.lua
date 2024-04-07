local M = {}

local info = debug.getinfo(1, 'S')
local module_directory = string.match(info.source, '^@(.*)/')
local module_filename = string.match(info.source, '/([^/]*)$')

---@class Project
---@field directory string root of the project
---@field on_load fun()

local projects = {}

local function load_project_configs()
    local files = vim.fs.find(function(name)
        return name:match('.*%.lua$') and not name:match('^' .. module_filename .. '$')
    end, {
        type = "file",
        path = module_directory,
    })
    for _, file in ipairs(files) do
        local mod = vim.fn.fnamemodify(file, ':t:r')
        local project = require('user.projects.' .. mod)
        if project.directory ~= nil then
            local directory = vim.fn.fnamemodify(project.directory, ':p')
            projects[directory] = project
        end
    end
end

local function load_project(directory)
    local project = projects[vim.fn.fnamemodify(directory, ':p')]
    if project == nil or project.on_load == nil then
        return
    end
    project.on_load()
end

M.setup = function()
    load_project_configs()
    load_project(vim.fn.getcwd())
    vim.api.nvim_create_autocmd('DirChanged', {
        callback = function(ev)
            load_project(ev.file)
        end
    })
end

return M
