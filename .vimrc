" Good References:
"  - https://github.com/davidosomething/dotfiles/blob/master/vim/vimrc
"  - https://github.com/bling/dotvim/blob/master/vimrc

set nocompatible " Enable Vim-specific features, disable Vi compatibility.
filetype off
call plug#begin('~/.vim/plugged')

" ========================================================================
" Plug: Un-Organised.                                                    |
" ========================================================================

" Options:
"  'Townk/vim-autoclose'  - Works well. Gets stuck in insert mode with YouCompleteMe.
"  'cohama/lexima.vim'    - Works well, inserts closing character, not that intelligent.
"  'jiangmiao/auto-pairs' - Seems the most intelligent, can get slow.
" Plug 'cohama/lexima.vim'
" Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'              " Add close (X)HTML tags on creation.
"       \ { 'for': ['html', 'php', 'xhtml', 'xml', 'jinja'] }
Plug 'mhinz/vim-startify' " Fancy start screen.
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'jreybert/vimagit'
Plug 'vim-airline/vim-airline'
  \| Plug 'vim-airline/vim-airline-themes'
Plug 'Mizuchi/vim-ranger'
Plug 'rakr/vim-one'
Plug 'embear/vim-localvimrc'


" ========================================================================
" Plug: Completion.                                                      |
" ========================================================================

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
endif

Plug 'SirVer/ultisnips'
  \| Plug 'honza/vim-snippets'           " Common snippets for many language.
  \| Plug 'sniphpets/sniphpets'          " Helper functions to ceate snippets.
  \| Plug 'sniphpets/sniphpets-common'   " Common PHP snippets.
  \| Plug 'sniphpets/sniphpets-symfony'  " Common Symfony snippets.
  \| Plug 'algotech/ultisnips-php'       " Common PHP, PHPUnit, and Symnfony snippets.
  \| Plug 'sniphpets/sniphpets-doctrine' " Common Doctrine snippets.

" Plug 'vhakulinen/neovim-intellij-complete-deoplete' " PhpStorm completion!
" Plug 'dansomething/vim-eclim'


" ========================================================================
" Plug: Search.                                                          |
" ========================================================================

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  \| Plug 'junegunn/fzf.vim'
" Plug 'mhinz/vim-grepper'       " Asynchronous search.
Plug 'rking/ag.vim'


" ========================================================================
" Plug: Visual.                                                          |
" ========================================================================

Plug 'airblade/vim-gitgutter'         " Git gutter column diff signs.
Plug 'henrik/vim-indexed-search'      " Show 'At match #N out of M matches.' when searching.
Plug 'haya14busa/incsearch.vim'       " Incremental highlight all search results.
Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and helper function.
Plug 'Yggdroot/indentLine'            " Adds vertical and/or horizontal alignment lines.
" Plug 'yonchu/accelerated-smooth-scroll' " Accelerated smooth-scrolling.
" Plug 'terryma/vim-smooth-scroll'      " Smooth-scrolling.
Plug 'matze/vim-move'                 " Move lines and selections up and down.


" ========================================================================
" Plug Language: CSS, SASS.                                              |
" ========================================================================

" ----------------------------------------
" Syntax.                                |
" ----------------------------------------

" Options:
"  'JulesWang/css.vim'         - Cutting-edge CSS syntax file.
"  'hail2u/vim-css3-syntax'    - Adds CSS3 properties, except for @media.
"  'cakebaker/scss-syntax.vim' - SCSS syntax.
Plug 'JulesWang/css.vim', { 'for': ['css', 'scss', 'sass'] }
Plug 'hail2u/vim-css3-syntax',    { 'for': ['css', 'scss', 'sass'] } " CSS3 syntax.
Plug 'cakebaker/scss-syntax.vim', { 'for': ['css', 'scss'] }         " SCSS syntax.

" ----------------------------------------
" Features.                              |
" ----------------------------------------

" Highlight CSS colours with the rule value.
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass'] }
" Auto-complete properties and values.
Plug 'rstacruz/vim-hyperstyle', { 'for': ['css', 'scss', 'sass'] }


" ----------------------------------------
" Omnicompletion.                        |
" ----------------------------------------

Plug 'othree/csscomplete.vim', { 'for': ['css', 'scss', 'sass'] }


" ========================================================================
" Plug Language: CSV.                                                    |
" ========================================================================

" Plug 'chrisbra/csv.vim', { 'for': 'csv' }


" ========================================================================
" Plug Language: HTML, XML.                                              |
" ========================================================================

Plug 'Valloric/MatchTagAlways',        " Highlight outer cursor (X)HTML tags.
  \ { 'for': ['html', 'phtml', 'xhtml', 'xml', 'jinja'] }
Plug 'mattn/emmet-vim',                " Emmet for Vim.
  \ { 'for': ['html', 'phtml', 'xhtml', 'xml', 'jinja'] }
Plug 'othree/html5.vim',               " HTML 5 omnicomplete and syntax.
  \ { 'for': ['html', 'php', 'xhtml', 'xml', 'jinja'] }

" Options:
"  'tylerbrazier/HTML-AutoCloseTag' - Unmaintained, extra <Esc> back to normal mode.
Plug 'docunext/closetag.vim' " Intelligently auto-close (X)HTML tags.
  \ { 'for': ['html', 'php', 'xhtml', 'xml', 'jinja'] }


" ========================================================================
" Plug Language: JavaScript, JSON.                                       |
" ========================================================================

" ----------------------------------------
" Syntax and Indent.                     |
" ----------------------------------------

Plug 'elzr/vim-json', { 'for': ['javascript', 'json'] }

