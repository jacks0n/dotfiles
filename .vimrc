" vim: set ft=vim

set nocompatible  " Enable Vim-specific features, disable Vi compatibility.
filetype off
call plug#begin('~/.vim/plugged')

" ==== Dependencies ====
Plug 'vim-scripts/progressbar-widget' " Required for phpcd.
Plug 'tpope/vim-dispatch'             " Required for ack.vim async support.
if has('nvim')
  Plug 'rbgrouleff/bclose.vim'        " Required for ranger.vim on NeoVim.
endif

" === Un-organised ===
Plug 'cohama/lexima.vim'            " Insert mode auto-complete quotes, parens, brackets, etc.
Plug 'mhinz/vim-startify'           " Fancy start screen.
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ==== Completion ====
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }

" PHP.
if has('nvim')
  Plug 'phpvim/phpcd.vim', { 'for': 'php' }
else
  Plug 'shawncplus/phpcomplete.vim',  { 'for': 'php' }
endif

" ==== Search ====
Plug 'ctrlpvim/ctrlp.vim'
Plug 'JazzCore/ctrlp-cmatcher'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'mileszs/ack.vim'
Plug 'rking/ag.vim'
" Plug 'wincent/command-t'

" ==== CSS/SASS ====
Plug 'ap/vim-css-color',       { 'for': ['css', 'scss', 'sass', 'less'] } " Highlight CSS colours with the rule value.
Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss', 'sass', 'less'] } " Enable CSS3 property awareness.
Plug 'JulesWang/css.vim',      { 'for': ['css', 'scss', 'sass', 'less'] } " CSS syntax highlighting for @page, @media, @import, @keyframe, etc.
Plug 'cakebaker/scss-syntax.vim'                                          " Syntax file for SCSS.

" ==== HTML ====
Plug 'Valloric/MatchTagAlways'        " Highlight outer cursor (X)HTML tags.
Plug 'mattn/emmet-vim'                " Emmet for Vim.
Plug 'othree/html5.vim'               " HTML 5 omnicomplete and syntax.
Plug 'tylerbrazier/HTML-AutoCloseTag' " Auto close HTML tags.

" ==== Javascript ====
Plug 'jelera/vim-javascript-syntax'           " Enhanced Javascript Syntax.
Plug 'vim-scripts/JavaScript-Indent'          " Javascript indentation (including in HTML).
Plug 'pangloss/vim-javascript'                " Improved Javascript indentation and syntax.
Plug 'othree/javascript-libraries-syntax.vim' " Popular Javascript library syntax.
Plug 'ternjs/tern', { 'do': 'npm install' }   " JavaScript code analyzer for deep, cross-editor language support.

" ==== PHP ====
" Plug 'spf13/PIV'
Plug 'StanAngeloff/php.vim'    " PHP syntax file.
Plug '2072/vim-syntax-for-PHP' " Fork of official Vim PHP syntax file.
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
" Plug 'dsawardekar/wordpress.vim', { 'for': 'php' }   " WordPress API completion

" ==== Visual ====
Plug 'airblade/vim-gitgutter'         " Git gutter column diff signs.
Plug 'henrik/vim-indexed-search'      " Show 'At match #N out of M matches.' when searching.
Plug 'haya14busa/incsearch.vim'       " Incremental highlight all search results.
Plug 'vim-scripts/ScrollColors'       " Colorsheme Scroller, Chooser, and Browser.
Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and helper function.
Plug 'Yggdroot/indentLine'            " Adds vertical and/or horizontal alignment lines.

" === Themes ===
Plug 'flazz/vim-colorschemes' " All single-file vim.org colour schemes.

" ==== Text Editing ====
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'

" ==== Sidebars ====
Plug 'sjl/gundo.vim'               " Undo history.
Plug 'majutsushi/tagbar'           " Sidebar for tags.
Plug 'scrooloose/nerdtree'         " File browser.
Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree Git integration.

" ==== Functional ====
Plug 'chrisbra/Recover.vim'               " Show a diff whenever recovering a buffer.
Plug 'wincent/terminus'                   " Terminal improvements. Cursor shape change, improved mouse support, fix autoread, auto paste.
Plug 'sheerun/vim-polyglot'               " Language pack collection (syntax, indent, ftplugin, ftdetect).
Plug 'tpope/vim-eunuch'                   " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'tpope/vim-repeat'                   " Enable repeating supported plugin maps with '.'.
Plug 'scrooloose/syntastic'               " Linter support.
Plug 'alvinhuynh/vim-syntastic-scss-lint' " Sytastic `scsslint` integration.
Plug 'vim-utils/vim-troll-stopper'        " Highlight Unicode trolls/homoglyph.
Plug 'francoiscabrol/ranger.vim'          " Rander file manager integration.
" Plug 'shuber/vim-promiscuous'

