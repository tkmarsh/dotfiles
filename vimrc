set nocompatible               " Disable VI compatibility
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Package install: 
" VIM: run :BundleInstall
" CLI: vim +BundleInstall +qall

" vundle
Bundle 'gmarik/vundle'

Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/powerline'
"Bundle 'ashwin/vim-powerline'
Bundle 'octol/vim-cpp-enhanced-highlight'

" repos
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'

" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" non git-hub repos
"Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

syntax enable                  " Enable syntax highlighting
set showcmd                    " Show incomplete commands
set showmode                   " Show mode we're in
set showmatch                  " Show parantheses matching

set nowrap                     " Don't wrap lines automatically
set tabstop=4 shiftwidth=4     " Tabs = 4 spaces
set expandtab                  " Use spaces, not tabs
set backspace=indent,eol,start " Backspace through everything in insert mode
"set autoindent                 " Match indentation of previous line
set noautoindent

set incsearch                  " Find as you type search
set hlsearch                   " Highlight search terms
set ignorecase smartcase       " Make searching case insensitive, unless specified

set foldmethod=syntax          " Fold based on indentation
set foldnestmax=3              " Deepest fold is 3 levels
set nofoldenable               " Don't fold by default

set ttyfast                    " Smoother changes
set wildmenu                   " Enhanced command line completion
set hidden                     " Handle multiple buffers better.
set title                      " Set the terminals title
"set cursorline                 " Highlight current line
set number                     " Enable line numbers
set ruler                      " Always display row/col (cursor) position.
set nolist                     " Don't visualise characters
set novisualbell noerrorbells  " Turn bells off
set scrolloff=4                " Keep cursor <n> characters away from top/bottom
set sidescrolloff=7            " Keep cursor <n> characters away from left/right
set history=1000               " Store 1000 commands in history buffer
set mouse=a                    " XTerm-style mouse (make selections easier)

set ls=2                       " Always show status line
"set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

set t_Co=256                   " Set terminal to 256 colours
set background=dark            " Dark backgrounds

set completeopt+=preview
set backupdir=~/.vim/backup/
set directory=/tmp/
set clipboard=unnamed

set nobackup

color Tomorrow-Night-Bright    " Works well on my machine ;)
hi Normal ctermbg=NONE

source $VIMRUNTIME/ftplugin/man.vim

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_register_as_syntastic_checker = 1

let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 0
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_enable_highlighting = 0

let g:Powerline_symbols = 'fancy'

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

nnoremap <leader>e :Errors<CR>

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>tn :tabNext<CR>
nnoremap <leader>tp :tabPrev<CR>

" Map F1 to man page on current word (or use K)
nnoremap <F1>  :Man <cword><CR>
nnoremap <F2>  do
nnoremap <F3>  dp
nnoremap <F9>  :tprev<CR>
nnoremap <F10> :tnext<CR>
nnoremap <F11> [czz
nnoremap <F12> ]czz

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
