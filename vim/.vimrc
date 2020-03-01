"
" vimrc
" Settings are divided into groups according to the output of :options
" The number for each section corresponds to the section number of :options
" Most of the help comments beside each option come from :options as well
"

set nocompatible  " disables vi compatibility

" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'JulesWang/css.vim'
" Plug 'rstacruz/sparkup'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-abolish'
Plug 'kburdett/vim-nuuid'
Plug 'hzchirs/vim-material'
" Plug 'python-mode/python-mode'
Plug 'tpope/vim-fugitive'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
"Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'

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
set shortmess+=c      " coc.nvim - don't give |ins-completion-menu| messages
" }}}

" 13 Editing text {{{
"set showmatch         " when inserting a bracket, briefly jump to its match

" allow bs over autoindent, line breaks, start of insert
set backspace=start,eol,indent

" do not display a preview window on autocomplete
set completeopt-=preview
" do not select the first item
set completeopt+=noselect
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
set fillchars=vert:│,fold:─

set background=dark
colorscheme vim-material

" adjust theme colors
highlight Normal guibg=#1A1E20
highlight ColorColumn guibg=#1D2224
highlight LineNr guibg=#1D2224
highlight SignColumn guibg=#1D2224
highlight Error guibg=#990000
highlight SignColumn guibg=#1D2224
highlight Pmenu guibg=#313236
highlight CursorLine guibg=#313236
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

" airline settings {{{
let g:airline_left_sep=''
let g:airline_right_sep=''
" shorten the airline mode indicators
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V',
    \ '' : 'V',
    \ 's'  : 'S',
    \ 'S'  : 'S',
    \ '' : 'S',
    \ }
let g:airline_theme='material'
let g:airline_highlighting_cache = 1

set noshowmode          " airline includes this info in the statusline
" }}}

" ultisnips settings {{{
let g:UltiSnipsExpandTrigger = "<c-e>"
let g:UltiSnipsEditSplit = "vertical"
" }}}

" fzf settings {{{
nnoremap <C-p> :FZF<CR>
nnoremap <silent><leader>b :Buffers<CR>
" }}}

" dispatch settings {{{
let g:dispatch_handlers = [ 'tmux' ]
nnoremap <leader>d :Dispatch!<CR>
nnoremap <leader>D :Dispatch<CR>
nnoremap <leader>c :Console<CR>
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
" }}}

" python-mode settings {{{
" let g:pymode_python = 'python3'
" let g:pymode_options_colorcolumn = 0
" }}}

" delimitMate settings {{{
let g:delimitMate_expand_cr = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 1
au FileType python let b:delimitMate_nesting_quotes = ['"', '''']

" Resolves an issue with YCM and delimitMate
" https://github.com/Valloric/YouCompleteMe/issues/2696
" imap <silent> <BS> <C-R>=YcmOnDeleteChar()<CR><Plug>delimitMateBS
"
" function! YcmOnDeleteChar()
"   if pumvisible()
"     return "\<C-y>"
"   endif
"   return ""
" endfunction
" }}}

" gutentags settings {{{
" let g:gutentags_modules = ['ctags', 'cscope']
" let g:gutentags_file_list_command = 'rg --files'
" let g:gutentags_cache_dir = '~/.vim/gutentags'
" }}}

" emmet-vim settings {{{
" let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
  \      'extends' : 'jsx',
  \  },
  \}
" }}}

" coc.nvim settings {{{
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select)
"xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}

" load local config, if it exists
if filereadable(glob("~/.vimrc_local"))
    source ~/.vimrc_local
endif