call plug#end() " Required.


" ================ Plugin Settings ================

" gitgutter
let g:gitgutter_max_signs = 1000
" let g:gitgutter_override_sign_column_highlight = 0
" highlight GitGutterAdd          ctermbg=NONE guibg=NONE
" highlight GitGutterChange       ctermbg=NONE guibg=NONE
" highlight GitGutterDelete       ctermbg=NONE guibg=NONE
" highlight GitGutterChangeDelete ctermbg=NONE guibg=NONE

" ack.vim
" if executable('ag')
"   let g:ackprg = 'ack --vimgrep'
" endif
" Show up to 50 lines
" let g:ack_qhandler = 'botright copen 50'
" let g:ack_lhandler = 'botright lopen 50'
" let g:ackhighlight = 1
" let g:ack_autoclose = 1
" let g:ackpreview = 1
" let g:ack_use_dispatch = 1
" let g:ack_default_options = ' --smart-case --heading --column --follow'

" indentLine
let g:indentLine_char = '│'

" YouCompleteMe.
let g:ycm_auto_trigger                              = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files       = 1

" phpcomplete.
let g:phpcomplete_parse_docblock_comments = 1

" startify.
let g:startify_change_to_dir          = 1 " Change to selected file or bookmark's directory.
let g:startify_enable_special         = 0 " Don't show <empty buffer> and <quit>.
let g:startify_relative_path          = 1 " Show relative filenames (directories by default).
let g:startify_session_autoload       = 1 " Auto load `Session.vim` if present when opening Vim.
let g:startify_session_delete_buffers = 1 " Delete open buffers before loading a new session.
let g:startify_session_persistence    = 1 " Update session before closing Vim and loading session with `:SLoad`.
let g:startify_custom_header  =
  \ map(split(system('fortune -s | cowsay'), '\n'), '"   ". v:val') + ['','']

" Airline
let g:airline_theme = 'luna'
" let g:airline_theme = 'bubblegum'
" let g:airline_theme = 'badwolf'
" let g:airline_theme = 'wombat'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled            = 1
let g:airline#extensions#bufferline#enabled        = 1
let g:airline#extensions#capslock#enabled          = 1
let g:airline#extensions#ctrlp#show_adjacent_modes = 1
let g:airline#extensions#hunks#enabled             = 1
let g:airline#extensions#syntastic#enabled         = 1
let g:airline#extensions#tabline#enabled           = 1
let g:airline#extensions#undotree#enabled          = 1
let g:airline#extensions#unite#enabled             = 1
let g:airline#extensions#whitespace#enabled        = 1

" NerdTree
let NERDTreeShowBookmarks = 1
let NERDTreeIgnore = ['\\.pyc', '\\\~$', '\\.swo$', '\\.swp$', '\\.git', '\\.hg', '\\.svn', '\\.bzr']
let NERDTreeChDirMode = 0
" let NERDTreeQuitOnOpen = 1
" let NERDTreeKeepTreeInNewTab = 1

" Syntastic
" let g:syntastic_error_symbol = '✗'
" let g:syntastic_warning_symbol = '⚠'
let g:syntastic_aggregate_errors = 1         " Run all linters, even if first found errors.
let g:syntastic_always_populate_loc_list = 1 " Add errors to location-list.
let g:syntastic_auto_loc_list = 1            " Automatically open/close location-list if errors are found.
let g:syntastic_check_on_open = 1
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_javascript_jshint_args = '--config /Users/flightcentre/drupal-dev-env/web/docroot/.jshintrc'
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = '--standard=Drupal'
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_scss_checkers = ['scss-lint']
let g:syntastic_scss_scss_lint_args = '--config /Users/flightcentre/drupal-dev-env/docroot-unison/docroot/.scss-lint.yml'
let g:syntastic_text_checkers = ['proselint']
let g:syntastic_json_checkers = ['jsonlint']

