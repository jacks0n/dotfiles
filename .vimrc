set nocompatible " Enable Vim-specific features, disable Vi compatibility.
filetype off

let $NVIM_PYTHON_LOG_FILE = $HOME . '/Desktop/nvim-python.log'

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Create the backup directory, if it doesn't already exist.
if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p')
endif

" Install vim-plug if it's not already.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')


" ========================================================================
" Plug: Un-Organised.                                                    |
" ========================================================================

" Options:
"  'Townk/vim-autoclose'  - Works well. Gets stuck in insert mode with YouCompleteMe. Unmaintained.
"  'cohama/lexima.vim'    - Works well, inserts closing character, not that intelligent.
"  'jiangmiao/auto-pairs' - Seems the most intelligent, can get slow.
"  'chr4/nginx.vim'       - Nginx config syntax highlighting, in vim-polyglot.
" Plug 'cohama/lexima.vim'
" Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'              " Add close (X)HTML tags on creation.
"   \ { 'for': ['html', 'php', 'xhtml', 'xml', 'jinja'] }
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'jreybert/vimagit'
Plug 'rakr/vim-one'
" Plug 'embear/vim-localvimrc'


" ========================================================================
" Plug: Utility.                                                         |
" ========================================================================

Plug 'Mizuchi/vim-ranger'
Plug 'DataWraith/auto_mkdir'
Plug 'tpope/vim-db'
Plug 'tpope/vim-commentary'


" ========================================================================
" Plug: Completion.                                                      |
" ========================================================================

if has('nvim')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
elseif v:version >= 704 && has('patch1578')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
endif

" AI pair programmer which suggests line completions and entire function bodies as you type.
Plug 'github/copilot.vim'


" ========================================================================
" Plug: Search.                                                          |
" ========================================================================

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  \| Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
Plug 'benwainwright/fzf-project'
" Plug 'rking/ag.vim'
" Plug 'nvim-telescope/telescope.nvim'
"     \| Plug 'nvim-lua/plenary.nvim'
Plug 'romainl/vim-cool' " Disables search highlighting when you are done searching and re-enables it when you search again.


" ========================================================================
" Plug: Visual.                                                          |
" ========================================================================

Plug 'airblade/vim-gitgutter'         " Git gutter column diff signs.
Plug 'henrik/vim-indexed-search'      " Show 'At match #N out of M matches.' when searching.
Plug 'haya14busa/incsearch.vim'       " Incremental highlight all search results.
Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and helper function.
Plug 'Yggdroot/indentLine'            " Adds vertical and/or horizontal alignment lines.
Plug 'matze/vim-move'                 " Move lines and selections up and down.
Plug 'jaxbot/semantic-highlight.vim'  " Where every variable is a different color.
Plug 'vim-airline/vim-airline'
  \| Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify' " Fancy start screen.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" ========================================================================
" Plug: CSS, SASS.                                                       |
" ========================================================================

" ----------------------------------------
" Syntax.                                |
" ----------------------------------------

" Options:
"  'JulesWang/css.vim'         - Cutting-edge CSS syntax file. In vim-polyglot.
"  'hail2u/vim-css3-syntax'    - Adds CSS 3 properties, except for @media.
"  'cakebaker/scss-syntax.vim' - SCSS syntax.
Plug 'hail2u/vim-css3-syntax',    { 'for': ['css', 'scss', 'sass'] } " CSS3 syntax.
Plug 'cakebaker/scss-syntax.vim', { 'for': ['css', 'scss'] }         " SCSS syntax.

" ----------------------------------------
" Features.                              |
" ----------------------------------------

" Options:
"   'neoclide/coc-highlight' - Highlights CSS/SCSS colours. Has high CPU issues.
"                              @see https://github.com/neoclide/coc-highlight/issues/14
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass'] }

" ----------------------------------------
" Omnicompletion.                        |
" ----------------------------------------

Plug 'othree/csscomplete.vim', { 'for': ['css', 'scss', 'sass'] }


" ========================================================================
" Language: CSV.                                                         |
" ========================================================================

" Plug 'chrisbra/csv.vim', { 'for': 'csv' }

