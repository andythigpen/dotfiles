local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                runtime_path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                -- library = vim.api.nvim_get_runtime_file("", true),
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
            telemetry = {
                -- do not send telemetry data
                enable = false,
            },
        },
    },
}