" CtrlP
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
let g:ctrlp_match_window_bottom = 1 " Show match window at the top of the screen
let g:ctrlp_max_files = 0           " No file list limit.
let g:ctrlp_max_depth = 100         " Default 40.
let g:ctrlp_switch_buffer = 'et'    " Jump to a file if it's open already
let g:ctrlp_clear_cache_on_exit = 0 " Speed up by not removing clearing cache evertime.
let g:ctrlp_mruf_max = 250          " Number of recently opened files
let g:ctrlp_map = '<C-p>'
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\files\|tmp\|vendor$',
  \ 'file': '\.(DS_Store|.min.js|.min.css)$'
  \}



" ================ Plugin Mapping ================

" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)

" Fire up FZF.
map <Leader>f :FZF<CR>

" ranger.vim.
nmap <Leader>r :call OpenRanger()<CR>

" Choose file to edit from most recently opened.
nmap <Leader>m :CtrlPMRUFiles<CR>
nmap <silent> <C-m> :CtrlPMRUFiles<CR>

" Incsearch.
let g:incsearch#auto_nohlsearch = 1
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)

" NERDTree.
map <Leader>n :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <C-n> :NERDTreeToggle \| :silent NERDTreeMirror<CR>
nmap <Leader>nt :NERDTreeFind<CR>

" Syntastic.
nmap <Leader>s :SyntasticToggle<CR>
nmap <Leader>sc :SyntasticCheck<CR>

" Ack.
nnoremap <Leader>a :Ack<Space>

" Tagbar.
nnoremap <Leader>tt :TagbarToggle<CR>

" GitGutter.
noremap <Leader>g :GitGutterToggle<CR>



" ================ Plugin Autocommands ================

if has('autocmd')
  " Close NERDTree when closing the last window/exiting Vim.
  autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif

  " Open Tagbar by default for some filetypes.
  " autocmd FileType php,javascript,python,vim nested :TagbarOpen

  " Strip whitespace on save.
  autocmd BufWritePre * StripWhitespace
endif



" ================ General Config ====================

filetype plugin indent on  " Enable file type detection.

let mapleader = ','
let g:mapleader = ','

syntax enable  " Enable syntax highlighting.

set background=dark
set conceallevel=0 " Don't conceal quotes in JSON files.

set autochdir  " Automatically change to the directory of the file open.
set autoread   " Re-load files on external modifications and none locally.
set autowrite  " Automatically save before :next, :make etc.
set whichwrap=b,s,h,l,<,>,[,] " Characters which wrap lines (b = <BS>, s = <Space>).

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