" Options:
"  'jiangmiao/simple-javascript-indenter' - Indent, unmaintained.
"  'pangloss/vim-javascript'              - Indent and syntax, maintained.
"                                           Not great at docblock indentation.
"  'gavocanov/vim-js-indent'              - Indent part of pangloss/vim-javascript.
"  'jelera/vim-javascript-syntax'         - Syntax, maintained.
"  'othree/yajs.vim'                      - Syntax, maintained, fork of Jelera. Recognises
"                                         - web API and DOM keywords, supports ES6 syntax.
"  'othree/jsdoc-syntax.vim'              - JSDoc syntax.
"  'jason0x43/vim-js-indent'              - Indent for JavaScript and Typescript.
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Plug 'othree/yajs.vim',         { 'for': 'javascript' }
if has_key(g:plugs, 'yajs.vim')
  Plug 'othree/jsdoc-syntax.vim', { 'for': 'javascript' }
  Plug 'gavocanov/vim-js-indent', { 'for': 'javascript' }
  Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
endif

" ----------------------------------------
" Syntax Addons.                         |
" ----------------------------------------

Plug 'othree/javascript-libraries-syntax.vim', " Extends syntax for jQuery, Underscore, Backbone, etc.
    \ { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'jsx' }           " After syntax, ftplugin, indent for JSX.
" Plug 'bigfish/vim-js-context-coloring'         " Highlight based on context.

" ----------------------------------------
" Completion.                            |
" ----------------------------------------

Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' } " Adds more recent browser API support.
Plug 'othree/jspc.vim', { 'for': 'javascript' }                            " Parameter completion.
if !has_key(g:plugs, 'YouCompleteMe')                                      " YouCompleteMe provides TernJS.
  Plug 'ternjs/tern_for_vim',
    \ { 'do': 'npm install; npm update', 'for': 'javascript' }
endif

if has_key(g:plugs, 'deoplete.nvim')
  Plug 'carlitux/deoplete-ternjs',
    \ { 'do': 'npm install -g tern' } " Async goodness.
endif

" ----------------------------------------
" Features.                              |
" ----------------------------------------

Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' } " Generate function JSDoc docblocks with `:JsDoc`.


" ========================================================================
" Plug Language: Markdown.                                               |
" ========================================================================

Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }


" ========================================================================
" Plug Language: PHP.                                                    |
" ========================================================================

" ----------------------------------------
" Syntax.                                |
" ----------------------------------------

" Options:
"  '2072/vim-syntax-for-PHP'
"    - Updated fork of the official Vim syntax file.
"  'StanAngeloff/php.vim'
"    - Updated fork of a fork of the official Vim synax file.
"      More popular, not sure how different to 2072's?
"  'pzich/phtmlSwitch-vim'
"   - Automatically switching between HTML and PHP filetypes in PHP files.
Plug '2072/vim-syntax-for-PHP', { 'for': 'php' }
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
" Plug 'pzich/phtmlSwitch-vim', { 'for': 'php' }


" ----------------------------------------
" Indent.                                |
" ----------------------------------------

" Options:
"  '2072/PHP-Indenting-for-VIm'
"    - Development version of the official indent.
"  'captbaritone/better-indent-support-for-php-with-html'
"    - Adds HTML indenting outside PHP blocks.
Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' }
Plug 'captbaritone/better-indent-support-for-php-with-html', { 'for': 'php' }

" ----------------------------------------
" Completion.                            |
" ----------------------------------------

" Options:
"  'm2mdas/phpcomplete-extended' - Fast via vimproc, un-maintained, composer projects only.
"  'mkusher/padawan.vim'         - Server based, composer projects only.
"  'phpvim/phpcd.vim'            - Server based, NeoVim only, composer projects only, often crashes.
"  'shawncplus/phpcomplete.vim'  - Slow as fuck, included in $VIMRUNTIME.

" Server-based PHP completion.
if 0 && has('nvim')
  Plug 'phpvim/phpcd.vim', {
        \   'do': 'composer install',
        \   'for': 'php'
        \ }
    \| Plug 'vim-scripts/progressbar-widget'
elseif 0 && (has('python') || has('python3'))
  Plug 'mkusher/padawan.vim', {
        \   'do': 'composer global require mkusher/padawan',
        \   'for': 'php',
        \ }
elseif !has_key(g:plugs, 'vim-eclim') && !has_key(g:plugs, 'neovim-intellij-complete-deoplete')
  Plug 'shawncplus/phpcomplete.vim',  { 'for': 'php' }
endif


" ========================================================================
" Plug Language: Python.                                                 |
" ========================================================================

" YouCompleteMe provides Jedi.
if !has_key(g:plugs, 'YouCompleteMe')
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
endif

if has_key(g:plugs, 'deoplete.nvim')
  Plug 'zchee/deoplete-jedi'
endif


" ========================================================================
" Plug Language: Text.                                                   |
" ========================================================================

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'


" ========================================================================
" Plug Language: VimL.                                                   |
" ========================================================================

" Completion.
Plug 'Shougo/neco-vim', { 'for': 'vim' }


" ========================================================================
" Plug: Themes.                                                          |
" ========================================================================

Plug 'flazz/vim-colorschemes' " All single-file vim.org colour schemes.
Plug 'alessandroyorba/despacio'


" ========================================================================
" Plug: Text Editing.                                                    |
" ========================================================================

Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'tpope/vim-surround'


" ========================================================================
" Plug: Sidebars.                                                        |
" ========================================================================

" Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree Git integration.
" Plug 'scrooloose/nerdtree'         " File browser.
Plug 'majutsushi/tagbar'      " Sidebar for tags.
Plug 'hari-rangarajan/CCTree' " Symbol dependency tree.
Plug 'sjl/gundo.vim'          " Undo history.


" ========================================================================
" Plug: Linting.                                                         |
" ========================================================================

if has('nvim')
  " Asynchronous.
  " Run `Neomake` as you type.
  Plug 'benekastah/neomake'
    " \ | Plug 'dojoteef/neomake-autolint'
else
  Plug 'vim-syntastic/syntastic' " Linter support.
endif


" ========================================================================
" Plug: Functional.                                                      |
" ========================================================================

