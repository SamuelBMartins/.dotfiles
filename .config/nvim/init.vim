set number
set relativenumber
set ignorecase
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set cc=80
set mouse=a
set cursorline
set encoding=UTF-8
set clipboard=unnamedplus
highlight ColorColumn ctermbg=7

augroup neovim_terminal
  autocmd!
  " Enter Terminal-mode (insert) automatically
  autocmd TermOpen * startinsert
  " Disables number lines on terminal buffers
  autocmd TermOpen * :set nonumber norelativenumber
  " allows you to use Ctrl-c on terminal window
  autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END

autocmd FileType text set colorcolumn=72
autocmd FileType markdown set colorcolumn=72 textwidth=72
autocmd FileType gitcommit set colorcolumn=50,72

" Remove trailing spaces when saving
autocmd BufWritePre * :%s/\s\+$//e

" ctrl p shortcut for ctrl p extension
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

call plug#begin()
 Plug 'ryanoasis/vim-devicons'
 Plug 'scrooloose/nerdtree'
 Plug 'mhinz/vim-startify'
 Plug 'itchyny/lightline.vim'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

source ~/.config/nvim/coc.vim

