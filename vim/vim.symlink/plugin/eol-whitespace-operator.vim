" nnoremap <leader>w :match Error /\v\s+$/<cr>
" nnoremap <leader>W :%s/\v\s+$//<cr>
"
" nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
" vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>
"
" function! s:GrepOperator(type)
"     let saved_unnamed_register = @@
"
"     if a:type ==# 'v'
"         normal! `<v`>y
"     elseif a:type ==# 'char'
"         normal! `[v`]y
"     else
"         return
"     endif
"
"     silent execute "grep! -R " . shellescape(@@) . " ."
"     copen
"
"     let @@ = saved_unnamed_register
" endfunction


let s:eol_match_id = 0
function! s:ToggleEolWhitespaceMatch()
    if s:eol_match_id
        call matchdelete(s:eol_match_id)
        let s:eol_match_id = 0
        echom "Cleared EOL whitespace match"
    else
        let s:eol_match_id = matchadd("Error", '\s\+$')
        echom "Enabled EOL whitespace match"
    endif
endfunction

" use <leader>w to show EOL whitespace
nnoremap <silent><leader>w :call <SID>ToggleEolWhitespaceMatch()<cr>

" use <leader>W to remove EOL whitespace
nnoremap <silent><leader>W :call <SID>EolWhitespaceOperator('normal')<cr>
vnoremap <silent><leader>W :<c-u>call <SID>EolWhitespaceOperator(visualmode())<cr>

function! s:EolWhitespaceOperator(type)
    let saved_unnamed_register = @"
    let save_cursor = getpos('.')
    if a:type ==? 'v'
        silent execute "normal! `<V`>:s/\\v\\s+$//e\<cr>"
    elseif a:type ==# 'normal'
        " remove all whitespace in file if executed from normal mode
        silent execute "normal! :%s/\\v\\s+$//e\<cr>"
    endif
    call setpos('.', save_cursor)
    let @" = saved_unnamed_register
endfunction
