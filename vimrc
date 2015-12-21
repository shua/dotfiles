filetype off
"execute pathogen#infect()

set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set laststatus=2
set list
set listchars=tab:\|\ 

set cinoptions=:0 "case on same col as switch

set number
set cc=80

filetype plugin indent on
syntax on
au BufRead,BufNewFile *.s set filetype=nasm

