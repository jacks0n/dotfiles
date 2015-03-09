" checkout http://amix.dk/vim/vimrc.html

set nocompatible                  " Enable Vim-specific features, disable Vi compatibility
filetype off
call plug#begin('~/.vim/plugged')

Plug 'Shougo/neocomplete.vim'     " Keyword auto-completion for insert mode
" Plug 'bling/vim-airline'          " Fancy status bar
Plug 'scrooloose/nerdtree'          " File and directory sidebar explorer
Plug 'scrooloose/syntastic'       " Live syntax checking. Parse error: syntax no more!
" Plug 'dsawardekar/wordpress.vim', { 'for': 'php' }   " WordPress API completion
" Plug 'Raimondi/delimitMate'       " Insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'flazz/vim-colorschemes'     " All single-file vim.org colour schemes
" Plug 'rking/ag.vim'               " Silver Searcher support, super fast grep alternative
Plug 'airblade/vim-gitgutter'     " Shows a Git diff in the 'gutter' (sign column)
Plug 'vim-scripts/closetag.vim'   " Auto closes HTML/XML tags
Plug 'sjl/gundo.vim'              " Shows undo history
Plug 'Yggdroot/indentLine'        " Adds vertical and/or horizontal alignment lines
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass', 'less'] }         " Highlights CSS colour rules with the rule value
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss', 'sass', 'less'] }   " Enable CSS3 property awareness
Plug 'JulesWang/css.vim', { 'for': ['css', 'scss', 'sass', 'less'] }        " CSS syntax highlighting for @page, @media, @import, @keyframe, etc
Plug 'godlygeek/csapprox'         " Make GUI colours work in the terminal
" Plug 'majutsushi/tagbar'          " Tags display window on right
Plug 'mhinz/vim-startify'         " Fancy start screen
" Plug 'vim-php/tagbar-phpctags.vim'  " Tagbar plugin, enhanced ctags for PHP
" Plugin 'ntpeters/vim-better-whitespace'
" Use <tab> completion in insert mode
" Plugin 'ervandew/supertab'
" Plug 'tpope/vim-sensible'          " 'Sensible defaults'
" Plug 'xolox/vim-misc'              " Required for vim-easytags
" Plug 'xolox/vim-easytags'          " Automated tag generation
Plug 'Shougo/vimproc.vim', {
\ 'build': {
\     'windows': 'tools\\update-dll-mingw',
\     'cygwin': 'make -f make_cygwin.mak',
\     'mac': 'make -f make_mac.mak',
\     'linux': 'make',
\     'unix': 'gmake'
\    }
\ }
" Plug 'sudo.vim'
" Plug 'Shougo/unite.vim'
" Plug 'shawncplus/phpcomplete.vim',  { 'for': 'php' }
" Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' }
" Plug 'junegunn/vim-easy-align'
" Evaluating
" Plug 'wincent/command-t'
" Plug 'kien/ctrlp.vim'

call plug#end()            " required


" ================ Plugin Settings ================

" tagbar-phpctags
" let g:tagbar_phpctags_bin = '/usr/local/bin/phpctags'
" let g:tagbar_phpctags_memory_limit = '512M'

" NeoComplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" DelimitMate
let delimitMate_autoclose = 1
let delimitMate_expand_space = 1
let delimitMate_expand_inside_quotes = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_insert_eol_marker = 1

" phpcomplete
let g:phpcomplete_relax_static_constraint = 1
let g:phpcomplete_min_num_of_chars_for_namespace_completion = 3
let g:phpcomplete_parse_docblock_comments = 1
let g:phpcomplete_index_composer_command = '/usr/local/bin/composer'

" Airline
" let"  g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline_theme = 'badwolf'

" NERDTree Tabs
let g:nerdtree_tabs_open_on_console_startup = 1

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_enable_signs = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_jump = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_php_checkers = ['php']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1

