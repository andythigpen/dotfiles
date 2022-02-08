"
" vimrc
" Settings are divided into groups according to the output of :options
" The number for each section corresponds to the section number of :options
" Most of the help comments beside each option come from :options as well
"

set nocompatible  " disables vi compatibility

let g:vimspector_enable_mappings = 'HUMAN'

" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'majutsushi/tagbar'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'JulesWang/css.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ryanoasis/vim-devicons'
Plug 'kshenoy/vim-signature'
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c'}
Plug 'qpkorr/vim-bufkill'
Plug 'lukas-reineke/virt-column.nvim'
Plug 'startup-nvim/startup.nvim'
Plug 'ThePrimeagen/harpoon'

" lua development
Plug 'rafcamlet/nvim-luapad'

" debugging {{{
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
" }}}

" testing {{{
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
" }}}

" colorscheme
Plug 'marko-cerovac/material.nvim'

" Tree sitter {{{
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
" }}}

" Telescope {{{
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
" }}}

" nvim-cmp completion {{{
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" }}}

" snippets {{{
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" }}}

" lsp helpers {{{
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'onsails/lspkind-nvim'
Plug 'j-hui/fidget.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
Plug 'folke/trouble.nvim'
" }}}

" status line {{{
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'
" }}}

call plug#end()
" }}}

" 2 Moving around, searching and patterns {{{
set incsearch     " show match for partly typed search command
set ignorecase    " ignore case when using a search pattern
set smartcase     " override 'ignorecase' when pattern has upper case characters
" }}}

" 4 Displaying text {{{
set scrolloff=3             " number of screen lines to show around the cursor
set linebreak               " wrap long lines at a character in 'breakat'
set lazyredraw              " don't redraw while executing macros
set relativenumber number   " show line numbers
set numberwidth=5           " line number gutter width
set cmdheight=2             " height of the bottom cmd bar in lines
" }}}

" 5 Syntax, highlighting and spelling {{{
filetype plugin on    " enable loading filetype plugins
filetype indent on    " enable loading filetype indent files
syntax enable         " enable syntax highlighting
set hlsearch          " highlight all matches for the last used search pattern
if version >= 700     " map spell check
    noremap <leader>sp :set spell!<CR>
endif

" change bg color after 80 chars
let &colorcolumn=join(range(81,81),",")
" }}}

" 6 Multiple windows {{{
set laststatus=2      " 0, 1 or 2; when to use a status line for the last window
set hidden            " don't unload a buffer when no longer shown in a window

" easier navigation between windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }}}

" 11 Messages and info {{{
set ruler             " show cursor position below each window
set showcmd           " show (partial) command keys in the status line
set shortmess+=c      " don't give |ins-completion-menu| messages
" }}}

" 13 Editing text {{{
"set showmatch         " when inserting a bracket, briefly jump to its match

" allow bs over autoindent, line breaks, start of insert
set backspace=start,eol,indent

set completeopt-=preview    " do not display a preview window on autocomplete
set completeopt+=noselect   " do not select the first item
set completeopt+=menuone    " display the menu even if only one match
" }}}

" 14 Tabs and indenting {{{
set tabstop=4         " number of spaces a <Tab> in the text stands for
set shiftwidth=4      " number of spaces used for each step of (auto)indent
set smarttab          " a <Tab> in an indent inserts 'shiftwidth' spaces
set softtabstop=4     " if non-zero, number of spaces to insert for a <Tab>
set shiftround        " round to 'shiftwidth' for "<<" and ">>"
set expandtab         " expand <Tab> to spaces in Insert mode
set autoindent        " automatically set the indent of a new line
"set smartindent       " do clever autoindenting
" }}}

" 15 Folding {{{
set nofoldenable

" \z is slightly faster to type than zA to toggle a fold
nnoremap <leader>z zA
" }}}

" 10 Swap file {{{
set updatetime=300  " helps with coc.nvim
" }}}

" 20 Command line editing {{{
set wildmenu        " command-line completion shows a list of matches
set wildignore+=*.pyc,*.o,*.obj,*.swp
" }}}

" 25 Various {{{
set signcolumn=yes
" }}}