Plug '0x84/vim-coderunner'           " Run the buffer on the fly.
Plug 'chrisbra/Recover.vim'          " Show a diff whenever recovering a buffer.
Plug 'editorconfig/editorconfig-vim' " Some default configs.
Plug 'sheerun/vim-polyglot'          " Language pack collection (syntax, indent, ftplugin, ftdetect).
Plug 'tpope/vim-eunuch'              " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'tpope/vim-repeat'              " Enable repeating supported plugin maps with '.'.
Plug 'vim-utils/vim-troll-stopper'   " Highlight Unicode trolls/homoglyph.
Plug 'wincent/terminus'              " Terminal improvements. Cursor shape change, improved mouse support, fix autoread, auto paste.
Plug 'ludovicchabant/vim-gutentags'  " Automatic tag generation and updating.
Plug 'joonty/vdebug'                 " DBGP protocol debugger  (e.g. Xdebug).
Plug 'rhysd/committia.vim'           " Better `git commit` interface, with status and diff window.

call plug#end() " Required.


" ========================================================================
" General Config.                                                        |
" ========================================================================

filetype plugin indent on

let mapleader = ' '

syntax enable  " Enable syntax highlighting.

set background=dark
set conceallevel=0            " Don't conceal quotes in JSON files.

set autochdir                 " Automatically change to the directory of the file open.
set autoread                  " Re-load files on external modifications and none locally.
set autowrite                 " Automatically save before :next, :make etc.
set whichwrap=b,s,h,l,<,>,[,] " Characters which wrap lines (b = <BS>, s = <Space>).

set t_vb=
set noerrorbells              " Ring the bell (beep or screen flash) for error messages.
set visualbell                " Use visual bell instead of beeping.
set shortmess=aAI             " ┐ Avoid all the hit-enter prompts.
                              " | a: All abbreviations.
                              " | A: No existing swap file 'ATTENTION' message.
                              " ┘ I: No |:intro| starting message.

set iskeyword+=/              " Include slashes as part of a word
set scrolloff=7               " 7 lines to the cursor when moving vertically using j/k.

" Persistent undo.
if has('persistent_undo')
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
  endif
  set undofile                 " Save undo after file closes
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
set pumheight=20             " Maximum number of items to show in the omni complete menu.

set nostartofline            " Don't reset cursor to start of line when moving around.
set shortmess=aAI            " ┐ Avoid all the hit-enter prompts.
                             " │ a: All abbreviations.
                             " │ A: No existing swap file 'ATTENTION' message.
                             " ┘ I: No |:intro| starting message.
set spell                    " Enable spell checking.
set spelllang=en_au          " Set the spell checking language.
set cursorline               " Highlight line of the cursor.
set showcmd                  " Show (partial) command being typed.
set showmode                 " Show current mode.
set tags=./tags,tags;
set clipboard=unnamed        " Use OS clipboard register by default.
set history=10000            " Number of commands remembered.
set smartindent              " Smart auto-indenting when starting a new line.
set autoindent               " Auto-indent inserted lines.
set smartindent              " Smart auto indenting when starting a new line.
set magic                    " Enable extended regex.
set copyindent               " Use current line indenting when starting a new line.
set hidden                   " Hide unsaved buffers instead of close on file open.
set modeline                 " Enable modelines.
set modelines=5              " Look for modelines in the first and last X lines.
set nowrap                   " Don't wrap lines.
set textwidth=0              " Disable wrapping when pasting text.
" set linebreak              " Wrap at convenient characters, set in 'breakat'.
set ignorecase               " Case insensitive searches.
set fileignorecase           " Ignore file and directory case sensitivity.
set wildignorecase           " Ignore file and directory completion case sensitivity.
set smartcase                " ... but not when search pattern contains an upper case character.
set splitbelow               " Puts new split windows to the bottom of the current.
set splitright               " Puts new vsplit windows to the right of the current.
set incsearch                " Search as characters are entered.
set hlsearch                 " Highlight all search matches.
set showmatch                " Highlight matching [{()}].
set winminheight=0           " Allow 0 line windows.
set number                   " Show line numbers.
set relativenumber           " Show relative line numbers.
set nrformats-=octal         " Numbers beginning with '0' not considered.
set shiftround               " Round indents to nearest multiple of 'shiftwidth'.
set tabpagemax=50            " Maximum number of tab pages to be opened by the |-p| command line argument.
" set ttimeout                 " Enable timout on key mappings and insert-mode <CTRL-*> commands.
" set ttimeoutlen=50           " Limit the timeout to 50 milliseconds.
set scrolloff=1              " Scroll offset lines.
set sidescroll=5             " Minimal columns to show when `wrap` is set.
set sidescrolloff=5          " Minimal columns to show when `nowrap` is set.
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 EOLs.
set complete+=kspell         " Enable word completion.
set complete-=i              " Disable current and included file scanning, use tags instead.
set completeopt=menu,menuone,longest,noselect
" set completeopt+=preview

" More detailed and accurate insert mode completion.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " Completion ignore patterns.
set wildignore+=*.min.css,*.min.js        " Completion ignore patterns.

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
set backspace=indent,eol,start  " Allow backspacing over autoindent, line breaks and start of insert action.
set guicursor=a:blinkon0        " Disable cursor blink.
set synmaxcol=250               " Don't try to highlight long lines.
set foldmethod=indent           " Fold based on indent.
set laststatus=2                " Always show the status line.

" Set the screen title to the current filename.
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Set `colorscheme` and `guifont` only on startup.
if has('vim_starting')
  " colorscheme monokain
  " colorscheme molokai
  " colorscheme flattr
  " colorscheme hybrid
  colorscheme OceanicNext
  " colorscheme gruvbox
  set background=dark
  if has('gui')
    " set guifont=Droid\ Sans\ Mono\ for\ Powerline:h15
    set guifont=Hack:h15
    " set guifont=Inconsolata-dz\ for\ Powerline:h15
    " set guifont=Source\ Code\ Pro\ for\ Powerline:h15
    " set guifont=Ubuntu\ Mono\ derivative\ Powerline:h17.5
    " set guifont=mononoki:h16
  endif
