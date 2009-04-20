set hidden
nnoremap ' `
nnoremap ` '
let mapleader = ","
set history=1000
runtime macros/matchit.vim
set wildmenu
set wildmode=list:longest
set ignorecase
set smartcase
set title
set scrolloff=3
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
set ruler
set backspace=indent,eol,start
syntax on
filetype on
filetype plugin on
filetype indent on
set hlsearch
set incsearch
nmap <silent> <leader>n :silent :nohlsearch<CR>
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>
set shortmess=atI
set visualbell

set showmatch
set nowrap

