if &compatible || (exists('g:loaded_ctrlp_bookmark') && g:loaded_ctrlp_bookmark)
  finish
endif
let g:loaded_ctrlp_bookmark = 1

com! -bang CtrlPBookmarkDirReload call ctrlp#bookmarkdir#ex#init(<bang>0, 1)

if has('autocmd')
  augroup ctrlp_bookmarkdir_ex
    autocmd!
    autocmd VimEnter * call s:on_enter()
  augroup END
endif

fu! s:on_enter()
  if exists(':CtrlPBookmarkDirAdd') && get(g:, 'ctrlp_bookmarkdir_ex_startup', 1)
    silent call ctrlp#bookmarkdir#ex#init(0, 0)
  endif
endfu