endif

" NeoVim doesn't support this?
if has('antialias')
  set antialias
endif

" Encoding.
if has('vim_starting')
  set encoding=utf-8 nobomb " Better default than latin1.
  scriptencoding utf-8
endif
let &termencoding = &encoding
setglobal fileencoding=UTF-8  " Change default file encoding when writing new files.
set listchars=tab:→\          " ┐
set listchars+=trail:·        " │ Use custom symbols to
set listchars+=eol:↲          " │ represent invisible characters.
set listchars+=extends:»      " │
set listchars+=precedes:«     " │
set listchars+=nbsp:⣿         " ┘
set showbreak=↪

" Auto-formatting options.
set formatoptions-=t " Don't auto-wrap text using textwidth...
set formatoptions+=c " ... Unless it's a comment.
set formatoptions+=r " Auto insert the current comment leader after hitting <Enter> in Insert mode.
set formatoptions+=o " Auto insert the current comment leader after hitting 'o' or 'O' in Normal mode.
set formatoptions+=q " Allow formatting of comments with 'gq" (not blank lines or only the comment leader).
set formatoptions+=n " When formatting text, recognize numbered lists (see 'formatlistpat' for list kinds).
set formatoptions+=j " Delete comment character when joining commented lines.

" Visual.
set colorcolumn=80

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 (https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162).
" Based on Vim patch 7.4.1770 (`guicolors` option) (https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd).
" (https://github.com/neovim/neovim/wiki/Following-HEAD#20160511)
if has('termguicolors')
  set termguicolors
endif

" Neovim specific.
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
  let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/opt/python3/bin/python3'
endif

if exists('&inccommand')
  " Show a command's effects incrementally, as you type.
  set inccommand=nosplit
endif


" ========================================================================
" Filetype Settings.                                                     |
" ========================================================================

" sh.
let g:is_bash                         = 1  " Stop error highlight `$'\n'`.
let g:is_posix                        = 1  " Stop error highlighting `$()`.

" PHP.
let g:PHP_vintage_case_default_indent = 1  " Enable indenting `case` statements.
let g:php_folding                     = 0  " Disable syntax folding for classes and functions.
let g:php_htmlInStrings               = 1  " Enable HTML syntax highlighting inside strings.
let g:php_sync_method                 = -1 " Default, but it gives warnings without explicit `let`.


" ========================================================================
" GUI Mode Specific.                                                     |
" ========================================================================

if has('gui_running')
  set guioptions+=c " Use console dialogs instead of popup dialogs for simple choices.
  set guioptions-=m " Disable menu bar.
  set guioptions-=L " Disable left-hand scrollbar when vertical split open.
  set guioptions-=r " Disable right-hand scrollbar.
endif

" Let MacVim control the shift key, for selecting with shift.
if has('gui_macvim')
  set macmeta      " Use option (alt) as meta key.
  let g:macvim_skip_colorscheme   = 1
  let g:macvim_hig_shift_movement = 1

  map <D-w> :bw<CR>
  map <D-n> :enew<CR>
endif


" ========================================================================
" Mappings.                                                              |
" ========================================================================

" New empty buffer in insert mode.
map <C-t> :enew<CR>i
map <Leader>e :enew<CR>i

" Edit `~/.vimrc`.
map <Leader>v :e $MYVIMRC<CR>

" Edit `~/.zshrc`.
map <Leader>z :e ~/.zshrc<CR>

" Insert newline.
map <Leader><Enter> o<Esc>

" Close buffer.
map <Leader>d :lclose<CR>:bwipe!<CR>

" Toggle spell checking.
map <leader>ss :setlocal spell!<CR>

" Toggle search highlighting.
noremap <silent><Esc> :set hlsearch! hlsearch?<CR>

" Correct bad indent while pasting.
" See: http://vim.wikia.com/wiki/Format_pasted_text_automatically
nnoremap p p=`]

" Strip trailing whitespace.
nmap <Leader>sw :%s/\s\+$//e<CR>

" Repeat f, F, T, t commands.
noremap \ ;

" Easier EX mode.
nmap ; :

" Jump between next and previous buffers.
map <Leader>] :lclose<CR>:bprev<CR>
map <Leader>[ :lclose<CR>:bnext<CR>
map <Leader>, :lclose<CR>:bprev<CR>
map <Leader>. :lclose<CR>:bnext<CR>
noremap <C-Tab> :lclose<CR>:bnext<CR>
noremap <C-S-Tab> :lclose<CR>:bprev<CR>

" Omnifunc.
inoremap <C-@> <C-x><C-o>
if has('gui_vimr')
  inoremap <C-Space> <C-x><C-o>
endif

" Code folding options.
nmap <Leader>fl0 :setlocal foldlevel=0<CR>
nmap <Leader>fl1 :setlocal foldlevel=1<CR>
nmap <Leader>fl2 :setlocal foldlevel=2<CR>
nmap <Leader>fl3 :setlocal foldlevel=3<CR>
nmap <Leader>fl4 :setlocal foldlevel=4<CR>
nmap <Leader>fl5 :setlocal foldlevel=5<CR>
nmap <Leader>fl6 :setlocal foldlevel=6<CR>
nmap <Leader>fl7 :setlocal foldlevel=7<CR>
nmap <Leader>fl8 :setlocal foldlevel=8<CR>
nmap <Leader>fl9 :setlocal foldlevel=9<CR>

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

" Disable Ex mode.
nnoremap Q <NOP>

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

" Keep cursor in same spot after a visual yank.
vnoremap <expr>y "my\"" . v:register . "y`y"

if has('nvim')
  " Terminal to Normal mode with <Esc>. Conflicts with fzf.vim.
  " tnoremap <Esc> <C-\><C-n>
endif


" ========================================================================
" Highlighting.                                                          |
" ========================================================================