" Newline mappings {{{
" insert new lines and stay in normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>
" }}}

" Colorscheme settings {{{
set t_Co=256                " enable 256 color terminal mode
" enable truecolor support in the terminal
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

" full lines for splits/folds
set fillchars=vert:\ ,fold:─

" adjust theme colors
function! CustomHighlights() abort
    highlight Normal ctermfg=145 ctermbg=16 guifg=#cbd1dd guibg=#181c1e
    highlight ColorColumn guibg=#1b1f21
    highlight LineNr guibg=#1b1f21
    highlight SignColumn guibg=#1b1f21
    highlight Error guifg=#2d343a guibg=#b74951
    highlight Todo guibg=NONE guifg=#FF5370 gui=NONE,bold
    highlight CursorLine guibg=#313236
    highlight Search cterm=bold,underline ctermfg=15 gui=bold,underline guifg=#ffffff guibg=none
    highlight Folded ctermfg=59 guifg=#5c6370 guibg=none
    highlight CursorLineNr cterm=bold ctermfg=145 ctermbg=16 guifg=#cbd1dd guibg=#1b1f21
    highlight SignatureMarkText ctermfg=11 guifg=#5D818E guibg=#1b1f21
    highlight GitGutterAdd guifg=#1f5e47
    highlight GitGutterChange guifg=#aa9e75

    " identifier
    highlight Identifier guifg=#BB9DE3

    highlight WildMenu ctermfg=238 ctermbg=167 guifg=#41484f guibg=#4dacfd
    highlight Pmenu ctermfg=0 ctermbg=13 guifg=#dce2e4 guibg=#313236
    highlight PmenuSel cterm=bold ctermfg=123 ctermbg=167 gui=bold guifg=#353a3f guibg=#4dacfd

    " coc signs
    highlight CocErrorSign gui=bold guifg=#b74951 guibg=#1b1f21
    highlight CocInfoSign ctermfg=12 guifg=#15aabf guibg=#1b1f21
    highlight CocHintSign ctermfg=12 guifg=#15aabf guibg=#1b1f21
    highlight CocWarningSign ctermfg=130 guifg=#ff922b guibg=#1b1f21

    highlight airline_error guibg=#b74951
    highlight airline_warning guibg=#ff922b

    " tabline
    highlight TabLine gui=none guibg=#272e36
    highlight TabLineSel gui=none guibg=#455A64
    highlight TabLineFill guifg=#181c1e

    " treesitter highlights
    highlight TSBoolean         guibg=NONE
    highlight TSConstant        guibg=NONE
    highlight TSConstructor     guibg=NONE
    highlight TSKeyword         guibg=NONE
    highlight TSKeywordOperator guibg=NONE
    highlight TSLabel           guibg=NONE
    highlight TSOperator        guibg=NONE
    highlight TSParameter       guibg=NONE
    highlight TSProperty        guibg=NONE
    highlight TSPunctBracket    guibg=NONE
    highlight TSPunctDelimiter  guibg=NONE
    highlight TSPunctSpecial    guibg=NONE
    highlight TSSymbol          guibg=NONE
    highlight TSTag             guibg=NONE
    highlight TSTagAttribute    guibg=NONE
    highlight TSTagDelimiter    guibg=NONE
    highlight TSVariable        guibg=NONE
    highlight TSVariableBuiltIn guibg=NONE

    " telescope
    highlight TelescopeBorder guifg=#272e36 guibg=#272e36
    highlight TelescopeNormal guibg=#272e36
    highlight TelescopePreviewTitle guifg=#272e36 guibg=#e67e80
    highlight TelescopePromptTitle guifg=#272e36 guibg=#83c092
    highlight TelescopeResultsTitle guifg=#272e36 guibg=#83c092
    highlight TelescopePromptNormal guibg=#455A64
    highlight TelescopePromptBorder guifg=#455A64 guibg=#455A64
endfunction
augroup CustomColors
    autocmd!
    autocmd ColorScheme vim-material call CustomHighlights()
augroup END

set background=dark
" }}}

" Generic leader mappings {{{
" toggle paste mode
set pastetoggle=<leader>\p