" Easytags
let g:easytags_cmd = '/usr/local/bin/ctags'  " Homebrew ctags
" let g:loaded_easytags = 1                  " Only load once
let g:easytags_async = 1                     " Asynchronous tag file updates
let g:easytags_resolve_links = 1             " Use canonical pathnames in tags file
let g:easytags_events = ['BufWritePost']
let g:easytags_file = '~/.vim/tags'
let g:easytags_languages = {
\   'php': {
\     'cmd': '/usr/local/bin/phpctags',
\       'args': [],
\       'fileoutput_opt': '-f',
\       'stdout_opt': '-f-',
\       'recurse_flag': '-R'
\   }
\}

" vim-scripts/closetag.vim
let b:closetag_html_style = 1

" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'			" Search anything (files, buffers, and MRU files)
let g:ctrlp_working_path_mode = 'ra'	" Search in nearest DVCS ancestor and the directory of the current file
let g:ctrlp_match_window_bottom = 0		" Show match window at the top of the screen
" let g:ctrlp_by_filename = 1
" let g:ctrlp_max_height = 10			" Maxiumum height of match window
let g:ctrlp_switch_buffer = 'et'		" Jump to a file if it's open already
let g:ctrlp_use_caching = 1				" Enable caching
let g:ctrlp_clear_cache_on_exit = 0		" Speed up by not removing clearing cache evertime
let g:ctrlp_mruf_max = 250 				" Number of recently opened files
let g:ctrlp_map = '<c-p>'



" ================ Plugin Mapping ================

" Start interactive EasyAlign  in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)



" ================ Plugin Autocommands ================

" Close NERDTree when closing the last window/exiting Vim
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif

" Open Tagbar by default for some filetypes
" autocmd FileType php,javascript,python,vim nested :TagbarOpen



" ================ General Config ====================

filetype plugin indent on  " Enable file type detection

let mapleader = ','
let g:mapleader = ','

syntax on  " Enable syntax highlighting
set background=dark

set autochdir  " Automatically change to the directory of the file open
set autoread   " Re-load files on external modifications and none locally
set autowrite  " Automatically save before :next, :make etc

" Cursor key wrapping, with arrows & h and l.
" < > keys are for normal & visual mode, the [ ] keys are ininsert mode
set whichwrap=<,>,h,l,[,]

" Disable audio & visual bells
set noerrorbells
set novisualbell
set t_vb=
set visualbell

set iskeyword+=/ " Include slashes as part of a word
set so=7         " Set 7 lines to the cursor - when moving vertically using j/k

" Backup files
if isdirectory($HOME . '/.vim/backup') == 0
    :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backup
set backupdir=~/.vim/backup//,/tmp//
set backupskip=/tmp/*,/private/tmp/*,~/tmp/*

" Swap files
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//,/tmp//,.
set writebackup
set encoding=utf-8

" Better command-line completion, with menu
set wildchar=<Tab>
set wildmode=longest,list,full
set wildmenu

set showcmd
set tags=./.tags;,~/.vimtags

set clipboard+=unnamed  " OS integration

" Persistent undo
if has('persistent_undo')
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
    endif
    set undofile                 " Save undo's after file closes
    set undodir=~/.vim/undo      " Where to save undo histories
    set undolevels=10000         " How many undos to remember
    set undoreload=100000        " Number of lines to save for undo
endif

set autoindent                  " Auto-indent inserted lines
set copyindent                  " Use current line indenting when starting a new line
set hidden                      " Hide unsaved buffers instead of close on file open
set nowrap                      " Don't wrap lines
set splitbelow                  " Puts new split windows to the bottom of the current
set splitright                  " Puts new vsplit windows to the right of the current 
set linebreak                   " Wrap at convenient characters, set in 'breakat'
set ignorecase                  " Case insensitive searches
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight search matches
set showmatch                   " Highlight matching [{()}]
set number                      " Show line numbers
set nrformats-=octal            " Numbers beginning with '0' not considered
set shiftround                  " Round indents to nearest multiple of 'shiftwidth'
set ttimeout                    " Enable timout on key mappings and insert-mode <CTRL-*> commands
set ttimeoutlen=50              " Limit the timeout to 50 milliseconds
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 EOLs 
set completeopt=menu,menuone,longest,preview
                                " More detailed and accurate insert mode completion
set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " For CtrlP

" Whitespace stuff: 4 character soft tabs
set cindent                     " Indent from previous line, with C syntax
set smarttab                    " Emulate tab behaviour with spaces
set expandtab                   " Tabs are spaces
set tabstop=4                   " Number of visual spaces per tab
set shiftwidth=4                " 4 spaces per tab
set softtabstop=4               " Number of spaces in tab when editing

set viminfo^=%                  " Remember info about open buffers on close
set lazyredraw                  " Don't redraw while executing macros (good performance config)
set ttyfast                     " Send more characters for redraws
set mouse=a                     " Enable mouse use in all modes
set ttymouse=xterm2             " Name of the mouse-code supporting terminal
set backspace=indent,eol,start  " Allow backspacing over autoindent, line breaks and start of insert action
set gcr=a:blinkon0              " Disable cursor blink

" Set the screen title to the current filename
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Fixes airline showing only when a NERDTree is open
" https://github.com/bling/vim-airline/issues/501
set laststatus=2  " 2=always, status line for the last window

set guifont=Ubuntu\ Mono:h16
set antialias

" set lines=120
" set columns=150

if has('multi_byte')
  if &termencoding == ''
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
endif

set rtp+=~/.fzf  " Fuzzy finder for your shell


" ================ GUI ================

if has('gui_running')
  set guioptions-=m  " No menu
  set guioptions-=T  " No toolbar
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r  " No scrollbar
  set guioptions-=R
endif

" Let MacVim control the shift key, for selecting with shift
if has('gui_macvim')
  let macvim_hig_shift_movement = 1
endif



" ================ Visual ================

call matchadd('ColorColumn', '\%100v', 100)  " Highlight 100th column character 



" ================ Mappings ================

nnoremap ; :
noremap <C-Tab> :bn<cr>
noremap <C-S-Tab> :bp<cr>
nmap <leader>d :bnext<CR>:bdelete #<CR>
nnoremap <leader>a :Ag -i<space>  " Quick file search
map <C-n> :NERDTreeToggle<CR>  " <CTRL> + n  =>  Toggle NERDTreeToggle
nmap <leader>t :TagbarToggle<CR>
noremap  <Leader>g :GitGutterToggle<CR>

" Disable arrow keys, HJKL FTW!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Move line by line even when the line is wrapped
map j gj
map k gk

nnoremap <esc> :noh<return><esc>    " ESC in normal mode, clear search results
noremap <silent><Leader>/ :noh<CR>  " Clear highlight after search
nmap <leader>w :w!<cr>              " Quick save <,w>


" set t_Co=256  " Not required? Vim will auto set this from $TERM
let g:my_themes = ['monokain', 'jellybeans', 'grb256', 'ir_black', 'molokai', 'gruvbox', 'hybrid', 'badwolf']
let g:current_theme = my_themes[localtime() % len(my_themes)]
highlight clear
syntax reset
execute ':colorscheme ' . g:current_theme



" ================ Auto Commands ================

autocmd FileType css setlocal iskeyword+=-

autocmd vimenter * NERDTree  " Open NERDTree on vim startup
autocmd VimEnter * wincmd p  " Focus on the editor window instead of NERDTree

" Reload Vim configuration when saving to ~/.vimrc
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END


" Enable omni completion.
autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


" Return to last edit position when opening files 
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif



" ================ Utility Functions ================

" Delete trailing white space
function! <SID>StripTrailingWhitespaces()
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
endfun