" Brighten line numbers.
highlight LineNr guifg=#FAFAFA
augroup WhiteLineNumbers
  autocmd!
  autocmd ColorScheme * highlight LineNr guifg=#FAFAFA
augroup END

" No current line number background.
highlight CursorLineNr ctermbg=NONE guibg=NONE

" No sign column without symbol background. Many themes don't implement it.
highlight SignColumn ctermbg=NONE guibg=NONE


" ========================================================================
" Autocommands.                                                          |
" ========================================================================

" Folding.
augroup fold_level
  autocmd!
  " Equivalent to `foldlevelstart` but remember when switching buffers.
  autocmd BufReadPre * setlocal foldlevel=9
  " Disable folding on Git diffs.
  autocmd FileType git setlocal nofoldenable
augroup END

" Writing mode.
augroup writing_mode
  autocmd!
  " wrapmargin
  " linebreak
  " Enable soft wrapping.
  autocmd FileType text,markdown setlocal textwidth=80
  autocmd FileType text,markdown setlocal wrap
  " Wrap long lines at a character in 'breakat'.
  " autocmd FileType text,markdown setlocal linebreak
  " autocmd FileType text,markdown setlocal nolist
  " autocmd FileType text,markdown setlocal formatoptions+=t " Enable wrapping on paste.
augroup END

" Drupal PHP filetypes.
augroup drupal
  autocmd!
  autocmd BufRead,BufNewFile *.info    setlocal filetype=dosini
  autocmd BufRead,BufNewFile *.engine  setlocal filetype=php
  autocmd BufRead,BufNewFile *.inc     setlocal filetype=php
  autocmd BufRead,BufNewFile *.install setlocal filetype=php
  autocmd BufRead,BufNewFile *.module  setlocal filetype=php
  autocmd BufRead,BufNewFile *.profile setlocal filetype=php
  autocmd BufRead,BufNewFile *.test    setlocal filetype=php
  autocmd BufRead,BufNewFile *.theme   setlocal filetype=php
  autocmd BufRead,BufNewFile *.view    setlocal filetype=php
  " autocmd BufRead,BufNewFile *.tpl.php set syntax=php.html
  autocmd BufRead,BufNewFile *.tpl.php setlocal filetype=php.html " Needed?
augroup END

" Prevent stopping on - characters for CSS files.
augroup iskeyword_mods
  autocmd!
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Other filetypes.
augroup special_filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.scss  setlocal filetype=scss.css
  autocmd BufRead,BufNewFile *.plist setlocal filetype=xml
augroup END

" Formatters.
augroup beautifiers
  autocmd!
  " autocmd FileType json setlocal equalprg=python\ -mjson.tool
augroup END

" Custom indent.
augroup indent
  autocmd!
  " autocmd FileType json setlocal noautoindent
  autocmd FileType javascript setlocal noautoindent
augroup END

" Enable omni-completion.
if has_key(g:plugs, 'YouCompleteMe')
  set omnifunc=youcompleteme#OmniComplete
else
  set omnifunc=syntaxcomplete#Complete
endif
augroup omnifuncs
  autocmd!

  " PHP Omnicompletion.
  if has_key(g:plugs, 'phpcd.vim')
    autocmd FileType php,phtml setlocal omnifunc=phpcd#CompletePHP
  elseif has_key(g:plugs, 'phpcomplete.vim')
    autocmd FileType php,phtml setlocal omnifunc=phpcomplete#CompletePHP
  endif

  " Javascript Omnicompletion.
  if has_key(g:plugs, 'tern_for_vim')
    autocmd FileType javascript setlocal omnifunc=tern#Complete
  elseif has_key(g:plugs, 'YouCompleteMe')
    autocmd FileType javascript setlocal omnifunc=youcompleteme#OmniComplete
  elseif has_key(g:plugs, 'vim-eclim') " Must be set to avoid jspc conflict.
    autocmd FileType javascript setlocal omnifunc=eclim#javascript#complete#CodeComplete
  else
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  endif

  " Python Omnicompletion.
  if has_key(g:plugs, 'jedi-vim')
    " Jedi sets this automatically.
    " autocmd FileType python setlocal omnifunc=jedi#completions
  else
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  endif

  " Other Omnicompletion (ignore if Eclim is in use).
  if !has_key(g:plugs, 'vim-eclim')
    autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  endif
augroup END

" Return to last edit position when opening files.
augroup restore_position
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END


" ========================================================================
" Functions.                                                             |
" ========================================================================

" Change to random colorscheme from a defined list of awesome ones.
function! NextColorScheme()
  let colorschemes = [
    \'OceanicNext',
    \'Tomorrow-Night',
    \'apprentice',
    \'badwolf',
    \'bluechia',
    \'bubblegum',
    \'candyman',
    \'codeschool',
    \'distinguished',
    \'flattr',
    \'grb256',
    \'gruvbox',
    \'hybrid',
    \'ir_black',
    \'jellybeans',
    \'molokai',
    \'monokai',
    \'monokain',
    \]
  try
    let colorscheme_index = index(colorschemes, g:colors_name) + 1
    echo 'colorscheme_index1: ' . colorscheme_index
  catch /^Vim:E121/
    let colorscheme_index = 0
    echo 'colorscheme_index2: ' . colorscheme_index
  endtry
  if colorscheme_index > len(colorschemes)
    echo 'if colorscheme_index >= len(colorschemes)'
    let colorscheme_index = 0
  endif
  let new_colorscheme = colorschemes[colorscheme_index]
  execute ':colorscheme ' . new_colorscheme
endfunction

