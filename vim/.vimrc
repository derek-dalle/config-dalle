" Derek Dalle
" 2013-07-19
"
" Attempt at a useful .vimrc
" Which is desperately needed, by the way.

" This is the reason I'm here, really.
set mouse=a

" I'm worried about this setting.
set nocompatible

" Obviously syntax highlightings was already on.
syntax on

" Automatic indenting is a nice addition.
set autoindent

" Let the backspace function in a sane way.
set backspace=indent,eol,start

" Eliminate stupid vi settings that keep moving the curser to line start.
set nostartofline

" Display cursor position!
set ruler
" On a related note, did not know vim can show line numbers
" set number

" Always, always use 4 spaces for a tab
set tabstop=4
set shiftwidth=4
" Put spaces only.
set expandtab

" Apparently better command-line completion?
set wildmenu

" Show partial commands
set showcmd

" Highlight searches (use <C-L> to temprarily disable)
set hlsearch

" Remember position of cursor in file.
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
