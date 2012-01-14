
" Tabs 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set expandtab
set smarttab
set nofoldenable

" Filetypes
filetype plugin on
filetype indent on

" UI
set ruler           " each window will contain a statusline
set statusline=%F%m%r%h%w\ [%{&ff}\|%Y]\ [CUR=\%03.3b\|\%02.2B]\ [POS=%04l:%04v][%p%%]
set laststatus=2    " always show statusline
set wildmenu        " command-line completion in enhanced mode
set showmatch       " show matching brackets when cursor is over
set scrolloff=3
set hidden
"set cursorline
set pastetoggle=<F9>
set linebreak
set showcmd
syntax enable
set t_Co=256        " enable 256 color mode
colorscheme tir_black

" Search options
set hls             " highlight search results
set incsearch       " search whilst typing
set ignorecase      " ignore case when searching
set smartcase       " override ignorecase if search contains upper-case

" Visual mode (from amix.dk/vim/vimrc.html)
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Autocomplete
"inoremap ( ()<Esc>i
"inoremap { {}<Esc>i
"inoremap [ []<Esc>i
"inoremap < <><Esc>i

autocmd! bufwritepost .vimrc source %

" Snippets
let g:snips_author = '${author}'

" Restore cursor
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" switch between related files
noremap ,a :A<CR>

" spelling
if version >= 700
    set spl=en spell
    set nospell
    noremap <F2> :set spell!<CR>
endif

" Create blank lines and stay in normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