" Change to random font from a defined list of awesome ones.
function! NextFont()
  let guifonts = [
    \'Consolas:h15.5',
    \'Droid\ Sans\ Mono\ for\ Powerline:h15',
    \'Fira\ Code\ Retina:h15',
    \'Hack:h15',
    \'Inconsolata-dz\ for\ Powerline:h15',
    \'Input\ Mono:h15',
    \'Menlo\ for\ Powerline:h15.5',
    \'Meslo\ LG\ M\ DZ\ for\ Powerline:h15',
    \'Monaco\ for\ Powerline:h15',
    \'Mononoki:h16',
    \'Office\ Code\ Pro\ D:h15',
    \'PT\ Mono\ for\ Powerline:h16',
    \'Source\ Code\ Pro\ for\ Powerline:h15',
    \'Ubuntu\ Mono\ derivative\ Powerline:h17',
  \]
  let guifont_index = index(guifonts, &guifont) + 1
  let new_guifont = guifonts[guifont_index]
  execute ':set guifont=' . new_guifont
  echo new_guifont
endfunction

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


" ========================================================================
" Commands.                                                              |
" ========================================================================

command! -bar NextFont call NextFont()
command! -bar NextColorScheme call NextColorScheme()
command! -bar FormatJSON :%!python -m json.tool


" ========================================================================
" Plugin Settings.                                                       |
" ========================================================================

" delimitMate.
let g:delimitMate_expand_cr            = 1
let g:delimitMate_expand_space         = 1
let g:delimitMate_expand_inside_quotes = 1
let g:delimitMate_jump_expansion       = 1

" Deoplete.
let g:deoplete#enable_at_startup              = has_key(g:plugs, 'deoplete.nvim')
let g:deoplete#enable_camel_case              = 1 " Smart-case for fuzzy matching.
let g:deoplete#delimiters                     = ['/', '.', '::', ':', '#', '->'] " Added '->'.
let g:deoplete#sources                        = get(g:, 'deoplete#sources', {})
let g:deoplete#sources._                      = ['omni', 'buffer', 'member', 'tag', 'ultisnips', 'file', 'dictionary']
" let g:deoplete#sources.javascript           = ['ternjs'] + g:deoplete#sources._
let g:deoplete#sources.javascript             = ['ternjs', 'ultisnips', 'file']
let g:deoplete#keyword_patterns               = get(g:, 'deoplete#keyword_patterns', {})
let g:deoplete#keyword_patterns.default       = '[a-zA-Z_]\w?'
let g:deoplete#omni#functions                 = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#functions.javascript      = ['jspc#omni', 'tern#Complete']
" Deoplete-compatible (asynchronous) completion.
let g:deoplete#omni#input_patterns            = get(g:, 'deoplete#omni#_input_patterns', {})
" let g:deoplete#omni#input_patterns.javascript = '\h\w*\|{3,}'
let g:deoplete#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'
let g:deoplete#omni#input_patterns.python     = '\h\w*'
" Regular (synchronous) omnifuncs.
let g:deoplete#omni_patterns                  = get(g:, 'deoplete#_omni_patterns', {})
let g:deoplete#omni_patterns.css              = ['{3,}', '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]']
let g:deoplete#omni_patterns.html             = '<[^>]*'
" let g:deoplete#omni_patterns.php              = '\h\w'
" let g:deoplete#omni_patterns.php              = '\h\w\{5,}'
" let g:deoplete#omni_patterns.php              = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
" let g:deoplete#omni_patterns.python           = ['[^. *\t]\.\h\w*\','\h\w*::']
" let g:deoplete#omni_patterns.python3          = ['[^. *\t]\.\h\w*\','\h\w*::']
let g:deoplete#omni_patterns.ruby             = ['[^. *\t]\.\w*', '\h\w*::']
let g:deoplete#omni_patterns.sass             = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni_patterns.scss             = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni_patterns.xml              = '<[^>]*'
let g:deoplete#sources#jedi#show_docstring    = 1

" Eclim.
let g:EclimCompletionMethod = 'omnifunc'

" elzr/vim-json.
let g:vim_json_syntax_conceal = 0 " Show quotes in JSON files.

" vim-jsdoc.
let g:jsdoc_allow_input_prompt = 1 " Allow prompt for interactive input.
let g:jsdoc_input_description  = 1 " Prompt for a function description.
let g:jsdoc_underscore_private = 1 " Detect private functions starting with an underscore.
let g:jsdoc_enable_es6         = 1 " Enable ECMAScript6 shorthand function, arrow function.

" GitGutter.
let g:gitgutter_max_signs               = 1000 " Bump up from default 500.
let g:gitgutter_sign_added              = '┃+'
let g:gitgutter_sign_modified           = '┃…'
let g:gitgutter_sign_modified_removed   = '┃±'
let g:gitgutter_sign_removed            = '┃−'
let g:gitgutter_sign_removed_first_line = '┃⇈'
" let g:gitgutter_override_sign_column_highlight = 0
" highlight GitGutterAdd          ctermbg=NONE guibg=NONE
" highlight GitGutterChange       ctermbg=NONE guibg=NONE
" highlight GitGutterDelete       ctermbg=NONE guibg=NONE
" highlight GitGutterChangeDelete ctermbg=NONE guibg=NONE
highlight clear SignColumn

let g:grepper = {
\ 'tools': ['ag', 'ack', 'git', 'grep'],
\ 'open':  0,
\ 'jump':  1,
\ }
command! -nargs=* -complete=file GG Grepper -tool git -query <args>
command! -nargs=* AG Grepper -noprompt -tool ag -grepprg ag --vimgrep <args>

