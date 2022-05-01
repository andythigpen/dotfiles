local fn = vim.fn
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
	vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath
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

	-- tmux related plugins
	use("christoomey/vim-tmux-navigator")

	-- file & source navigation plugins
	use({
		"stevearc/aerial.nvim",
		config = function()
			require("user.aerial")
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("user.nvimtree")
		end,
	})

	-- unit testing plugins
	use("vim-test/vim-test")
	use({ "rcarriga/vim-ultest", run = ":UpdateRemotePlugins" })
	use({
		"andythigpen/nvim-coverage",
		config = function()
			require("user.config")
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
