local fn = vim.fn
local o = vim.o
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	o.runtimepath = fn.stdpath("data") .. "/site/pack/*/start/*," .. o.runtimepath
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- colorscheme and look/feel plugins
	use({
		"marko-cerovac/material.nvim",
		config = function()
			require("user.colorscheme")
		end,
	})
	use({
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup()
		end,
	})
	use("ryanoasis/vim-devicons")
	use("kyazdani42/nvim-web-devicons")
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("user.statusline")
		end,
	})
	use({
		"startup-nvim/startup.nvim",
		config = function()
			require("user.startup")
		end,
	})
	use({
		"s1n7ax/nvim-window-picker",
		after = "material.nvim",
		config = function()
			local colors = require("material.colors")
			require("window-picker").setup({
				other_win_hl_color = colors.darkblue,
			})
		end,
	})
	use({
		"rafcamlet/tabline-framework.nvim",
		config = function()
			require("user.tabline")
		end,
	})

	-- text editing plugins
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("tpope/vim-abolish")

	-- fuzzy find plugins
	use({
		"nvim-telescope/telescope.nvim",
		after = "trouble.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("user.telescope")
		end,
	})

	-- snippets
	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("user.snippets")
		end,
	})

	-- completion plugins
	use({
		"hrsh7th/nvim-cmp",
		after = { "LuaSnip", "lspkind-nvim" },
		config = function()
			require("user.completion")
		end,
	})
	use({
		"hrsh7th/cmp-nvim-lsp",
		after = { "nvim-cmp", "nvim-lspconfig" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").update_capabilities(
				vim.lsp.protocol.make_client_capabilities()
			)
			local lspconfig = require("lspconfig")
			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = capabilities,
			})
		end,
	})
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
	use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })

	-- LSP related plugins
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				-- if there's only one entry, automatically jump to it for these modes
				auto_jump = { "lsp_definitions", "lsp_implementations", "lsp_type_definitions" },
			})
			vim.keymap.set("n", "<space>x", ":TroubleClose<CR>", { silent = true })
		end,
	})
	use("onsails/lspkind-nvim")
	use("neovim/nvim-lspconfig")
	use({
		"ray-x/lsp_signature.nvim",
		config = function()
			local lsp_signature_opts = {
				hint_enable = false,
			}
			if vim.env.NVIM_FILLED_BOXES then
				lsp_signature_opts.bind = true
				lsp_signature_opts.handler_opts = {
					border = require("user.borders"),
				}
			end
			require("lsp_signature").setup(lsp_signature_opts)
		end,
	})
	use({
		"williamboman/nvim-lsp-installer",
		after = { "lsp_signature.nvim", "cmp-nvim-lsp", "null-ls.nvim" },
		requires = "neovim/nvim-lspconfig",
		config = function()
			require("user.lsp")
		end,
	})
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})
	use({
		"WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
		config = function()
			local toggle_lsp_diagnostics = require("toggle_lsp_diagnostics")
			toggle_lsp_diagnostics.init({ virtual_text = false })
			local toggle_diagnostics = function()
				if toggle_lsp_diagnostics.settings.all then
					toggle_lsp_diagnostics.turn_off_diagnostics()
				else
					toggle_lsp_diagnostics.turn_on_diagnostics_default()
				end
			end
			vim.keymap.set("n", "<space>d", toggle_diagnostics, { silent = true })
		end,
	})
	use("jose-elias-alvarez/null-ls.nvim")

	-- tmux related plugins
	use({
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
		end,
	})

	-- project plugins
	use({
		"tpope/vim-dispatch",
		config = function()
			vim.cmd([[
        let g:dispatch_handlers = [ 'tmux' ]
        let g:dispatch_compilers = {
            \ 'pipenv run': ''}
      ]])
			vim.keymap.set("n", "<leader>d", ":Dispatch!<CR>", { silent = true })
			vim.keymap.set("n", "<leader>D", ":Dispatch<CR>", { silent = true })
			vim.keymap.set("n", "<leader>m", ":Make!<CR>", { silent = true })
			vim.keymap.set("n", "<leader>M", ":Make<CR>", { silent = true })
		end,
	})
	use({
		"tpope/vim-projectionist",
		config = function()
			-- alternate file key mapping support projections (<leader>a)
			vim.cmd([[
         if !exists('g:projectionist_transformations')
             let g:projectionist_transformations = {}
         endif
         function! g:projectionist_transformations.escapespace(input, o) abort
             return substitute(a:input, ' ', '\\\\ ', 'g')
         endfunction
       ]])
			vim.keymap.set("n", "<space>r", ":lua require('user.terminal').run()<CR>", { silent = true })
		end,
	})

	-- file & source navigation plugins
	use({
		"stevearc/aerial.nvim",
		config = function()
			require("user.aerial")
		end,
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		config = function()
			require("user.neotree")
		end,
	})
	use({
		"kshenoy/vim-signature",
	})

	-- treesitter plugins
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("user.treesitter")
		end,
	})
	use({ "nvim-treesitter/playground", after = "nvim-treesitter" })
	use({ "RRethy/nvim-treesitter-endwise", after = "nvim-treesitter", ft = { "ruby", "lua", "vimscript", "bash" } })

	-- terminal plugins
	use("voldikss/vim-floaterm")

	-- git plugins
	use({
		"tpope/vim-fugitive",
		config = function()
			require("user.fugitive")
		end,
	})
	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			local cb = require("diffview.config").diffview_callback
			require("diffview").setup({
				key_bindings = {
					view = {
						["<leader>f"] = cb("toggle_files"), -- Toggle the files panel.
						["<leader>]"] = cb("select_next_entry"), -- Open the diff for the next file
						["<leader>["] = cb("select_prev_entry"), -- Open the diff for the previous file
					},
					file_panel = {
						["<leader>f"] = cb("toggle_files"), -- Toggle the files panel.
						["<leader>]"] = cb("select_next_entry"), -- Open the diff for the next file
						["<leader>["] = cb("select_prev_entry"), -- Open the diff for the previous file
					},
				},
			})
		end,
	})

	-- unit testing plugins
	use("vim-test/vim-test")
	use({
		"rcarriga/vim-ultest",
		after = "vim-test",
		run = ":UpdateRemotePlugins",
		config = function()
			require("user.ultest")
		end,
	})
	use({
		"andythigpen/nvim-coverage",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("user.coverage")
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