" Gutentags.
let g:gutentags_ctags_executable = '/usr/local/bin/ctags'
if has_key(g:plugs, 'vim-gutentags')
  set statusline+=%{gutentags#statusline()}
endif

" indentLine.
let g:indentLine_char            = '│'
let g:indentLine_fileTypeExclude = ['help', 'startify']
let g:indentLine_faster          = 1

" Jedi.
let g:jedi#auto_vim_configuration   = 0  " Don't set `completeopt` options and insert mode <C-c> key mapping.
let g:jedi#documentation_command    = '' " Disable the show documentation mapping.
let g:jedi#goto_assignments_command = '' " Disable the goto assignment mapping.
let g:jedi#goto_command             = '' " Disable the goto definition mapping.
let g:jedi#goto_definitions_command = '' " Disable the goto definitions mapping.
let g:jedi#rename_command           = '' " Disable the rename mapping.
let g:jedi#usages_command           = '' " Disable the usage mapping.
let g:jedi#completions_command      = '' " Disable the completion mapping.

" UltiSnips.
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" PHP Documentor.
let g:pdv_template_dir = g:plug_home . '/pdv/templates'

" startify.
let g:startify_change_to_dir          = 1 " Change to selected file or bookmark's directory.
let g:startify_enable_special         = 0 " Don't show <empty buffer> and <quit>.
let g:startify_relative_path          = 1 " Show relative filenames (directories by default).
let g:startify_session_autoload       = 1 " Auto load `Session.vim` if present when opening Vim.
let g:startify_session_delete_buffers = 1 " Delete open buffers before loading a new session.
let g:startify_session_persistence    = 1 " Update session before closing Vim and loading session with `:SLoad`.
if executable('fortune') && executable('cowsay')
  let g:startify_custom_header = startify#fortune#cowsay()
endif

" vim-instant-markdown.
let g:instant_markdown_autostart = 0

" Tagbar.
let g:tagbar_type_php = {
\   'kinds' : [
\     'c:Classes:0',
\     'd:Constants:0:0',
\     'f:Functions:1',
\     'i:Interfaces:0',
\     'n:Namespaces:0',
\     't:Traits:0',
\     'v:Variables:0:0',
\   ],
\   'sro' : '::',
\   'kind2scope' : {
\     'c': 'class',
\     'd': 'constant',
\     'f': 'function',
\     'i': 'interface',
\     'n': 'namespace',
\     't': 'trait',
\     'v': 'variable',
\   },
\   'scope2kind' : {
\     'class'    : 'c',
\     'constant' : 'd',
\     'function' : 'f',
\     'interface': 'i',
\     'namespace': 'n',
\     'trait'    : 't',
\     'variable' : 'v',
\   }
\ }
let g:tagbar_type_css = {
\   'ctagstype' : 'css',
\   'kinds' : [
\     'f:functions',
\     'm:mixins',
\     'm:medias',
\     'v:variables',
\     'c:classes',
\     'i:IDs',
\     't:tags',
\   ]
\ }
let g:tagbar_type_less = g:tagbar_type_css
let g:tagbar_type_scss = g:tagbar_type_css

" Airline
let g:airline_theme = 'badwolf'
" let g:airline_theme = 'luna'
" let g:airline_theme = 'bubblegum'
" let g:airline_theme = 'wombat'
let g:airline_symbols = extend(get(g:, 'airline_symbols', {}), {
\   'paste': 'ρ',
\   'whitespace': 'Ξ',
\   'spell': 'Ꞩ',
\   'notexists': 'ø',
\   'modified': '±',
\   'linenr': '¶',
\ })
let g:airline_powerline_fonts               = 1
let g:airline#extensions#syntastic#enabled  = exists(':SyntasticCheck')
let g:airline#extensions#branch#enabled     = 0
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#capslock#enabled   = 1
let g:airline#extensions#hunks#enabled      = 1
let g:airline#extensions#tabline#enabled    = 1
let g:airline#extensions#tabline#fnamemod   = ':t' " Only show filename.
let g:airline#extensions#undotree#enabled   = 1
let g:airline#extensions#whitespace#enabled = 0 " Makes scrolling super slow sometimes.

" Neomake.
let g:neomake_open_list                 = 2
let g:neomake_serialize                 = 1
let g:neomake_css_enabled_makers        = ['csslint']
let g:neomake_json_enabled_makers       = ['jsonlint']
let g:neomake_php_enabled_makers        = ['php', 'phpcs']
let g:neomake_php_phpcs_args_standard   = 'Drupal'
" let g:neomake_javascript_enabled_makers = ['eslint', 'jshint']
" let g:neomake_python_enabled_makers     = ['python', 'pylint', 'pep8']
" let g:neomake_scss_enabled_makers       = ['scss-lint']
" let g:neomake_sh_enabled_makers         = ['sh', 'shellcheck']
" let g:neomake_sh_shellcheck_args      = ['--exclude=sc2155,sc2032,sc1090,sc2033']
let g:neomake_text_enabled_makers       = ['proselint']
" Symbols: ⚠️, ❌, 🚫,  😡, 😠, ⨉, ⚠
let g:neomake_warning_sign              = { 'text': '⚠️'  }
let g:neomake_error_sign                = { 'text': '❌' }

" Syntastic
" let g:syntastic_filetype_map = { 'phtml': 'php' }
" let g:syntastic_filetype_map = { 'dosini': 'php' }
let g:syntastic_mode_map                 = { 'mode': 'passive' } " Disable active mode by default.
" let g:syntastic_error_symbol             = '😭'
" let g:syntastic_style_error_symbol       = '😭'
" let g:syntastic_warning_symbol           = '😢'
" let g:syntastic_style_warning_symbol     = '😢'
let g:syntastic_aggregate_errors         = 1 " run all linters, even if first found errors.
let g:syntastic_always_populate_loc_list = 1 " Add errors to location-list.
let g:syntastic_auto_loc_list            = 1 " Automatically open/close location-list if errors are found.
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 1
let g:syntastic_css_checkers             = ['csslint', 'php/phpcs']
let g:syntastic_javascript_checkers      = ['jshint', 'php/phpcs', 'eslint', 'jscs', 'flow']
let g:syntastic_html_checkers            = [] " Disable HTML checkers.
let g:syntastic_sh_checkers              = ['sh', 'shellcheck']
let g:syntastic_sh_shellcheck_args       = '--exclude=SC2155,SC2032,SC1090,SC2033' " Ignore declare and assign on same line.
let g:syntastic_php_checkers             = ['php', 'phpcs']
let g:syntastic_python_checkers          = ['pylint', 'pep8', 'python']
let g:syntastic_scss_checkers            = ['scss_lint']
let g:syntastic_text_checkers            = ['proselint']
let g:syntastic_vim_checkers             = ['vint']
let g:syntastic_json_checkers            = ['jsonlint']
let g:syntastic_stl_format               = '[%E{E: %fe #%e}%B{, }%W{W: %fw #%w}]'

" PHPCD.
let g:phpcd_php_cli_executable = '/usr/local/bin/php'

" deoplete-ternjs.
let g:tern_request_timeout                = 1
let g:tern_show_signature_in_pum          = 1         " Show function signatures in the completion menu.
let g:tern_show_argument_hints            = 'on_move' " When to update argument hints. Default is 0.
let g:tern#is_show_argument_hints_enabled = 1
if has_key(g:plugs, 'tern_for_vim')
  let g:tern#command   = ['tern'] " Use the same tern command.
  let g:tern#arguments = ['--persistent']
endif

" YouCompleteMe.
let g:ycm_add_preview_to_completeopt                = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion  = 1
let g:ycm_collect_identifiers_from_tags_files       = 1
let g:ycm_complete_in_comments                      = 1
let g:ycm_complete_in_strings                       = 1
let g:ycm_min_num_of_chars_for_completion           = 3
let g:ycm_seed_identifiers_with_syntax              = 1
" Default values, not being set by YCM. Crashes Neovim when too aggressive.
let g:ycm_semantic_triggers = get(g:, 'g:ycm_semantic_triggers', {
\   'html':       ['re!\w{3,}'],
\   'scss':       [' ', 're!\w{2,}', 're!:\s+'],
\   'css':        [' ', 're!\w{2,}'],
\   'javascript': ['.'],
\   'php':        ['->', '::'],
\   'python':     ['.'],
\   'ruby':       ['.', '::'],
\ })

" pangloss/vim-javascript.
let g:javascript_enable_domhtmlcss = 1

" vim-polyglot.
let g:polyglot_disabled = ['css', 'html5', 'javascript', 'json', 'jsx', 'php']

" Vdebug.
" See: https://xdebug.org/docs-dbgp.php#feature-names
let g:vdebug_options               = get(g:, 'vdebug_options', {})
let g:vdebug_options.break_on_open = 0   " Don't stop on the first line of the script.
let g:vdebug_options.timeout       = 120 " Seconds to wait for when listening for a connection (default 20).
let g:vdebug_features = {
\   'max_depth': 2048,
\   'max_children': 1024
\ }

" vim-javascript.
let g:javascript_plugin_jsdoc = 1 " Enable syntax highlighting for JSDoc.

" vim-localvimrc.
let g:localvimrc_name = '.vimrc.local'
let g:localvimrc_ask  = 0


" ========================================================================
" Theme Settings.                                                        |
" ========================================================================

" Gruvbox.
let g:gruvbox_contrast_dark = 'hard'


" ========================================================================
" Plugin Mappings.                                                       |
" ========================================================================

" Deoplete.
if has_key(g:plugs, 'deoplete.nvim')
  " <TAB> completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " Close the menu on <Backspace>.
  " inoremap <expr><BS>
  "   \ deoplete#mappings#smart_close_popup() . '\<C-h>'
endif

" Execute the buffer contents.
nmap <Leader>r :RunCode<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)

