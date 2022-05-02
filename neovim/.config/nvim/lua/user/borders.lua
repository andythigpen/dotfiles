local border = "rounded"

if vim.env.NVIM_FILLED_BOXES then
	border = {
		{ "⠀", "FloatBorder" },
		{ "⠆", "FloatBorder" },
		{ "⠁", "FloatBorder" },
		{ "⠄", "FloatBorder" },
		{ "⠃", "FloatBorder" },
		{ "⠇", "FloatBorder" },
		{ "⠂", "FloatBorder" },
		{ "⠅", "FloatBorder" },
	}
end

return border