" clear the highlighting for the last search
nnoremap <silent><leader>h :nohlsearch<cr>

" automatically prepend very-magic search mode to all searches
nnoremap / /\v

" Quick-fix mappings {{{
" returns 1 if the quickfix window is open, 0 otherwise
function! IsQuickfixOpen()
    for i in range(1, winnr('$'))
        if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
            return 1
        endif
    endfor
endfunction

" Jumps to the next/prev buffer or quickfix item, depending on if the quickfix
" buffer is currently displayed or not
" direction: one of "next" or "previous"
function! GotoQuickfixOrBuffer(direction)
    if IsQuickfixOpen()
        let type = "c"
    else
        let type = "b"
    endif
    silent! execute "normal! :" . type . a:direction . "\<cr>"
endfunction

" use \[ and \] to move backward/forward between the error list or buffers,
" when appropriate
nnoremap <silent><leader>[ :call GotoQuickfixOrBuffer("previous")<cr>
nnoremap <silent><leader>] :call GotoQuickfixOrBuffer("next")<cr>
" use \backspace to switch back and forth between last opened buffer
nnoremap <silent><leader><BS> <c-^>

" Toggle quick-fix {{{
nnoremap <silent><leader>q :call QuickfixToggle()<cr>

function! QuickfixToggle()
    if IsQuickfixOpen()
        cclose
        if exists("g:quickfix_return_to_window")
            execute g:quickfix_return_to_window . "wincmd w"
        endif
    else
        let g:quickfix_return_to_window = winnr()
        Copen!
        copen
    endif
endfunction
" }}}

" }}}

" toggle alternate file (switches from .h to .c/cpp/etc)
nnoremap <leader>a :A<cr>

" toggle line numbers / sign column
nnoremap <silent><leader>n :call ToggleColumn()<CR>
function! ToggleColumn()
    if !exists("b:column_on") || b:column_on
        set signcolumn=no
        set nonumber
        set norelativenumber
        let b:column_on=0
    else
        set signcolumn=yes
        set number
        set relativenumber
        let b:column_on=1
    endif
endfunction

" deploy shortcuts
" nnoremap <silent><leader>dd :!deploy<CR>
" nnoremap <silent><leader>dc :!deploy -hm<CR>
" }}}

" Restore cursor postion {{{
" implementation moved to autoload/restore_view.vim
" only save folds/cursor info for views, not local mappings, etc.
set viewoptions=cursor,folds,slash,unix
" }}}

" cscope settings {{{
if has("cscope")
    set cscopetag           " always search cscope databases and tag files
    set csto=1              " prefer ctags first

    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose       " show a message when any other cscope db is added

    "TODO: http://vim.wikia.com/wiki/Avoid_automatic_jump_after_make
    " set cscopequickfix=s-,c-,d-,i-,t-,e-
    " nnoremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR><C-O>:copen<CR>

    " Cscope actions:
    " s: Find this C symbol
    " g: Find this definition
    " d: Find functions called by this function
    " c: Find functions calling this function
    " t: Find this text string
    " e: Find this egrep pattern
    " f: Find this file
    " i: Find files #including this file
    nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

endif
" }}}

" Unlimited undo {{{
if exists("+undofile")
    set undofile                " save undo history to a file
    set undodir=~/.vimundo      " directory to save undo files in
endif
" }}}

" NERDTree settings {{{
" problem with arrows in NERDTree ?
" try this:
" http://stackoverflow.com/questions/3766204/vim-doesnt-support-unicode
function! OpenNERDTree()
    if !empty(expand('%')) && empty(getbufvar(bufnr("%"), "&buftype"))
        " if the current buffer is a regular file with a filename, open
        " NERDTree focused on that file
        silent execute "normal! :NERDTreeToggle %\<CR>"
    else
        " otherwise, just toggle NERDTree
        silent execute "normal! :NERDTreeToggle\<CR>"
    endif
endfunction
nnoremap <silent><leader>f :call OpenNERDTree()<CR>
let g:NERDTreeQuitOnOpen = 1        " quit the file view after selecting a file
let g:NERDTreeShowBookmarks = 1     " show bookmarks by default
let g:NERDTreeRespectWildIgnore = 1 " respect wildignore
let g:NERDTreeWinSize = 50          " window width
" }}}