" Fugitive.
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gh :Gbrowse<CR>
nmap <Leader>gs :Gstatus<CR>

" FZF or Skim.
if (executable('fzf') && has_key(g:plugs, 'fzf.vim')) || (executable('sk') && has_key(g:plugs, 'skim.vim'))
  nnoremap <C-f> :Files<CR>
  nnoremap <Leader>f :Files<CR>
  nnoremap <C-g> :GFiles<CR>
  nnoremap <Leader>g :GFiles<CR>
  nnoremap <Leader>c :Colors<CR>
  nnoremap <Leader>h :History<CR>
endif

" Incsearch.
let g:incsearch#auto_nohlsearch = 1
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)

" indentLine.
map <Leader>il <silent> :IndentLinesToggle<CR>

" Ag.
nnoremap <Leader>a :Ag<Space>

" Tagbar.
nnoremap <Leader>tt :TagbarToggle<CR>

" GitGutter.
noremap <Leader>gg :GitGutterToggle<CR>

" Linting.
if has_key(g:plugs, 'neomake')
  nnoremap <Leader>l :Neomake<CR>
  nnoremap <Leader>ni :NeomakeInfo<CR>
elseif exists(':SyntasticCheck')
  nnoremap <Leader>l :SyntasticCheck<CR>
  nnoremap <Leader>lt :SyntasticToggle<CR>
  nnoremap <Leader>si :SyntasticInfo<CR>
endif


" ========================================================================
" Plugin Autocommands.                                                   |
" ========================================================================

" AutoClose. Disable for VimL files.
autocmd FileType vim let b:AutoCloseOn = 0

" Fugitive.
autocmd BufRead fugitive://* setlocal norelativenumber

" Pencil.
augroup pencil
  autocmd!
  autocmd FileType markdown,text :PencilSoft " Enable soft-wrapping.
augroup END

" Lint when saving files.
" if has_key(g:plugs, 'neomake')
"   augroup neomake
"     autocmd BufWritePost,BufEnter * Neomake
"     autocmd InsertChange,TextChanged * update | Neomake
"   augroup END
" endif

" autocmd BufWritePost,BufEnter * Neomake
" autocmd InsertChange,TextChanged * update | Neomake

" Open Tagbar by default for some filetypes.
" autocmd FileType php,javascript,python,vim nested :TagbarOpen

" startify. Disable folding on the start screen.
autocmd FileType startify setlocal nofoldenable

" Strip whitespace on save.
autocmd BufWritePre * StripWhitespace

" vim-commentary.
autocmd FileType php setlocal commentstring=//\ %s
autocmd FileType css.scss setlocal commentstring=//\ %s


" ========================================================================
" Import local vimrc `~/.vimrc.local`.                                   |
" ========================================================================

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
