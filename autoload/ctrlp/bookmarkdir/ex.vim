let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('g:ctrlp_bookmarkdir_ex_paths')
  let g:ctrlp_bookmarkdir_ex_paths = []
endif
if !exists('g:ctrlp_bookmarkdir_ex_runtime')
  let g:ctrlp_bookmarkdir_ex_runtime = 1
endif
if !exists('g:ctrlp_bookmarkdir_ex_plug')
  let g:ctrlp_bookmarkdir_ex_plug = 1
endif
if !exists('g:ctrlp_bookmarkdir_ex_ghq')
  let g:ctrlp_bookmarkdir_ex_ghq = 1
endif
if !exists('g:ctrlp_bookmarkdir_ex_force')
  let g:ctrlp_bookmarkdir_ex_force = 0
endif
if !exists('g:ctrlp_bookmarkdir_ex_verbose')
  let g:ctrlp_bookmarkdir_ex_verbose = 1
endif
if !exists('g:ctrlp_bookmarkdir_ex_highlight')
  let g:ctrlp_bookmarkdir_ex_highlight = 'Identifier'
endif
if !exists('g:ctrlp_bookmarkdir_ex_message')
  let g:ctrlp_bookmarkdir_ex_message = 'CtrlP: your bookmarks reloaded'
endif

fu! ctrlp#bookmarkdir#ex#init(bang, verbose)
  " If g:ctrlp_bookmarkdir_ex_force == 1, deleting cache file is not needed
  if a:bang && !g:ctrlp_bookmarkdir_ex_force
    call delete(s:ctrlp_bookmark_file())
  endif

  let bookmark_dirs = []

  if exists('g:ctrlp_bookmarkdir_ex_paths')
    for path in g:ctrlp_bookmarkdir_ex_paths
      let dirs = map(split(expand(path), '\n'), 's:validate_path(v:val)')
      call extend(bookmark_dirs, dirs)
    endfor
  endif

  if isdirectory($VIMRUNTIME) && g:ctrlp_bookmarkdir_ex_runtime
    call add(bookmark_dirs, s:validate_path($VIMRUNTIME))
  endif

  if exists('g:plugs') && g:ctrlp_bookmarkdir_ex_plug
    call extend(bookmark_dirs, map(values(g:plugs), 'v:val.dir'))
  endif

  if executable('ghq') && g:ctrlp_bookmarkdir_ex_ghq
    let dirs = map(split(system('ghq list -p'), '\n'), 's:validate_path(v:val)')
    call extend(bookmark_dirs, dirs)
  endif

  call s:ctrlp_bookmark_add(g:ctrlp_bookmarkdir_ex_force, bookmark_dirs)
  if g:ctrlp_bookmarkdir_ex_verbose && a:verbose
    exe 'echohl '.g:ctrlp_bookmarkdir_ex_highlight
    echo g:ctrlp_bookmarkdir_ex_message
    echohl Normal
  endif
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
  let dir = s:ctrlp_cache_dir().'/bkd/'
  if !isdirectory(dir)
    call mkdir(dir)
  endif
  return s:validate_path(dir.'cache.txt')
endfu

fu! s:ctrlp_cache_dir()
  let dir = get(g:, 'ctrlp_cache_dir', '~/.cache/ctrlp')
  let dir = s:validate_path(dir)
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  return dir
endfu

fu! s:validate_path(path)
  return substitute(resolve(fnamemodify(a:path, ':p')), '\v[\\/]*$', '', '')
endfu

let &cpo = s:save_cpo
unlet s:save_cpo