" ========================================================================
" Language: Python.                                                      |
" ========================================================================

Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for': ['python'] }


" ========================================================================
" Language: HTML, XML.                                                   |
" ========================================================================

" Plug 'Valloric/MatchTagAlways',        " Highlight outer cursor (X)HTML tags.
"   \ { 'for': ['html', 'phtml', 'xhtml', 'xml', 'jinja'] }
Plug 'mattn/emmet-vim',                " Emmet for Vim.
  \ { 'for': ['html', 'phtml', 'xhtml', 'xml', 'jinja'] }

" Options:
"  'tylerbrazier/HTML-AutoCloseTag' - Unmaintained, extra <Esc> back to normal mode.
"  'othree/html5'                   - Included in vim-polyglot.
Plug 'docunext/closetag.vim' " Intelligently auto-close (X)HTML tags.
  \ { 'for': ['html', 'php', 'xhtml', 'xml', 'jinja'] }


" ========================================================================
" Language: JavaScript, JSON, Typescript.                                |
" ========================================================================

" ----------------------------------------
" Syntax and Indent.                     |
" ----------------------------------------

Plug 'elzr/vim-json', { 'for': ['javascript', 'json'] }

" Options:
"  'jiangmiao/simple-javascript-indenter' - Unmaintained.
"  'gavocanov/vim-js-indent'              - Indent part of pangloss/vim-javascript. Unmaintained.
"  'jason0x43/vim-js-indent'              - Indent for JavaScript and Typescript. Unmaintained.
"  'jelera/vim-javascript-syntax'         - Syntax, unmaintained.
"  'othree/yajs.vim'                      - Syntax, unmaintained, fork of Jelera. Recognises
"                                         - web API and DOM keywords, supports ES6 syntax.
"  'othree/jsdoc-syntax.vim'              - JSDoc syntax. Unmaintained.
"                                           Pangloss supports JSdoc anyway.
"  'pangloss/vim-javascript'              - Syntax and improved indentation. Included in vim-polyglot.
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax

" ----------------------------------------
" Syntax Addons.                         |
" ----------------------------------------

" Plug 'othree/javascript-libraries-syntax.vim', " Extends syntax for jQuery, Underscore, Backbone, etc.
"   \ { 'for': 'javascript' }
" Plug 'mxw/vim-jsx', { 'for': 'jsx' }           " After syntax, ftplugin, indent for JSX.
" Plug 'bigfish/vim-js-context-coloring'         " Highlight based on context.

" ----------------------------------------
" Completion.                            |
" ----------------------------------------

Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' } " Adds more recent browser API support.
Plug 'othree/jspc.vim', { 'for': 'javascript' }                            " Parameter completion.

" ----------------------------------------
" Features.                              |
" ----------------------------------------

Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' } " Generate function JSDoc docblocks with `:JsDoc`.


" ========================================================================
" Plug: Markdown.                                                        |
" ========================================================================

Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }


" ========================================================================
" Plug: PHP.                                                             |
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
"  'phpvim/phpcd.vim'            - Server based, NeoVim only, composer projects only.
"                                  Jump to use statement definition doesn't work.
"  'shawncplus/phpcomplete.vim'  - Slow as fuck, included in $VIMRUNTIME.

" Plug 'phpactor/phpactor', { 'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o' }
" Plug 'shawncplus/phpcomplete.vim',  { 'for': 'php' }

" ----------------------------------------
" Features.                              |
" ----------------------------------------

" TODO: Checkout.
" Plug 'Rican7/php-doc-modded'
" TODO: Checkout.
" Plug 'docteurklein/vim-symfony'
Plug 'tobyS/pdv' " , { 'for': 'php' }
Plug 'adoy/vim-php-refactoring-toolbox', { 'for': 'php' }
Plug 'noahfrederick/vim-composer'
  \| Plug 'tpope/vim-dispatch'


" ========================================================================
" Plug: Text.                                                            |
" ========================================================================

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'


" ========================================================================
" Plug: Twig.                                                            |
" ========================================================================

Plug 'nelsyeung/twig.vim'


" ========================================================================
" Plug: VimL.                                                            |
" ========================================================================

