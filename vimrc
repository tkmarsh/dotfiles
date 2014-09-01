set nocompatible               " Disable VI compatibility
filetype off

set rtp+=~/.vim/vundle/
call vundle#rc()

" Package install: 
" VIM: :PluginInstall
" CLI: vim +PluginInstall +qall

" Vim Vundle Package Manager
Plugin 'gmarik/vundle'

" Code Semantic Completion
Plugin 'Valloric/YouCompleteMe'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_register_as_syntastic_checker = 1
let g:syntastic_python_checkers = ['flake8', 'pyflakes']

" JIT Code Compilation
Plugin 'scrooloose/syntastic'
nnoremap <leader>e :Errors<CR>
let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 0
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_enable_highlighting = 1

" Intensely orgasmic commenting (their words, not mine)
Plugin 'scrooloose/nerdcommenter'

" Vim-based Filesystem Explorer
" See: :help NERD_Tree.txt
Plugin 'scrooloose/nerdtree'
nnoremap <leader>n :NERDTreeToggle<CR>

" Powerline Status Bar
Plugin 'Lokaltog/powerline'
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'

" C++11 Enhanced Highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'

" Fugitive - Git wrapper
" :Gitedit :Gitdiff :Gitblame etc.
Plugin 'tpope/vim-fugitive'
set statusline+=%{fugitive#statusline()}

" EasyMotion - Easy text searching
" <leader><leader><motion> (e.g. \\w for start of word search)
Plugin 'Lokaltog/vim-easymotion'
map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-s2)

" Full path fuzzy file, buffer, mru, tag
" See: :help ctrlp-commands
" See: :help ctrlp.txt
Plugin 'kien/ctrlp.vim'

filetype plugin indent on     " required!

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

au FileType python set autoindent
au FileType python set smartindent
au FileType python set textwidth=79 " PEP-8 Friendly

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
set noswapfile

color Tomorrow-Night-Bright    " Works well on my machine ;)
hi Normal ctermbg=NONE

" Map F1 to man page on current word (or use K)
source $VIMRUNTIME/ftplugin/man.vim
nnoremap <F1>  :Man <cword><CR>

" vimdiff shortcuts
nnoremap <F2>  do
nnoremap <F3>  dp
nnoremap <F9>  :tprev<CR>
nnoremap <F10> :tnext<CR>
nnoremap <F11> [czz
nnoremap <F12> ]czz

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" helper function to toggle hex mode
function ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction
