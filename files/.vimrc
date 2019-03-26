let mapleader = " "
" General
set number relativenumber
set linebreak
set nolist
set showbreak=+++
" set textwidth=100
set showmatch
set errorbells
set visualbell
 
set hlsearch
set smartcase
set ignorecase
set incsearch
 
set autoindent
set expandtab
set shiftwidth=2
set smartindent	
set smarttab
set softtabstop=2
 
" Advanced
set ruler
 
set autochdir
 
set undolevels=1000
set backspace=indent,eol,start

map <C-l> :MBEbn <CR>
map <C-h> :MBEbp <CR>
map <C-Right> :MBEbn <CR>
map <C-Left> :MBEbp <CR>
map <C-q> :MBEbd <CR>

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
 
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'https://github.com/fholgado/minibufexpl.vim'
Plug 'ternjs/tern_for_vim',{'do':'npm install'}
Plug 'sheerun/vim-polyglot'
Plug 'Valloric/YouCompleteMe',{'do':'./install.py --ts-completer'}

" Initialize plugin system
call plug#end()