" VimL completion.
Plug 'Shougo/neco-vim', { 'for': 'vim' }


" ========================================================================
" Plug: Themes.                                                          |
" ========================================================================

Plug 'flazz/vim-colorschemes' " All single-file vim.org colour schemes.
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'alessandroyorba/despacio'


" ========================================================================
" Plug: Text Editing.                                                    |
" ========================================================================

Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'tpope/vim-surround'


" ========================================================================
" Plug: Sidebars.                                                        |
" ========================================================================

Plug 'Xuyuanp/nerdtree-git-plugin' " NERDTree Git integration.
Plug 'scrooloose/nerdtree'         " File browser.
Plug 'majutsushi/tagbar'           " Sidebar for tags.
Plug 'hari-rangarajan/CCTree'      " Symbol dependency tree.
Plug 'sjl/gundo.vim'               " Undo history.


" ========================================================================
" Plug: SQL.                                                             |
" ========================================================================

" Plug 'joereynolds/SQHell.vim'


" ========================================================================
" Plug: Linting.                                                         |
" ========================================================================

Plug 'neomake/neomake'

" ========================================================================
" Plug: Functional.                                                      |
" ========================================================================

Plug '0x84/vim-coderunner'           " Run the buffer on the fly.
Plug 'chrisbra/Recover.vim'          " Show a diff whenever recovering a buffer.
Plug 'editorconfig/editorconfig-vim' " Some default configs.
let g:polyglot_disabled = ['json', 'jsx', 'php', 'twig', 'startify']
Plug 'sheerun/vim-polyglot'          " Language pack collection (syntax, indent, ftplugin, ftdetect).
Plug 'tpope/vim-eunuch'              " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'tpope/vim-repeat'              " Enable repeating supported plugin maps with '.'.
Plug 'vim-utils/vim-troll-stopper'   " Highlight Unicode trolls/homoglyph.
" Plug 'wincent/terminus'              " Terminal improvements. Cursor shape change, improved mouse support, fix autoread, auto paste.
Plug 'joonty/vdebug'                 " DBGP protocol debugger  (e.g. Xdebug).
Plug 'rhysd/committia.vim'           " Better `git commit` interface, with status and diff window.
" Plug 'ludovicchabant/vim-gutentags'  " Automatic tag generation and updating.

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
set updatetime=300            " Milliseconds to wait after typing to save the swap file.

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
" set spell                    " Enable spell checking.
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
" set completeopt=menu,menuone,longest,noselect
" set completeopt=menu,menuone,longest,noselect,noinsert

" This will show the popup menu even if there's only one match (menuone),
" prevent automatic selection (noselect) and prevent automatic text injection
" into the current line (noinsert).
set completeopt=noinsert,menuone,noselect
" set completeopt+=preview

" More detailed and accurate insert mode completion.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " Completion ignore patterns.
set wildignore+=*.min.css,*.min.js        " Completion ignore patterns.

set smarttab                    " Emulate tab behaviour with spaces.
set expandtab                   " Tabs are spaces.
set shiftwidth=2                " Spaces per tab.
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
  " colorscheme molokai
  " colorscheme flattr
  colorscheme hybrid
  " colorscheme OceanicNext
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
set formatoptions+=n " When formatting text, recognise numbered lists (see 'formatlistpat' for list kinds).
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
  let g:python3_host_prog = '/usr/local/bin/python3'
  let g:python_host_prog = '/usr/local/bin/python'
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
let php_sql_query = 1 " Enable SQL syntax highlighting inside strings.
" StanAngeloff/php.
let php_html_in_strings = 1 " Enable HTML syntax highlighting inside strings.


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

" Strip trailing whitespace.
nmap <Leader>sw :%s/\s\+$//e<CR>

" Repeat f, F, T, t commands.
noremap \ ;

" Easier EX mode.
nmap ; :

" Jump between next and previous buffers.
map <Leader>, :lclose<CR>:silent bprev<CR>
map <Leader>. :lclose<CR>:silent bnext<CR>
noremap <C-Tab> :lclose<CR>:silent bnext<CR>
noremap <C-S-Tab> :lclose<CR>:silent bprev<CR>

" Omnifunc.
inoremap <C-@> <C-x><C-o>
if has('gui_vimr')
  inoremap <C-Space> <C-x><C-o>
endif

" Code formatting.
nmap <Leader>fj :FormatJSON<CR>

" Code folding options.
nmap <Leader>fl- :setlocal nofoldenable<CR>
nmap <Leader>fl+ :setlocal foldenable<CR>
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
  " autocmd FileType text,markdown setlocal textwidth=80
  " autocmd FileType text,markdown setlocal wrap
  " Wrap long lines at a character in 'breakat'.
  " autocmd FileType text,markdown setlocal linebreak
  " autocmd FileType text,markdown setlocal nolist
  " autocmd FileType text,markdown setlocal formatoptions+=t " Enable wrapping on paste.
augroup END

" Custom filetypes.
augroup custom_filetypes
  autocmd!

  " Drupal.
  autocmd BufRead,BufNewFile *.info    setlocal filetype=yaml
  autocmd BufRead,BufNewFile *.engine  setlocal filetype=php
  autocmd BufRead,BufNewFile *.inc     setlocal filetype=php
  autocmd BufRead,BufNewFile *.install setlocal filetype=php
  autocmd BufRead,BufNewFile *.module  setlocal filetype=php
  autocmd BufRead,BufNewFile *.profile setlocal filetype=php
  autocmd BufRead,BufNewFile *.test    setlocal filetype=php
  autocmd BufRead,BufNewFile *.theme   setlocal filetype=php
  autocmd BufRead,BufNewFile *.view    setlocal filetype=php
  autocmd BufRead,BufNewFile *.tpl.php setlocal filetype=php.html " Needed?

  " Other.
  autocmd BufRead,BufNewFile *.plist     setlocal filetype=xml
  autocmd BufRead,BufNewFile *.scss      setlocal filetype=scss.css
  autocmd BufRead,BufNewFile *.yml.dist  setlocal filetype=yaml
  autocmd BufRead,BufNewFile Jenkinsfile setlocal filetype=groovy
  autocmd bufnewfile,bufread *.jsx       setlocal filetype=javascript.jsx
augroup END

" Override vim-coderunner.
augroup dockerfile_build
  autocmd!

  autocmd BufRead,BufNewFile Dockerfile nnoremap <Leader>r :!docker build .<CR>

augroup END

" Prevent stopping on - characters for CSS files.
augroup iskeyword_mods
  autocmd!
  autocmd FileType css,scss,sass setlocal iskeyword+=-
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
set omnifunc=syntaxcomplete#Complete
augroup omnifuncs
  autocmd!

  " PHP Omnicompletion.
  if has_key(g:plugs, 'phpactor')
    autocmd FileType php,phtml setlocal omnifunc=phpactor#Complete
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
    \ 'OceanicNext',
    \ 'Tomorrow-Night',
    \ 'apprentice',
    \ 'badwolf',
    \ 'bluechia',
    \ 'bubblegum',
    \ 'candyman',
    \ 'codeschool',
    \ 'distinguished',
    \ 'flattr',
    \ 'grb256',
    \ 'gruvbox',
    \ 'hybrid',
    \ 'ir_black',
    \ 'jellybeans',
    \ 'molokai',
    \ 'monokai',
    \ 'monokain',
  \ ]
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

function! Update()
  PlugUpdate
  PlugUpgrade
  CocUpdate
endfunction