" Tagbar settings {{{
nnoremap <silent><leader>t :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
" }}}

" makeprg/keywordprg settings {{{
set keywordprg=man
" }}}

" fzf settings {{{
" nnoremap <C-p> :FZF<CR>
" nnoremap <silent><leader>b :Buffers<CR>
" }}}

" dispatch settings {{{
let g:dispatch_handlers = [ 'tmux' ]
let g:dispatch_compilers = {
    \ 'pipenv run': ''}
nnoremap <leader>d :Dispatch!<CR>
nnoremap <leader>D :Dispatch<CR>
" nnoremap <leader>c :Console<CR>
nnoremap <leader>m :Make!<CR>
nnoremap <leader>M :Make<CR>
" }}}

" projectionist settings {{{
" alternate file key mapping support projections (<leader>a)
if !exists('g:projectionist_transformations')
    let g:projectionist_transformations = {}
endif
function! g:projectionist_transformations.escapespace(input, o) abort
    return substitute(a:input, ' ', '\\\\ ', 'g')
endfunction
nnoremap <silent> <space>r  :<C-u>Start!<cr>
" }}}

" delimitMate settings {{{
let g:delimitMate_expand_cr = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 1
au FileType python let b:delimitMate_nesting_quotes = ['"', '''']
" }}}

" emmet-vim settings {{{
" let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
  \      'extends' : 'jsx',
  \  },
  \}
" }}}


" terminal settings {{{
tnoremap <Esc> <C-\><C-n>
" }}}

" vim-test / ultest settings {{{
let test#strategy = 'dispatch'
let test#enabled_runners = ["ruby#rspec", "python#pytest", "rust#cargotest"]

" iterm doesn't display the default correctly for some reason
let g:ultest_running_sign = '羽'
" let the subprocess think it's in an interactive session so it will print out
" colors, etc.
let g:ultest_use_pty = 1

nmap ]t <Plug>(ultest-next-fail)
nmap [t <Plug>(ultest-prev-fail)

nmap <silent> <space>tt :UltestSummary<CR>
nmap <silent> <space>tn :UltestNearest<CR>
nmap <silent> <space>tf :Ultest<CR>
nmap <silent> <space>ts :TestSuite<CR>
nmap <silent> <space>tl :UltestLast<CR>
nmap <silent> <space>tc :UltestClear<CR>
" }}}

" vim-tmux-navigator settings {{{
let g:tmux_navigator_disable_when_zoomed = 1
" }}}

" fugitive settings {{{
function! GetBufferList()
  return filter(range(1,bufnr('$')), 'buflisted(v:val)')
endfunction

function! GetMatchingBuffers(pattern)
  return filter(GetBufferList(), 'bufname(v:val) =~ a:pattern')
endfunction

function! WipeMatchingBuffers(pattern)
  let l:matchlist = GetMatchingBuffers(a:pattern)

  let l:count = len(l:matchlist)
  if l:count < 1
    " echo 'No buffers found matching pattern ' . a:pattern
    return
  endif

  if l:count == 1
    let l:suffix = ''
  else
    let l:suffix = 's'
  endif

  exec 'bw ' . join(l:matchlist, ' ')
  " echo 'Wiped ' . l:count . ' buffer' . l:suffix . '.'
endfunction

command! Gdiffoff call WipeMatchingBuffers('fugitive://')

function! ToggleGStatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
    Gdiffoff
  else
    Git
    15wincmd_
  endif
endfunction
command! ToggleGStatus :call ToggleGStatus()
nnoremap <silent> <leader>g :ToggleGStatus<cr>

augroup fugitive_au
  autocmd!
  autocmd FileType fugitive setlocal winfixheight
augroup END
" }}}

" vimspector settings {{{
nnoremap <silent> <F2> :VimspectorReset<CR>
nnoremap <silent> <space>dr :VimspectorReset<CR>
" }}}

" bufkill settings {{{
let g:BufKillCreateMappings=0
" }}}

" load local config, if it exists
if filereadable(glob("~/.vimrc_local"))
    source ~/.vimrc_local
endif
