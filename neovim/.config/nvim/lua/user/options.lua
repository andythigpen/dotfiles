--
-- Settings are divided into groups according to the output of :options
-- The number for each section corresponds to the section number of :options
-- Most of the help comments beside each option come from :options as well
--

local opt = vim.opt
local g = vim.g

opt.pastetoggle = "<leader>p"

-- 2 Moving around, searching and patterns
opt.ignorecase = true -- ignore case when using a search pattern
opt.smartcase = true -- override 'ignorecase' when pattern has upper case characters

-- 4 Displaying text
opt.scrolloff = 3 -- number of screen lines to show around the cursor
opt.linebreak = true -- wrap long lines at a character in 'breakat'
opt.lazyredraw = true -- don't redraw while executing macros
opt.number = true -- print the line number for each line
opt.relativenumber = true -- show line numbers
opt.numberwidth = 5 -- line number gutter width
opt.cmdheight = 2 -- height of the bottom cmd bar in lines
opt.fillchars = "fold:─" -- characters to use for statusline, folds, filler lines

-- 5 Syntax, highlighting, and spelling
opt.colorcolumn = "101" -- highlight the 101 column boundary
opt.termguicolors = true

-- 6 Multiple windows
opt.laststatus = 3 -- enable global statusline

-- 11 Messages and info
opt.shortmess:append({ c = true }) -- don't give |ins-completion-menu| messages

-- 12 Selecting text
-- requires tmux 3.2+, also only want to set when using tmux
local tmux_version = vim.split(vim.env.TMUX_VERSION or "", ".", { plain = true })
if #tmux_version >= 2 and tonumber(tmux_version[1]) >= 3 and tonumber(tmux_version[2]) >= 2 then
	opt.clipboard = "unnamedplus"
	g.clipboard = {
		name = "tmux-osc52",
		copy = {
			["+"] = { "tmux", "load-buffer", "-w", "-" },
			["*"] = { "tmux", "load-buffer", "-w", "-" },
		},
		paste = {
			["+"] = { "tmux", "save-buffer", "-" },
			["*"] = { "tmux", "save-buffer", "-" },
		},
		["cache-enabled"] = 1,
	}
end

-- 13 Editing text
opt.undofile = true -- save undo history to a file
opt.completeopt:remove({ "preview" }) -- do not display a preview window on autocomplete
opt.completeopt:append({ "noselect", "menuone" }) -- do not select the first item (noselect), display the menu even if only one match (menuone)

-- 14 Tabs and indenting
opt.tabstop = 4 -- number of spaces a <Tab> in the text stands for
opt.shiftwidth = 4 -- number of spaces used for each step of (auto)indent
opt.softtabstop = 4 -- if non-zero, number of spaces to insert for a <Tab>
opt.shiftround = true -- round to 'shiftwidth' for "<<" and ">>"
opt.expandtab = true -- expand <Tab> to spaces in Insert mode

-- 20 Command line editing
opt.wildignore:append({ "*.pyc", "*.o", "*.obj", "*.swp" })

-- 25 Various
opt.signcolumn = "yes"
