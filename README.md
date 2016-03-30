# CtrlP Bookmark

Manage CtrlP bookmarks easily!

## Usage

What you should do is just setting `g:ctrlp_bookmark_paths` option like this:

```vim
let g:ctrlp_bookmark_paths = [
      \ 'path/to/bookmark',
      " Wildcard is accepted
      \ 'path/to/root/*'
      " Environment variable is accepted
      \ '$BOOKMARK'
      \ ]
```

Restart Vim and you'll see the bookmarks registered in CtrlP.

This support the following projects:

+ [vim-plug](https://github.com/junegunn/vim-plug)
+ [ghq](https://github.com/motemen/ghq)
