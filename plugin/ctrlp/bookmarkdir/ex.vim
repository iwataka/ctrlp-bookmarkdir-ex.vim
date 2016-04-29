if &compatible || (exists('g:loaded_ctrlp_bookmark') && g:loaded_ctrlp_bookmark)
  finish
endif
let g:loaded_ctrlp_bookmark = 1

com! -bang CtrlPBookmarkDirReload call ctrlp#bookmarkdir#ex#init(<bang>0)

if has('autocmd')
  augroup ctrlp_bookmarkdir_ex
    autocmd!
    autocmd VimEnter * call s:on_enter()
  augroup END
endif

fu! s:on_enter()
  if exists(':CtrlPBookmarkDirAdd') && get(g:, 'ctrlp_bookmark_startup', 1)
    call ctrlp#bookmarkdir#ex#init(0)
  endif
endfu
