local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
	on_attach = function(client)
		-- disable document formatting in favor of using null-ls & stylua
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end,
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
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				-- do not send telemetry data
				enable = false,
			},
		},
	},
}
