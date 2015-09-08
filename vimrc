set nocompatible               " Disable VI compatibility
filetype off

if isdirectory(glob("$HOME/.vim/vundle")) && &loadplugins
    set rtp+=~/.vim/vundle/
    call vundle#begin()

    " Package install:
    " VIM: :PluginInstall
    " CLI: vim +PluginInstall +qall

    " Solarized colourscheme
    Plugin 'altercation/vim-colors-solarized'

    " Dynamic tags support
    " See :help ctags
    " Tag navigation creates a stack which can be traversed with C^] (to find
    " the source of a token) and C^T (to jump back up one level).
    " Requires: sudo apt-get install exuberant-ctags
    Plugin 'xolox/vim-misc'
    Plugin 'xolox/vim-easytags'
    Plugin 'majutsushi/tagbar'
    autocmd FileType * set tags=~/.vim/.vimtags
    set cpoptions+=d
    let g:easytags_file = '~/.vim/.vimtags'
    let g:easytags_events = ['BufReadPost', 'BufWritePost']
    let g:easytags_dynamic_files = 2
    let g:easytags_async = 1
    let g:easytags_auto_highlight = 0
    let g:easytags_resolve_links = 1
    let g:easytags_suppress_report = 1
    nmap <silent> <leader>b :TagbarToggle<CR>

    " Vim Vundle Package Manager
    Plugin 'gmarik/vundle'

    " JIT Code Compilation
    Plugin 'scrooloose/syntastic'
    nnoremap <leader>e :Errors<CR>
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_enable_signs = 1
    let g:syntastic_auto_jump = 0
    let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '!'
    let g:syntastic_enable_highlighting = 1
    let g:syntastic_cpp_cpplint_exec = 'cpplint'
    let g:syntastic_cpp_checkers = ['cppcheck', 'cpplint']
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_python_checkers = ['flake8', 'pylint']
    let g:syntastic_ruby_checkers = ['ruby-lint', 'rubocop', 'mri']
    let g:syntastic_python_pylint_post_args = '--rcfile="`upfind .pylintrc | head`"'

    " Code Semantic Completion
    if v:version > 703 || v:version == 703 && has("patch584")
        if isdirectory(glob("$HOME/.vim/bundle/YouCompleteMe"))
            if filereadable(glob("$HOME/.vim/bundle/YouCompleteMe/ycm_core.so"))
                Plugin 'Valloric/YouCompleteMe'
                nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
                nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
                let g:ycm_autoclose_preview_window_after_completion = 1
                let g:ycm_show_diagnostics_ui = 1
                let g:ycm_min_num_of_chars_for_completion = 2
                let g:ycm_confirm_extra_conf = 0
                let g:ycm_seed_identifiers_with_syntax = 1
                let g:ycm_key_invoke_completion = '<leader>i'
            endif
        endif
    endif

    " Intensely orgasmic commenting (their words, not mine)
    " See: :Help NERD_Commenter.txt
    Plugin 'scrooloose/nerdcommenter'
    let g:NERDSpaceDelims = 1

    " Vim-based Filesystem Explorer
    " See: :help NERD_Tree.txt
    Plugin 'scrooloose/nerdtree'
    nnoremap <leader>n :NERDTreeToggle<CR>

    " Powerline Status Bar
    Plugin 'Lokaltog/powerline'

    " C++11 Enhanced Highlighting
    Plugin 'octol/vim-cpp-enhanced-highlight'

    " Fugitive - Git wrapper
    " :Gitedit :Gitdiff :Gitblame etc.
    Plugin 'tpope/vim-fugitive'
    set statusline+=%{fugitive#statusline()}

    " EasyMotion - Easy text searching
    " <leader><leader><motion> (e.g. \\w for start of word search)
    Plugin 'Lokaltog/vim-easymotion'
    map <leader> <Plug>(easymotion-prefix)
    nmap s <Plug>(easymotion-s2)

    " Full path fuzzy file, buffer, mru, tag
    " See: :help ctrlp-commands
    " See: :help ctrlp.txt
    Plugin 'kien/ctrlp.vim'
    nmap <silent> <leader>. :CtrlPTag<cr>

    " Gist support
    Plugin 'mattn/gist-vim'
    let g:gist_post_private = 1

    " Enable better vim EOL whitespace support
    Plugin 'ntpeters/vim-better-whitespace'
    call vundle#end()

    " Git gutter (show git diffs in gutter)
    Plugin 'airblade/vim-gitgutter'
    let g:gitgutter_max_signs = 5000
endif

if $POWERLINE_BINDINGS != ""
    set rtp+=$POWERLINE_BINDINGS/vim/
    let g:Powerline_symbols = 'fancy'
endif

filetype plugin indent on " required!
syntax enable             " Enable syntax highlighting

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

" Standard options
set autowrite             " Automatically save before commands like :next and :make
set autoindent            " Match indentation of previous line
set backspace=indent,eol,start " Backspace through everything in insert mode
set background=dark       " Dark background
set clipboard=unnamedplus " Attempt to use clipboardplus for cp
set expandtab             " Use spaces, not tabs
set exrc                  " enable per-directory .vimrc files
set foldmethod=syntax     " Fold based on indentation
set foldnestmax=3         " Deepest fold is 3 levels
set hidden                " Hide buffers when they are abandoned
set history=1000          " Store 1000 commands in history buffer
set hlsearch              " Highlight search terms
set ignorecase            " Do case insensitive matching
set incsearch             " Incremental search
set ls=2                  " Always show status line
set mouse=a               " Enable mouse usage (all modes)
set nocursorline          " Don't highlight the current line
set noerrorbells          " Turn error bells off
set nofoldenable          " Don't fold by default
set nolist                " Don't visualise characters
set novisualbell          " Turn visual bells off
set nowrap                " Don't wrap lines automatically
set ruler                 " Always display row/col (cursor) position.
set scrolloff=4           " Keep cursor <n> characters away from top/bottom
set secure                " disable unsafe commands in local .vimrc files
set shiftwidth=4          " Tabs = 4 spaces
set showcmd               " Show (partial) command in status line.
set showmatch             " Show matching brackets
set showmatch             " Show matching parentheses
set sidescrolloff=7       " Keep cursor <n> characters away from left/right
set smartcase             " Do smart case matching
set synmaxcol=120         " Only highlight syntax upto 120 characters
set tabstop=4             " Tabs = 4 spaces
set t_Co=256              " Set terminal to 256 colours
set title                 " Set the terminals title
set ttyfast               " Smoother changes
set wildmenu              " Enhanced command line completion

" Customisations
set completeopt+=preview
set directory=/tmp/
set nobackup
set number                " Enable line numbers

if has('unnamedplus')
    set clipboard=unnamedplus,unnamed
endif

"color Tomorrow-Night-Bright    " Works well on my machine ;)
"hi Normal ctermbg=NONE
let g:solarized_termtrans=1
let g:solarized_termcolors=16
silent! color solarized

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python
autocmd BufReadPre *.yaml, *.yml set filetype=yaml
autocmd BufReadPre *.json set filetype=json
autocmd BufReadPre *.csl set filetype=csl
autocmd BufReadPre *.g4 set filetype=g4

au FileType python set autoindent
au FileType python set textwidth=79          " PEP-8 Friendly

au FileType ruby set autoindent
au FileType ruby set textwidth=79            " Ruby Friendly
au FileType ruby set shiftwidth=2 tabstop=2  " Ruby standard

au FileType yaml set autoindent
au FileType yaml set shiftwidth=2 tabstop=2  " YAML recommendation

au FileType json set autoindent
au FileType json set shiftwidth=2 tabstop=2  " JSON recommendation

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Strip whitespaces endings on save
function! s:StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
autocmd FileType c,cpp,java,php,python,ruby autocmd BufWritePre <buffer> :call s:StripTrailingWhitespaces()
autocmd FileType csl,g4,json,yaml autocmd BufWritePre <buffer> :call s:StripTrailingWhitespaces()

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>z :ZoomToggle<CR>

" Source user local .vimrc
if filereadable(glob("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif
