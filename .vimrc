" vim: set ft=vim

set nocompatible                    " Enable Vim-specific features, disable Vi compatibility.
filetype off
call plug#begin('~/.vim/plugged')

" ==== Dependencies ====
Plug 'tpope/vim-dispatch'           " Required for ack.vim async support.
Plug 'Shougo/unite.vim'
Plug 'xolox/vim-misc'               " Required for vim-easytags.
Plug 'Shougo/vimproc.vim', {
\ 'build': {
\   'windows': 'tools\\update-dll-mingw',
\   'cygwin': 'make -f make_cygwin.mak',
\   'mac': 'make -f make_mac.mak',
\   'linux': 'make',
\   'unix': 'gmake'
\ }
\}
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'sudo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/closetag.vim'     " Auto closes HTML/XML tags.
Plug 'sjl/gundo.vim'                " Shows undo history.
Plug 'Raimondi/delimitMate'         " Insert mode auto-completion for quotes, parens, brackets, etc.
" Plug 'xolox/vim-session'
" Plug 'mhinz/vim-startify'           " Fancy start screen

" ==== Completion ====
Plug 'Shougo/neocomplete.vim'
Plug 'ervandew/supertab'
" Plug 'Valloric/YouCompleteMe'

" ==== Search ====
Plug 'ctrlpvim/ctrlp.vim'
Plug 'JazzCore/ctrlp-cmatcher'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mileszs/ack.vim'

" ==== Tags ====
" Plug 'majutsushi/tagbar'
" Plug 'vim-php/tagbar-phpctags.vim'  " Tagbar plugin, enhanced ctags for PHP.
" Plug 'xolox/vim-easytags'           " Automated tag generation

" ==== PHP ====
Plug 'spf13/PIV'                    " PHP goodies - better fold support, doc gen, better completion.
Plug 'paulyg/Vim-PHP-Stuff',        { 'for': 'php' }
Plug '2072/PHP-Indenting-for-VIm',  { 'for': 'php' }
Plug 'shawncplus/phpcomplete.vim',  { 'for': 'php' }
" Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' }
" Plug 'dsawardekar/wordpress.vim', { 'for': 'php' }   " WordPress API completion

" ==== Visual ====
Plug 'henrik/vim-indexed-search'    " Show 'At match #N out of M matches.' when searching.
Plug 'alvinhuynh/vim-syntastic-scss-lint' " Sytastic `scsslint` integration`
Plug 'vim-scripts/ScrollColors'
Plug 'scrooloose/syntastic'
Plug 'Wutzara/vim-materialtheme'
Plug 'flazz/vim-colorschemes'       " All single-file vim.org colour schemes
Plug 'Yggdroot/indentLine'          " Adds vertical and/or horizontal alignment lines
Plug 'ap/vim-css-color',       { 'for': ['css', 'scss', 'sass', 'less'] }  " Highlights CSS colour rules with the rule value
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss', 'sass', 'less'] }  " Enable CSS3 property awareness
Plug 'JulesWang/css.vim',      { 'for': ['css', 'scss', 'sass', 'less'] }  " CSS syntax highlighting for @page, @media, @import, @keyframe, etc

" ==== Text Editing ====
Plug 'tpope/vim-repeat'             " Enable repeating supported plugin maps with '.'
Plug 'tpope/vim-surround'           

" ==== Functional ====
Plug 'tpope/vim-repeat'         

call plug#end()                     " Required


" ================ Plugin Settings ================

" tagbar-phpctags
let g:python_host_prog = '/usr/local/bin/python'
let g:tagbar_phpctags_bin = '/usr/local/bin/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'

" ack.vim
if executable('ag')
  let g:ackprg = 'ack --vimgrep'
endif
" Show up to 50 lines
let g:ack_qhandler = 'botright copen 50'
let g:ack_lhandler = 'botright lopen 50'
let g:ackhighlight = 1
" let g:ackhighlight = 1
let g:ack_autoclose = 1
let g:ackpreview = 1
let g:ack_use_dispatch = 1
let g:ack_default_options = ' --smart-case --heading --column --follow'

" SuperTab
" <Enter> on complete menu inserts selection.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" DelimitMate
let delimitMate_autoclose = 1
let delimitMate_expand_space = 1
let delimitMate_expand_inside_quotes = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_insert_eol_marker = 1

" phpcomplete
let g:phpcomplete_relax_static_constraint = 1
let g:phpcomplete_parse_docblock_comments = 1
let g:phpcomplete_search_tags_for_variables = 1
let g:phpcomplete_index_composer_command = '/usr/local/bin/composer'

" vim-session
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'
let g:session_default_to_last = 'yes'
let g:session_autosave_periodic = 15

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#capslock#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#undotree#enabled = 1
let g:airline#extensions#unite#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'  " Show just the filename
let g:airline_theme = 'badwolf'

" NerdTree
let NERDTreeChDirMode = 2

let php_sql_query = 1
let php_html_in_strings = 1
let php_parent_error_close = 1
let php_parent_error_open = 1

" NERDTree Tabs
let g:nerdtree_tabs_open_on_console_startup = 1

" Syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_echo_current_error = 1
let g:syntastic_enable_signs = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_jump = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = '--standard=Drupal'
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_scss_scss_lint_args = '--config /Users/flightcentre/drupal-dev-env/docroot-unison/docroot/.scss-lint.yml'
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_javascript_jshint_args = '--config /Users/flightcentre/.jshintrc'
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1

" Easytags
let g:easytags_cmd = '/usr/local/bin/ctags'  " Homebrew ctags
let g:loaded_easytags = 1                    " Only load once
let g:easytags_async = 1                     " Asynchronous tag file updates
let g:easytags_resolve_links = 1             " Use canonical pathnames in tags file
let g:easytags_events = ['BufWritePost']
let g:easytags_file = '~/.tags'
let g:easytags_autorecurse = 1
let g:easytags_dynamic_files = 1
let g:easytags_languages = {
\ 'php': {
\   'cmd': '/usr/local/bin/phpctags',
\   'args': [],
\   'fileoutput_opt': '-f',
\   'stdout_opt': '-f-',
\   'recurse_flag': '-R'
\ }
\}

" vim-scripts/closetag.vim
let b:closetag_html_style = 1

" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'			         " Search anything (files, buffers, and MRU files)
let g:ctrlp_working_path_mode = 'ra'	       " Search in nearest DVCS ancestor and the directory of the current file
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:ctrlp_match_window_bottom = 1          " Show match window at the top of the screen
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 100
let g:ctrlp_switch_buffer = 'et'		         " Jump to a file if it's open already
let g:ctrlp_use_caching = 1				           " Enable caching
let g:ctrlp_clear_cache_on_exit = 0		       " Speed up by not removing clearing cache evertime
let g:ctrlp_mruf_max = 250 				           " Number of recently opened files
let g:ctrlp_map = '<C-p>'
" let g:ctrlp_by_filename = 1
" let g:ctrlp_working_path_mode = ''
" let g:ctrlp_max_height = 10			           " Maxiumum height of match window



" ================ Plugin Mapping ================

" Start interactive EasyAlign  in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)



" ================ Plugin Autocommands ================

if has('autocmd')
  " Close NERDTree when closing the last window/exiting Vim.
  autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif

  " Open Tagbar by default for some filetypes.
  " autocmd FileType php,javascript,python,vim nested :TagbarOpen
endif



" ================ General Config ====================

filetype plugin indent on  " Enable file type detection

let mapleader = ','
let g:mapleader = ','

if has('syntax') && !exists('g:syntax_on')
  syntax on  " Enable syntax highlighting
endif

set background=dark

" set autochdir  " Automatically change to the directory of the file open
set autoread   " Re-load files on external modifications and none locally
set autowrite  " Automatically save before :next, :make etc

" Cursor key wrapping, with arrows & h and l.
" < > keys are for normal & visual mode, the [ ] keys are ininsert mode
set whichwrap=<,>,h,l,[,]

" Disable audio & visual bells.
set noerrorbells
set novisualbell
set t_vb=
set visualbell

set iskeyword+=/  " Include slashes as part of a word
set so=7          " 7 lines to the cursor when moving vertically using j/k.

" Persistent undo.
if has('persistent_undo')
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
  endif
  set undofile                 " Save undo's after file closes
  set undodir=~/.vim/undo      " Where to save undo histories
  set undolevels=10000         " How many undos to remember
  set undoreload=100000        " Number of lines to save for undo
endif

" Backup files.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backup
set backupdir=~/.vim/backup//,/tmp//
set backupskip=/tmp/*,/private/tmp/*,~/tmp/*
set writebackup

" Swap files.
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//,/tmp//,~/tmp//

set encoding=UTF-8

" Better command-line completion, with menu
set wildchar=<Tab>
set wildmode=longest,list,full
set wildmenu

set showcmd
set tags=./.tags,.tags;
set clipboard+=unnamed          " OS integration.
set history=10000               " Number of commands remembered.
" set autoindent                  " Auto-indent inserted lines. Crashes MacVim
set copyindent                  " Use current line indenting when starting a new line.
set hidden                      " Hide unsaved buffers instead of close on file open.
set modeline                    " Enable modelines.
set modelines=5                 " Look for modelines in the first and last X lines.
set nowrap                      " Don't wrap lines.
set textwidth=0                 " Disable wrapping when pasting text.
" set linebreak                   " Wrap at convenient characters, set in 'breakat'.
set ignorecase                  " Case insensitive searches.
set smartcase                   " Override the 'ignorecase' option if the search pattern contains upper case characters.
set splitbelow                  " Puts new split windows to the bottom of the current.
set splitright                  " Puts new vsplit windows to the right of the current.
set incsearch                   " Search as characters are entered.
" set hlsearch                    " Highlight search matches.
set showmatch                   " Highlight matching [{()}].
set number                      " Show line numbers.
set nrformats-=octal            " Numbers beginning with '0' not considered.
set shiftround                  " Round indents to nearest multiple of 'shiftwidth'.
set tabpagemax=50               " Maximum number of tab pages to be opened by the |-p| command line argument.
set ttimeout                    " Enable timout on key mappings and insert-mode <CTRL-*> commands.
set sidescrolloff=5             " Minimal number of screen columns to keep.
set ttimeoutlen=50              " Limit the timeout to 50 milliseconds.
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 EOLs.
set complete+=i
set completeopt=menuone,longest,preview
                                " More detailed and accurate insert mode completion
" Completion ignore patterns.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*.min.css,*.min.js

" Whitespace stuff: 2 character soft tabs.
set smarttab                    " Emulate tab behaviour with spaces.
set expandtab                   " Tabs are spaces.
set shiftwidth=2                " 4 spaces per tab.
set softtabstop=2               " Number of spaces in tab when editing.
set tabstop=2                   " Number of visual spaces per tab.

" Indenting.
set cindent                     " Indent from previous line, with C syntax.

set display+=lastline           " Display as much as possible of last line in window, '@@@' when truncated.
set ruler                       " Show the line and column number of the cursor position.
set viminfo^=%                  " Remember info about open buffers on close.
set t_RV=                       " Temporary fix prevents unexpected keypresses on startup.
set lazyredraw                  " Don't redraw while executing macros (good performance config).
set ttyfast                     " Send more characters for redraws.

" Mouse.
set mouse=ar                    " Enable mouse use in all modes.
set ttymouse=xterm2             " Name of the mouse-code supporting terminal.

set backspace=indent,eol,start  " Allow backspacing over autoindent, line breaks and start of insert action.
set gcr=a:blinkon0              " Disable cursor blink.
set nofoldenable                " Disable folding

" Set the screen title to the current filename.
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Fixes airline showing only when a NERDTree is open.
" https://github.com/bling/vim-airline/issues/501
set laststatus=2                " 2=always, status line for the last window.

" Font.
set guifont=OxygenMono-Regular:h14
set antialias

" Encoding.
if has('multi_byte')
  let &termencoding = &encoding
  set encoding=UTF-8            " Better default than latin1
  setglobal fileencoding=UTF-8  " Change default file encoding when writing new files
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+  " Strings to use in `:ist` command
endif

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j  " Delete comment character when joining commented lines
endif



" ================ GUI Mode Specific ================

if has('gui_running')
  set guioptions-=m  " No menu.
  set guioptions-=T  " Disable toolbar.
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r  " Disable scrollbars.
  set guioptions-=R
endif

" Let MacVim control the shift key, for selecting with shift.
if has('gui_macvim')
	let macvim_skip_colorscheme = 1
  let macvim_hig_shift_movement = 1
endif



" ================ Mappings ================

" ==== Plugins ====
nmap <Leader>s :SyntasticToggle<CR>
nmap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>r :<C-U>RangerChooser<CR>
nnoremap <Leader>a :Ack<Space>
nmap <Leader>tt :TagbarToggle<CR>
noremap  <Leader>g :GitGutterToggle<CR>

" nmap <Leader>d :lclose<CR>:bnext<CR>:bwipe #<CR>
nmap <Leader>q :bp <BAR> bd #<CR>
nmap <Leader>bl :ls!<CR>

" Strip trailing whitespace
nmap <Leader>sw :%s/\s\+$//e<CR>
map <Leader>pp :setlocal paste!<cr>  " Toggle paste mode on and off
map <Leader>c gc<CR>
nnoremap ; :
noremap <C-Tab> :bn<cr>
noremap <C-S-Tab> :bp<cr>
nmap <leader>l :bnext<CR>
nmap <Leader>h :bprevious<CR>
map <C-n> :NERDTreeToggle<CR>

" Disable arrow keys.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Switch CWD to the directory of the open buffer
" TODO: Different to autochdir?
map <Leader>cd :cd %:p:h<cr>:pwd<cr>

" Useful mappings for managing tabs.
map <Leader>t :tabnew<cr>
map <Leader>c :tabclose<cr>
map <Leader>tn :tabnew<cr>
map <Leader>to :tabonly<cr>
map <Leader>tc :tabclose<cr>
map <Leader>tm :tabmove<CR>
" map <C-w> :tabclose<CR>

" Smart way to move between windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move line by line even when the line is wrapped.
map j gj
map k gk

" Toggle search highlighting.
nnoremap <ESC> :set nohlsearch<CR>

" Clear highlight after search
noremap <silent><Leader>/ :noh<CR>
" Quick save <,w>
nmap <Leader>w :w!<cr>
cmap w!! %!sudo tee > /dev/null %

" Reset syntax highlighting to default before setting colour scheme
highlight clear
syntax reset
" colorscheme Tomorrow-Night
" colorscheme Monokai
" colorscheme gruvbox
colorscheme monokain



" ================ Auto Commands ================

if has('autocmd')
  " Drupal files
  augroup drupal 
    autocmd!
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
    autocmd BufRead,BufNewFile *.engine set filetype=php
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
  augroup END

  " Prevent stopping on - characters for CSS files.
  augroup iskeyword_mods
    autocmd!
    autocmd FileType css setlocal iskeyword+=-
    autocmd FileType scss setlocal iskeyword+=-
    autocmd FileType sass setlocal iskeyword+=-
  augroup END

  " Other filetypes
  augroup special_filetypes
    autocmd!
    autocmd BufRead,BufNewFile *.scss set filetype=scss
  augroup END

  " NERDTree.
  augroup nerdtree
    autocmd!
    autocmd vimenter * NERDTree  " Open NERDTree on vim startup.
    autocmd VimEnter * wincmd p  " Focus on the editor window instead of NERDTree.
  augroup END

  " Reload Vim configuration when saving to ~/.vimrc.
  augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC execute 'syntax reset'
    autocmd BufWritePost $MYVIMRC execute 'syntax on'
    autocmd BufWritePost $MYVIMRC execute 'AirlineRefresh'
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
  augroup END

  " Enable omni completion.
  set omnifunc=syntaxcomplete#Complete
  augroup omnifuncs
    autocmd!
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END

  " Return to last edit position when opening files
  augroup restore_position
    autocmd!
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
    augroup END
  augroup END
endif



" ================ Functions ================

" @see https://github.com/hut/ranger/blob/master/doc/examples/vim_file_chooser.vim
"
" Compatible with ranger 1.4.2 through 1.6.*
"
" Add ranger as a file chooser in vim
"
" If you add thi s code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<Leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
  let temp = tempname()
  " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
  " with ranger 1.4.2 through 1.5.0 instead.
  "exec 'silent !ranger --choosefile=' . shellescape(temp)
  exec '!ranger --choosefiles=' . shellescape(temp)
  if !filereadable(temp)
    redraw!
    " Nothing to read.
    return
  endif
  let names = readfile(temp)
  if empty(names)
    redraw!
    " Nothing to open.
    return
  endif
  " Edit the first item.
  execute ':edit ' . fnameescape(names[0])
  " Add any remaning items to the arg list/buffer list.
  for name in names[1:]
    execute ':argadd ' . fnameescape(name)
  endfor
  redraw!
endfunction
command! -bar RangerChooser call RangeChooser()


" Change to random colorscheme from a defined list of awesome ones.
function! RandomColorscheme()
  let colorschemes = [
    \'Monokai',
    \'monokain',
    \'jellybeans',
    \'grb256',
    \'ir_black',
    \'molokai',
    \'gruvbox',
    \'hybrid',
    \'badwolf',
    \'Tomorrow-Night'
    \]
  let new_colorscheme = colorschemes[localtime() % len(colorschemes)]
  execute ':colorscheme ' . new_colorscheme
endfunction
command! -bar RandomColorscheme call RandomColorscheme()

" Change to random font from a defined list of awesome ones.
function! RandomFont()
  let guifonts = [
    \'Inconsolata:h15.5',
    \'Menlo:h14',
    \'Monaco:h13',
    \'Office\ Code\ Pro\ D:h14',
    \'OxygenMono-Regular:h14',
    \'Ubunu\ Mono:h16'
    \]
  let new_guifont = guifonts[localtime() % len(guifonts)]
  execute ':set guifont=' . new_guifont
  command! -bar RandomFont call RandomFont()
endfunction



" ================ Import local vimrc `~/.vimrc.local` ================

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

