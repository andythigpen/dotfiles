"TODO:
"   - use a max height(20), default height(5)

if !exists("g:BufferListHeight")
    let g:BufferListHeight = 10
endif

let g:BufferListName = '\[BufList\]'

augroup BufferList
    autocmd!
    autocmd BufEnter * call s:EnterBuffer()
    autocmd BufWipeOut,BufDelete * call s:DeleteBuffer()
augroup END

let g:BufferListMRU = {}
let s:buflist = []

function! s:EnterBuffer()
    let num = expand("<abuf>")
    if buflisted(num + 0) == 0
        return
    endif
    if !get(g:BufferListMRU, num, 0)
        let g:BufferListMRU[num] = len(g:BufferListMRU) + 1
    endif
    for b in keys(g:BufferListMRU)
        if g:BufferListMRU[b] < g:BufferListMRU[num]
            let g:BufferListMRU[b] += 1
        endif
    endfor
    let g:BufferListMRU[num] = 1
endfunction

function! s:DeleteBuffer()
    let num = expand("<abuf>")
    if has_key(g:BufferListMRU, num)
        call remove(g:BufferListMRU, num)
    endif
endfunction

function! s:SortMRU(i1, i2)
    let buf1 = g:BufferListMRU[a:i1.bufnr]
    let buf2 = g:BufferListMRU[a:i2.bufnr]
    return buf1 == buf2 ? 0 : buf1 > buf2 ? 1 : -1
endfunction

function! s:GetBufferList(num)
    redir => bufoutput
    buffers!
    redir END

    let ret = []
    for line in split(bufoutput, '\n')
        let buf = {}
        let parts = split(line, '"')
        let parts[0] = substitute(parts[0], '\s', '', 'g')
        let buf.line = substitute(parts[-1], '\s', '', 'g')
        let buf.bufnr = str2nr(parts[0])
        let buf.attrs = strpart(parts[0], match(parts[0], '[^0-9]'))
        let buf.str = line
        let buf.name = parts[1]
        let buf.mru = get(g:BufferListMRU, buf.bufnr, 0)
        let buf.unlisted = stridx(buf['attrs'], 'u') != -1

        if has_key(g:BufferListMRU, buf.bufnr) == 0
            let g:BufferListMRU[buf.bufnr] = len(g:BufferListMRU) + 1
        endif

        if a:num && buf.bufnr == a:num
            return buf
        endif
        call add(ret, buf)
    endfor
    return sort(ret, "s:SortMRU")
endfunction

function! s:BuildBufferMenu()
    for b in s:buflist
        if !b.unlisted
            call append(line('$'), b.str)
            " create a number mapping for each buffer
            execute "nnoremap <silent><buffer> ". b.bufnr ." :call <SID>CloseBufferList(". b.bufnr .")<CR>\<CR>"
        endif
    endfor
endfunction

function! s:SelectBuffer()
    let bufnr = str2nr(getline("."))
    if bufnr
        call s:CloseBufferList(bufnr)
    endif
endfunction

function! s:DeleteSelectedBuffer()
    let bufnr = str2nr(getline("."))
    if bufnr
        silent execute "normal! :".bufnr."bdelete\<CR>"
        for i in range(0, len(s:buflist))
            if s:buflist[i].bufnr == bufnr
                call remove(s:buflist, i)
                break
            endif
        endfor
        call s:CreateBufferList(0)
    endif
endfunction

function! s:SetupSyntax()
    syn match bufListModBuf    /^\s*\d\+.\{4}+.*/
    syn match bufListLockedBuf /^\s*\d\+.\{3}[\-=].*/
    syn match bufListHidBuf    /^\s*\d\+.\{2}h.*/
    syn match bufListActBuf    /^\s*\d\+.\{2}a.*/
    syn match bufListCurBuf    /^\s*\d\+.%.*/
    syn match bufListAltBuf    /^\s*\d\+.#.*/
    syn match bufListUnlBuf    /^\s*\d\+u.*/

    hi def link bufListActBuf Identifier
    hi def link bufListAltBuf String
    hi def link bufListCurBuf Type
    " hi def link bufListHidBuf Structure
    hi def link bufListLockedBuf Special
    hi def link bufListModBuf Exception
    hi def link bufListUnlBuf Comment
endfunction

function! s:CreateBufferWindow()
    let s:orig_buf = bufnr("%")
    silent keepalt botright split
    silent execute 'resize ' . g:BufferListHeight
    silent execute 'keepjumps hide edit ++enc=utf-8 '.g:BufferListName
    setlocal buftype=nofile
    setlocal bufhidden=unload       " reload the buffer every time
    setlocal noswapfile
    setlocal nobuflisted
    setlocal statusline="[BufList]"

    if has("syntax")
        call s:SetupSyntax()
    endif

    nnoremap <silent><buffer> <CR> :call <SID>SelectBuffer()<CR>
    nnoremap <silent><buffer> o :call <SID>SelectBuffer()<CR>
    nnoremap <silent><buffer> d :call <SID>DeleteSelectedBuffer()<CR>
    nnoremap <silent><buffer> q :call <SID>CloseBufferList(0)<CR>
endfunction

function! s:CloseBufferList(bufnr)
    silent execute "normal! :bd".bufnr(g:BufferListName)."\<CR>"
    if exists("s:orig_buf")
        let winr = bufwinnr(s:orig_buf + 0)
        silent execute winr . "wincmd w"
        if a:bufnr && bufexists(a:bufnr)
            silent execute "normal! :".a:bufnr."buffer\<CR>"
        endif
    endif
endfunction

function! s:CreateBufferList(new_win)
    setlocal modifiable
    if !a:new_win
        let save_cursor = getpos(".")
        silent normal! gg"_dG
    else
        silent let s:buflist = s:GetBufferList(0)
        call s:CreateBufferWindow()
    endif
    call s:BuildBufferMenu()
    if !a:new_win
        call setpos('.', save_cursor)
    else
        call cursor(2, 0)
    endif
    setlocal nomodifiable
endfunction

function! s:ToggleBufferList()
    if bufwinnr(g:BufferListName) != -1
        call s:CloseBufferList(0)
    else
        call s:CreateBufferList(1)
    endif
endfunction

nnoremap <silent><leader>ls :call <SID>ToggleBufferList()<CR>

