set number
set autoindent
syntax on
"set cursorline "to higline current row
set showmatch "to show matching of pharentesis () [] {}
set ruler
set mouse=a
"
set incsearch
set laststatus=2
set statusline+=\ [%F]\ %m%=%{&fileencoding?&fileencoding:&encoding}\ %p%%\ %l/%L:%c\

" uscire da vim premendo ctrl+w
map <C-w> <esc>:q<CR>