" Backup, swap, and undo.
set backup
set backupdir=~/.vim/backup
set backupskip=/tmp/*,/private/tmp/*,~/tmp/*
set writebackup

" Swap files.
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//,/tmp//,~/tmp//

" Better command-line completion, with menu
set wildchar=<Tab>
set wildmode=longest,list,full
set wildmenu

set cursorline                  " Highlight line of the cursor.
set showcmd                     " Show (partial) command in the last line of the screen.
set tags=./.tags,.tags;
set clipboard=unnamed           " Use OS clipboard register.
set history=10000               " Number of commands remembered.
set smartindent                 " Smart auto-indenting when starting a new line.
set autoindent                  " Auto-indent inserted lines.
set copyindent                  " Use current line indenting when starting a new line.
set hidden                      " Hide unsaved buffers instead of close on file open.
set modeline                    " Enable modelines.
set modelines=5                 " Look for modelines in the first and last X lines.
set nowrap                      " Don't wrap lines.
set textwidth=0                 " Disable wrapping when pasting text.
" set linebreak                 " Wrap at convenient characters, set in 'breakat'.
set ignorecase                  " Case insensitive searches.
set smartcase                   " ... but not when search pattern contains an upper case character.
set splitbelow                  " Puts new split windows to the bottom of the current.
set splitright                  " Puts new vsplit windows to the right of the current.
set incsearch                   " Search as characters are entered.
set hlsearch                    " Highlight all search matches.
set showmatch                   " Highlight matching [{()}].
set winminheight=0              " Allow 0 line windows.
set number                      " Show line numbers.
set relativenumber              " Show relative line numbers.
set nrformats-=octal            " Numbers beginning with '0' not considered.
set shiftround                  " Round indents to nearest multiple of 'shiftwidth'.
set tabpagemax=50               " Maximum number of tab pages to be opened by the |-p| command line argument.
set ttimeout                    " Enable timout on key mappings and insert-mode <CTRL-*> commands.
set scrolloff=1                 " Scroll offset lines.
set sidescrolloff=5             " Minimal number of screen columns to keep.
set ttimeoutlen=50              " Limit the timeout to 50 milliseconds.
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 EOLs.
set completeopt=menu,menuone,longest,preview,noselect

" More detailed and accurate insert mode completion.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*  " Completion ignore patterns.
set wildignore+=*.min.css,*.min.js         " Completion ignore patterns.

set smarttab                    " Emulate tab behaviour with spaces.
set expandtab                   " Tabs are spaces.
set shiftwidth=2                " 4 spaces per tab.
set softtabstop=2               " Number of spaces in tab when editing.
set tabstop=2                   " Number of visual spaces per tab.
set cindent                     " Indent from previous line, with C syntax.
set display+=lastline           " Display as much as possible of last line in window, '@@@' when truncated.
set ruler                       " Show the line and column number of the cursor position.
set viminfo^=%                  " Remember info about open buffers on close.
set t_RV=                       " Temporary fix prevents unexpected keypresses on startup.
set lazyredraw                  " Don't redraw while executing macros (good performance config).
set ttyfast                     " Send more characters for redraws.
set mouse=ar                    " Enable mouse use in all modes.
" set ttymouse=xterm2           " Name of the mouse-code supporting terminal. Incompatible with nvim?
set backspace=indent,eol,start  " Allow backspacing over autoindent, line breaks and start of insert action.
set gcr=a:blinkon0              " Disable cursor blink.
set foldlevelstart=99           " Open all folds by default.
set nofoldenable                " Disable folding.

" Set the screen title to the current filename.
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Fixes airline showing only when a NERDTree is open.
" https://github.com/bling/vim-airline/issues/501
set laststatus=2 " 2=always, status line for the last window.

" Set `colorscheme` and `guifont` only on startup.
if has('vim_starting')
  " colorscheme monokain
  colorscheme molokai
  set guifont=Source\ Code\ Pro\ for\ Powerline:h15
endif

set antialias

" Encoding.
if has('multi_byte')
  if has('vim_starting')
    set encoding=UTF-8 " Better default than latin1.
  endif
  let &termencoding = &encoding
  setglobal fileencoding=UTF-8  " Change default file encoding when writing new files.
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+  " Strings to use in `:ist` command.
endif

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j  " Delete comment character when joining commented lines.
endif

" Visual.
set colorcolumn=80

" NeoVim Specific.
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif



" ================ Shell Filetype ================

let g:is_posix = 1 " Stop error highlighting `$()`.



" ================ GUI Mode Specific ================

if has('gui_running')
  set guioptions+=c " Use console dialogs instead of popup dialogs for simple choices.
  set guioptions-=m " Disable menu bar.
  set guioptions-=L " Disable left-hand scrollbar when vertical split open.
  set guioptions-=r " Disable right-hand scrollbar.
endif

" Let MacVim control the shift key, for selecting with shift.
if has('gui_macvim')
  set macmeta " Use option (alt) as meta key.
	let macvim_skip_colorscheme = 1
  let macvim_hig_shift_movement = 1

  map <D-w> :bw<CR>
  map <D-n> :enew<CR>
endif



" ================ Mappings ================

" New empty buffer.
map <C-t> :enew<CR>
map <Leader>e :enew<CR>

" Close buffer.
map <Leader>d :lclose<CR>:bwipe!<CR>

" Toggle spell checking.
map <leader>ss :setlocal spell!<CR>

" Toggle search highlighting.
noremap <ESC> :set hlsearch! hlsearch?<CR>

" Strip trailing whitespace.
nmap <Leader>sw :%s/\s\+$//e<CR>

" Easier EX mode.
nnoremap ; :

" Jump between next and previous buffers.
map <Leader>] :lclose<CR>:bprev<CR>
map <Leader>[ :lclose<CR>:bnext<CR>
map <Leader>, :lclose<CR>:bprev<CR>
map <Leader>. :lclose<CR>:bnext<CR>
noremap <C-Tab> :lclose<CR>:bnext<CR>
noremap <C-S-Tab> :lclose<CR>:bprev<CR>

" Don't exist Visual mode when shifting.
xnoremap <  <gv
xnoremap >  >gv

" Code folding options.
nmap <leader>fl0 :set foldlevel=0<CR>
nmap <leader>fl1 :set foldlevel=1<CR>
nmap <leader>fl2 :set foldlevel=2<CR>
nmap <leader>fl3 :set foldlevel=3<CR>
nmap <leader>fl4 :set foldlevel=4<CR>
nmap <leader>fl5 :set foldlevel=5<CR>
nmap <leader>fl6 :set foldlevel=6<CR>
nmap <leader>fl7 :set foldlevel=7<CR>
nmap <leader>fl8 :set foldlevel=8<CR>
nmap <leader>fl9 :set foldlevel=9<CR>

" DWIM shift keys.
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q
cmap Tabe tabe

" Disable arrow keys. Get off my lawn.
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>

" Switch CWD to the directory of the open buffer.
map <Leader>cd :cd %:p:h<cr>:pwd<cr>

" Easier way to move between windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move up/down by row rather than line in file, even when the line is wrapped.
map j gj
map k gk

" Clear highlight after search.
noremap <silent><Leader>/ :noh<CR>

" Quick save <,w>
nmap <Leader>w :w!<CR>
cmap w!! %!sudo tee > /dev/null %

if has('nvim')
  " Terminal to Normal mode with <ESC>.
  tnoremap <Esc> <C-\><C-n>
endif



" ================ Highlighting  ================

" Brighten line numbers.
highlight LineNr guifg=#FAFAFA

" No current line number background.
" highlight CursorLineNr ctermbg=NONE guibg=NONE
" No sign column without symbol background. Many themes don't implement it.
" highlight SignColumn ctermbg=NONE guibg=NONE

let g:php_sync_method = -1 " Default, but it gives warnings without explicit `let`.


" ================ Auto Commands ================

" Drupal PHP filetypes.
augroup drupal
  autocmd!
  autocmd BufRead,BufNewFile *.engine  set filetype=php
  autocmd BufRead,BufNewFile *.inc     set filetype=php
  autocmd BufRead,BufNewFile *.install set filetype=php
  autocmd BufRead,BufNewFile *.module  set filetype=php
  autocmd BufRead,BufNewFile *.profile set filetype=php
  autocmd BufRead,BufNewFile *.test    set filetype=php
  autocmd BufRead,BufNewFile *.theme   set filetype=php
  autocmd BufRead,BufNewFile *.view    set filetype=php
  " autocmd BufRead,BufNewFile *.tpl.php set filetype=phtml
augroup END

" Prevent stopping on - characters for CSS files.
augroup iskeyword_mods
  autocmd!
  autocmd FileType css,scss,sass  setlocal iskeyword+=-
augroup END

" Other filetypes.
augroup special_filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.scss set filetype=scss.css
augroup END

" Enable omni-completion.
set omnifunc=syntaxcomplete#Complete
augroup omnifuncs
  autocmd!
  if has('nvim')
    autocmd FileType php setlocal omnifunc=phpcd#CompletePHP
  else
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  endif
  autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType javascript    setlocal omnifunc=tern#Complete
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
augroup END

" Return to last edit position when opening files.
augroup restore_position
  autocmd!
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
augroup END



" ================ Functions ================

" Change to random colorscheme from a defined list of awesome ones.
function! RandomColorscheme()
  let colorschemes = [
    \'Monokai',
    \'Tomorrow-Night',
    \'apprentice',
    \'badwolf',
    \'bluechia',
    \'bubblegum',
    \'candyman',
    \'codeschool',
    \'flattr',
    \'grb256',
    \'gruvbox',
    \'hybrid',
    \'ir_black',
    \'jellybeans',
    \'molokai',
    \'monokain',
  \]
  let new_colorscheme = colorschemes[localtime() % len(colorschemes)]
  execute ':colorscheme ' . new_colorscheme
endfunction
command! -bar RandomColorscheme call RandomColorscheme()

" Change to random font from a defined list of awesome ones.
function! RandomFont()
  let guifonts = [
    \'Fira\ Code\ Retina:h15',
    \'Inconsolata\ for\ Powerline:h17',
    \'Input\ Mono:h15',
    \'Menlo\ for\ Powerline:h15.5',
    \'Meslo\ LG\ M\ DZ\ for\ Powerline:h15',
    \'Monaco\ for\ Powerline:h15',
    \'Office\ Code\ Pro\ D:h15',
    \'PT\ Mono\ for\ Powerline:h16',
    \'Source\ Code\ Pro\ for\ Powerline:h15',
    \'Ubuntu\ Mono\ derivative\ Powerline:h17',
  \]
  let new_guifont = guifonts[localtime() % len(guifonts)]
  execute ':set guifont=' . new_guifont
endfunction
command! -bar RandomFont call RandomFont()

" Automatically fit a quickfix window height, depending on number of lines.
" https://gist.github.com/juanpabloaj/5845848
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
        " number to float for division
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . 'wincmd _'
endfunction



" ================ Import local vimrc `~/.vimrc.local` ================

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
