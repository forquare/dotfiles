" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
" filetype plugin on
" filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Enable syntax highlighting
syntax enable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set paste
set number

" Always show current position
set ruler

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Mostly taken from
" http://amix.dk/vim/vimrc.html

" Stop hideous mouse integration
autocmd BufEnter * set mouse=

" Backspace should delete more
set backspace=start,eol,indent

" Split more naturally
set splitbelow
set splitright

" Easier moving between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Don't send termcap initialization and deinitialization strings to the terminal
set t_ti= t_te=

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'mrk21/yaml-vim'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'modille/groovy.vim'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'fatih/vim-go'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
