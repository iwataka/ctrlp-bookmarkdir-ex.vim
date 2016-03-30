if &compatible || (exists('g:loaded_ctrlp_bookmark') && g:loaded_ctrlp_bookmark)
  finish
endif
let g:loaded_ctrlp_bookmark = 1

if !exists('g:ctrlp_bookmark_paths')
  let g:ctrlp_bookmark_paths = []
endif
if !exists('g:ctrlp_bookmark_runtime')
  let g:ctrlp_bookmark_runtime = 1
endif
if !exists('g:ctrlp_bookmark_plug')
  let g:ctrlp_bookmark_plug = 1
endif
if !exists('g:ctrlp_bookmark_ghq')
  let g:ctrlp_bookmark_ghq = 1
endif
if !exists('g:ctrlp_bookmark_force')
  let g:ctrlp_bookmark_force = 0
endif
if !exists('g:ctrlp_bookmark_startup')
  let g:ctrlp_bookmark_startup = 1
endif

com! -bang CtrlPBookmarkReload call s:ctrlp_bookmark_init(<bang>0)

fu! s:ctrlp_bookmark_init(bang)
  if a:bang && !g:ctrlp_bookmark_force
    call delete(s:ctrlp_bookmark_file())
  endif

  let bookmark_dirs = []

  if exists('g:ctrlp_bookmark_paths')
    for path in g:ctrlp_bookmark_paths
      let dirs = map(split(expand(path)), 's:validate_path(v:val)')
      call extend(bookmark_dirs, dirs)
    endfor
  endif

  if isdirectory($VIMRUNTIME) && g:ctrlp_bookmark_runtime
    call add(bookmark_dirs, s:validate_path($VIMRUNTIME))
  endif

  if exists('g:plug_home') && g:ctrlp_bookmark_plug
    let dirs = map(split(globpath(g:plug_home, '*')), 's:validate_path(v:val)')
    call extend(bookmark_dirs, dirs)
  endif

  if executable('ghq') && g:ctrlp_bookmark_ghq
    let dirs = map(split(system('ghq list -p')), 's:validate_path(v:val)')
    call extend(bookmark_dirs, dirs)
  endif

  call s:ctrlp_bookmark_add(g:ctrlp_bookmark_force, bookmark_dirs)
endf

fu! s:ctrlp_bookmark_add(force, dirs)
  if a:force
    let lines = []
    for dir in a:dirs
      if isdirectory(dir)
        call add(lines, dir."\t".dir)
      endif
    endfor
    call writefile(lines, s:ctrlp_bookmark_file())
  else
    for dir in a:dirs
      if isdirectory(dir)
        exe 'CtrlPBookmarkDirAdd! '.dir
      endif
    endfor
  endif
endfu

fu! s:ctrlp_bookmark_file()
  return s:ctrlp_cache_dir().'bkd/cache.txt'
endfu

fu! s:ctrlp_cache_dir()
  let dir = get(g:, 'ctrlp_cache_dir', '~/.cache/ctrlp')
  return s:validate_path(dir)
endfu

fu! s:validate_path(path)
  let path = resolve(fnamemodify(a:path, ':p'))
  if isdirectory(path)
    return substitute(path, '\v/*$', '/', '')
  elseif filereadable(path)
    return substitute(path, '\v/*$', '', '')
  else
    return ''
  endif
endfu

if has('autocmd')
  autocmd vimrcEx VimEnter *
        \ if exists(':CtrlPBookmarkDirAdd') && g:ctrlp_bookmark_startup |
        \ call s:ctrlp_bookmark_init(0) |
        \ endif
endif