" Change to random font from a defined list of awesome ones.
function! NextFont()
  let guifonts = [
    \ 'Consolas:h15.5',
    \ 'Droid\ Sans\ Mono\ for\ Powerline:h15',
    \ 'Fira\ Code\ Retina:h15',
    \ 'Hack:h15',
    \ 'Inconsolata-dz\ for\ Powerline:h15',
    \ 'Input\ Mono:h15',
    \ 'Menlo\ for\ Powerline:h15.5',
    \ 'Meslo\ LG\ M\ DZ\ for\ Powerline:h15',
    \ 'Monaco\ for\ Powerline:h15',
    \ 'Mononoki:h16',
    \ 'Office\ Code\ Pro\ D:h15',
    \ 'PT\ Mono\ for\ Powerline:h16',
    \ 'Source\ Code\ Pro\ for\ Powerline:h15',
    \ 'Ubuntu\ Mono\ derivative\ Powerline:h17',
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

" Custom commands.
command! -bar NextColorScheme call NextColorScheme()
command! -bar NextFont call NextFont()
command! -bar FormatJSON :%!python3 -m json.tool

" Plugin commands.
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


" ========================================================================
" Plugin Settings.                                                       |
" ========================================================================

" FZF.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" if execute('bat')
"   let g:fzf_preview_command = 'bat --color=always --style=grid --theme=ansi-dark {-1}'
" endif

" elzr/vim-json.
let g:vim_json_syntax_conceal = 0 " Show quotes in JSON files.

" plasticboy/vim-markdown.
let g:vim_markdown_conceal = 0             " Disable setting conceallevel for text.
let g:vim_markdown_conceal_code_blocks = 0 " Disable setting conceallevel for code blocks.

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
highlight clear SignColumn

" Gutentags.
let g:gutentags_ctags_executable = '/usr/local/bin/ctags'
let g:gutentags_project_root     = ['index.php', '.git', '.hg', '.bzr', '_darcs']
if has_key(g:plugs, 'vim-gutentags')
  set statusline+=%{gutentags#statusline()}
endif

" indentLine.
let g:indentLine_char            = '│'
let g:indentLine_fileTypeExclude = ['help', 'startify']
let g:indentLine_faster          = 1

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
  let g:startify_custom_header       = startify#fortune#cowsay()
  let g:startify_fortune_use_unicode = 1
endif

" coc.nvim.
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-dictionary',
  \ 'coc-docker',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-markdownlint',
  \ 'coc-omni',
  \ 'coc-phpactor',
  \ 'coc-phpls',
  \ 'coc-pyright',
  \ 'coc-sh',
  \ 'coc-syntax',
  \ 'coc-tabnine',
  \ 'coc-tag',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-word',
  \ 'coc-yaml',
  \ ]

" vim-instant-markdown.
let g:instant_markdown_autostart = 0

" vim-php-refactoring-toolbox.
let g:vim_php_refactoring_use_default_mapping = 0
let g:vim_php_refactoring_make_setter_fluent  = 1

" tobyS/pdv.
let g:pdv_template_dir = $HOME . '/.vim/bundle/pdv/templates_snip'

" Tagbar.
let g:tagbar_type_php = {
\ 'kinds': [
\    'c:Classes:0',
\     'd:Constants:0:0',
\     'f:Functions:1',
\     'i:Interfaces:0',
\     'n:Namespaces:0',
\     't:Traits:0',
\     'v:Variables:0:0',
\   ],
\   'sro': '::',
\   'kind2scope': {
\     'c': 'class',
\     'd': 'constant',
\     'f': 'function',
\     'i': 'interface',
\     'n': 'namespace',
\     't': 'trait',
\     'v': 'variable',
\   },
\   'scope2kind': {
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
\   'ctagstype': 'css',
\   'kinds': [
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

" Lightline.

" Airline.
let g:airline_theme = 'badwolf'
" let g:airline_theme = 'luna'
" let g:airline_theme = 'bubblegum'
" let g:airline_theme = 'wombat'
" let g:airline_theme = 'onehalfdark'
let g:airline_symbols = extend(get(g:, 'airline_symbols', {}), {
\   'paste': 'ρ',
\   'whitespace': 'Ξ',
\   'spell': 'Ꞩ',
\   'notexists': 'ø',
\   'modified': '±',
\   'linenr': '¶',
\ })
let g:airline_powerline_fonts               = 1
let g:airline#extensions#branch#enabled     = 1
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
let g:neomake_php_enabled_makers        = ['php', 'phpcs', 'phpmd']
let g:neomake_php_phpcs_args_standard   = 'PSR2'
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_scss_enabled_makers       = ['scsslint']
let g:neomake_text_enabled_makers       = ['proselint']
" Symbols: ⚠️, ❌, 🚫,  😡, 😠, ⨉, ⚠
let g:neomake_warning_sign              = { 'text': '⚠️'  }
let g:neomake_error_sign                = { 'text': '❌' }

" pangloss/vim-javascript.
let g:javascript_enable_domhtmlcss = 1

" vim-polyglot.
" Twig: `lumiliet/vim-twig` doesn't set the correct indentation or highlight HTML.
let g:polyglot_disabled = ['json', 'jsx', 'php', 'twig', 'startify']

" Vdebug.
" See: https://xdebug.org/docs-dbgp.php#feature-names
let g:vdebug_options               = get(g:, 'vdebug_options', {})
let g:vdebug_options.break_on_open = 1        " Don't stop on the first line of the script.
let g:vdebug_options.timeout       = 120      " Seconds to wait for when listening for a connection (default 20).
let g:vdebug_options.ide_key       = 'vdebug' " Xdebug client identifier.
let g:vdebug_features = {
\   'max_depth': 2048,
\   'max_children': 1024
\ }

" vim-javascript.
let g:javascript_plugin_jsdoc                      = 1 " Enable syntax highlighting for JSDoc.
let g:javascript_conceal_function                  = "ƒ"
let g:javascript_conceal_null                      = "ø"
let g:javascript_conceal_this                      = "@"
let g:javascript_conceal_return                    = "⇚"
let g:javascript_conceal_undefined                 = "¿"
let g:javascript_conceal_NaN                       = "ℕ"
let g:javascript_conceal_prototype                 = "¶"
let g:javascript_conceal_static                    = "•"
let g:javascript_conceal_super                     = "Ω"
let g:javascript_conceal_arrow_function            = "⇒"
let g:javascript_conceal_noarg_arrow_function      = "φ"
let g:javascript_conceal_underscore_arrow_function = "?"

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

" coc.nvim.
" Show signature help on placeholder jump.
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
if has_key(g:plugs, 'coc.nvim')
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . ' ' . expand('<cword>')
    endif
  endfunction

  " Use K to show documentation in the preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  " Use <Enter> to confirm completion.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin.
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " <TAB> completion.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Use `[d` and `]d` for navigate diagnostics.
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <Leader>ic :call CocAction('showIncomingCalls')

  " Code updates.
  nmap <Leader>rn <Plug>(coc-rename)
  nmap <Leader>ac <Plug>(coc-codeaction)
  nmap <Leader>qf <Plug>(coc-fix-current)
endif

" Execute the buffer contents.
nmap <Leader>r :RunCode<CR>:setlocal nofoldenable<CR>

nmap <C-n> :NERDTreeToggle<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)

" FZF.
if (executable('fzf') && has_key(g:plugs, 'fzf.vim'))
  nnoremap <Leader>f :Files<CR>
  nnoremap <nowait> <Leader>b :Buffers<CR>
  nnoremap <nowait> <C-g> :GFiles --cached --modified --others<CR>
  nnoremap <nowait> <Leader>g :GFiles --cached --modified --others<CR>
  nnoremap <nowait> <Leader>t :GGrep<CR>
  nnoremap <nowait> <Leader>s :CocList --interactive --auto-preview symbols<CR>
  nnoremap <Leader>h :History<CR>
endif

" fzf-project.
if (executable('fzf') && has_key(g:plugs, 'fzf-project'))
  nnoremap <nowait> <C-p> :FzfSwitchProject<CR>
  nnoremap <nowait> <Leader>p :FzfSwitchProject<CR>
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

" Linting.
nnoremap <Leader>l :Neomake<CR>


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
if has_key(g:plugs, 'neomake')
  augroup neomake
    autocmd BufWritePost,BufEnter * Neomake
    autocmd InsertChange,TextChanged * update | Neomake
  augroup END
endif

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
autocmd FileType apache setlocal commentstring=#\ %s

if has('nvim')
  " Escape inside a FZF terminal window should exit the terminal window
  " rather than going into the terminal's normal mode.
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
endif


" ========================================================================
" Import local vimrc `~/.vimrc.local`.                                   |
" ========================================================================

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
