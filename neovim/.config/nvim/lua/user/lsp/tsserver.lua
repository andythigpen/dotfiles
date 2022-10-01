return {
	on_attach = function(client)
		-- disable document formatting in favor of using null-ls
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
}
