set nocompatible " Enable Vim-specific features, disable Vi compatibility.
filetype off

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
" Plug: Utility.                                                         |
" ========================================================================

Plug 'Mizuchi/vim-ranger'
Plug 'DataWraith/auto_mkdir'
Plug 'tpope/vim-commentary'
if has('nvim')
  Plug 'nvim-telescope/telescope-file-browser.nvim'
    \| Plug 'nvim-telescope/telescope.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-autopairs'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
else
  Plug 'cohama/lexima.vim'
endif

" Plug 'vuki656/package-info.nvim'
"   \| Plug 'MunifTanjim/nui.nvim'


" ========================================================================
" Plug: Search.                                                          |
" ========================================================================

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  \| Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'benwainwright/fzf-project'
Plug 'romainl/vim-cool' " Disables search highlighting when you are done searching and re-enables it when you search again.
if has('nvim')
  Plug 'nvim-telescope/telescope.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
    \| Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope-frecency.nvim'
    \| Plug 'tami5/sqlite.lua'
endif


" ========================================================================
" Plug: Completion/LSP.                                                  |
" ========================================================================

" Plug 'SirVer/ultisnips'
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'hrsh7th/nvim-cmp'
    \| Plug 'hrsh7th/cmp-nvim-lsp'
    \| Plug 'hrsh7th/cmp-buffer'
    \| Plug 'hrsh7th/cmp-path'
    \| Plug 'hrsh7th/cmp-cmdline'
    \| Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  " Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  "   \| Plug 'SirVer/ultisnips'
  Plug 'tzachar/cmp-fuzzy-path'
    \| Plug 'tzachar/fuzzy.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
    \| Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'David-Kunz/cmp-npm'
    \| Plug 'nvim-lua/plenary.nvim'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'folke/trouble.nvim'
elseif v:version >= 704 && has('patch1578')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'antoinemadec/coc-fzf'
endif

" AI pair programmer which suggests line completions and entire function bodies as you type.
Plug 'github/copilot.vim'
if has('nvim')
  Plug 'zbirenbaum/copilot.lua'
endif
if has_key(g:plugs, 'nvim-cmp')
  Plug 'hrsh7th/cmp-copilot'
  Plug 'zbirenbaum/copilot-cmp'
endif


" ========================================================================
" Plug: Git.                                                             |
" ========================================================================

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter' " Git gutter column diff signs.


" ========================================================================
" Plug: Visual.                                                          |
" ========================================================================

Plug 'henrik/vim-indexed-search'      " Show 'At match #N out of M matches.' when searching.
Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and helper function.
Plug 'Yggdroot/indentLine'            " Adds vertical and/or horizontal alignment lines.
Plug 'matze/vim-move'                 " Move lines and selections up and down.
Plug 'jaxbot/semantic-highlight.vim'  " Where every variable is a different color.
Plug 'mhinz/vim-startify' " Fancy start screen.
Plug 'liuchengxu/vista.vim'
if has('nvim')
  Plug 'nvim-lualine/lualine.nvim'
    \| Plug 'kyazdani42/nvim-web-devicons'
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
    \ | Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'SmiteshP/nvim-gps'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
else
  Plug 'vim-airline/vim-airline'
    \| Plug 'vim-airline/vim-airline-themes'
endif


" ----------------------------------------
" Features.                              |
" ----------------------------------------

if has('termguicolors')
  Plug 'norcalli/nvim-colorizer.lua'
else
  Plug 'ap/vim-css-color'
endif


" ========================================================================
" Language: Python.                                                      |
" ========================================================================

if !has('nvim')
  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for': ['python'] }
endif


" ========================================================================
" Language: HTML, XML.                                                   |
" ========================================================================

Plug 'mattn/emmet-vim'       " Emmet for Vim.
Plug 'docunext/closetag.vim' " Intelligently auto-close (X)HTML tags.


" ========================================================================
" Language: JavaScript, JSON, Typescript.                                |
" ========================================================================

" ----------------------------------------
" Syntax and Indent.                     |
" ----------------------------------------

if !has('nvim')
  Plug 'leafgarland/typescript-vim'  " TypeScript syntax
  Plug 'peitalin/vim-jsx-typescript' " Syntax and indentation for JSX in Typescript (typescriptreact filetypes).
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " Syntax for styled components. Unmaintained.
  Plug 'jose-elias-alvarez/typescript.nvim'
endif

" ----------------------------------------
" Features.                              |
" ----------------------------------------

" Generate function JSDoc docblocks with `:JsDoc`.
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascriptreact', 'javascript.jsx','typescript', 'typescriptreact'],
  \ 'do': 'make install'
\}
if has('nvim')
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
    \| Plug 'nvim-lua/plenary.nvim'
endif


" ========================================================================
" Plug: Markdown.                                                        |
" ========================================================================

Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }


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

Plug 'Shougo/neco-vim', { 'for': 'vim' } " VimL completion.


" ========================================================================
" Plug: Themes.                                                          |
" ========================================================================

Plug 'flazz/vim-colorschemes' " All single-file vim.org colour schemes.
Plug 'rakr/vim-one'           " Adaptation of one-light and one-dark colorschemes for Vim.
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'alessandroyorba/despacio'
if has('nvim')
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
endif
Plug 'rebelot/kanagawa.nvim'

Plug 'arcticicestudio/nord-vim'
Plug 'projekt0n/github-nvim-theme'
Plug 'sts10/vim-pink-moon'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'EdenEast/nightfox.nvim'
Plug 'rose-pine/neovim'


let g:material_style = "deep ocean"
Plug 'marko-cerovac/material.nvim'
let g:material_style = "deep ocean"
colorscheme material


" ========================================================================
" Plug: Text Editing.                                                    |
" ========================================================================

Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'tpope/vim-surround'


" ========================================================================
" Plug: Sidebars.                                                        |
" ========================================================================

Plug 'scrooloose/nerdtree'
  \| Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'simnalamburt/vim-mundo'


" ========================================================================
" Plug: SQL.                                                             |
" ========================================================================

" Plug 'joereynolds/SQHell.vim'


" ========================================================================
" Plug: Linting.                                                         |
" ========================================================================

" Plug 'creativenull/diagnosticls-configs-nvim'
"   \| Plug 'neovim/nvim-lspconfig'

" ========================================================================
" Plug: Functional.                                                      |
" ========================================================================

Plug '0x84/vim-coderunner'           " Run the buffer on the fly.
Plug 'chrisbra/Recover.vim'          " Show a diff whenever recovering a buffer.
Plug 'editorconfig/editorconfig-vim' " Some default configs.
Plug 'tpope/vim-eunuch'              " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'tpope/vim-repeat'              " Enable repeating supported plugin maps with '.'.
Plug 'vim-utils/vim-troll-stopper'   " Highlight Unicode trolls/homoglyph.
Plug 'joonty/vdebug'                 " DBGP protocol debugger  (e.g. Xdebug).
Plug 'rhysd/committia.vim'           " Better `git commit` interface, with status and diff window.
if !has_key(g:plugs, 'nvim-treesitter')
  Plug 'sheerun/vim-polyglot'          " Language pack collection (syntax, indent, ftplugin, ftdetect).
endif

call plug#end() " Required.


" ========================================================================
" General Config.                                                        |
" ========================================================================

filetype plugin indent on

let mapleader = ' '

syntax enable  " Enable syntax highlighting.

set background=dark
set conceallevel=0            " Don't conceal quotes in JSON files.
set omnifunc=syntaxcomplete#Complete

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
  set undofile                 " Save undo after file closes.
  set undodir=~/.vim/undo      " Where to save undo histories.
  set undolevels=10000         " How many undos to remember.
  set undoreload=100000        " Number of lines to save for undo.
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
set scrolloff=1              " Scroll offset lines.
set sidescroll=5             " Minimal columns to show when `wrap` is set.
set sidescrolloff=5          " Minimal columns to show when `nowrap` is set.
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 EOLs.
set complete+=kspell         " Enable word completion.
set complete-=i              " Disable current and included file scanning, use tags instead.

" This will show the popup menu even if there's only one match (menuone),
" prevent automatic selection (noselect) and prevent automatic text injection
" into the current line (noinsert).
set completeopt=noinsert,menuone,noselect,preview

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

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 (https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162).
" Based on Vim patch 7.4.1770 (`guicolors` option) (https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd).
" (https://github.com/neovim/neovim/wiki/Following-HEAD#20160511)
if has('termguicolors')
  set termguicolors
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
let php_sql_query                     = 1  " Enable SQL syntax highlighting inside strings.


" ========================================================================
" GUI Mode Specific.                                                     |
" ========================================================================

if has('gui_running')
  set guioptions+=c " Use console dialogs instead of popup dialogs for simple choices.
  set guioptions-=m " Disable menu bar.
  set guioptions-=L " Disable left-hand scrollbar when vertical split open.
  set guioptions-=r " Disable right-hand scrollbar.
endif


" ========================================================================
" Mappings.                                                              |
" ========================================================================

" New empty buffer in insert mode.
map <Leader>e :enew<CR>i

" Edit `~/.vimrc`.
map <Leader>v :e $MYVIMRC<CR>

" Edit `~/.zshrc`.
map <Leader>z :e ~/.zshrc<CR>

" Close buffer.
map <Leader>d :lclose<CR>:bwipe!<CR>

" Toggle spell checking.
map <Leader>ss :setlocal spell!<CR>

" Strip trailing whitespace.
nmap <Leader>sw :%s/\s\+$//e<CR>

" Repeat f, F, T, t commands.
noremap \ ;

" Easier EX mode.
nmap ; :

" Code formatting.
nmap <Leader>fj :FormatJson<CR>

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

" LSP.

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
  " Disable folding by default.
  autocmd FileType * setlocal nofoldenable
augroup END

" Toggle search highlighting.
if has('nvim')
  noremap <silent><Esc> :set hlsearch! hlsearch?<CR>
else
  " Vim starts with '2R' in ex mode otherwise.
  autocmd InsertEnter * noremap <silent><Esc> :set hlsearch! hlsearch?<CR>
endif

" Commenting.
autocmd FileType apache setlocal commentstring=#\ %s

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

  " Other.
  autocmd BufRead,BufNewFile *.plist     setlocal filetype=xml
  autocmd BufRead,BufNewFile *.scss      setlocal filetype=scss.css
  autocmd BufRead,BufNewFile *.yml.dist  setlocal filetype=yaml
  autocmd BufRead,BufNewFile Jenkinsfile setlocal filetype=groovy

  " Typescript/React.
  autocmd BufRead,BufNewFile *.jsx setlocal filetype=javascriptreact
  autocmd BufRead,BufNewFile *.tsx setlocal filetype=typescriptreact
  autocmd BufRead,BufNewFile *.js  setlocal filetype=javascriptreact
  autocmd BufRead,BufNewFile *.ts  setlocal filetype=typescriptreact
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

function! ProfileStart()
  profile start ~/Desktop/profile.log
  profile func *
  profile file *
endfunction

function! ProfileEnd()
  profile pause
  noautocmd qall!
endfunction

" Change to random colorscheme from a defined list of awesome ones.
function! NextColorScheme()
  let colorschemes = [
    \ 'OceanicNext',
    \ 'badwolf',
    \ 'bluechia',
    \ 'gruvbox',
    \ 'hybrid',
    \ 'kanagawa',
    \ 'monokain',
    \ 'tokyonight',
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
    \ 'FantasqueSansMono\ Nerd\ Font:h16',
    \ 'Hack\ Nerd\ Font:h14',
    \ 'JetBrainsMono\ Nerd\ Font:14',
    \ 'DroidSansMono\ Nerd\ Font:h14',
    \ 'Inconsolata\ Nerd\ Font:h15',
    \ 'UbuntuMono\ Nerd\ Font:h15',
    \ 'mononoki\ Nerd\ Font:h14',
    \ 'LiterationMono\ Nerd\ Font:h14',
    \ 'FiraMono\ Nerd\ Font:h14',
    \ 'SF_Mono_Regular:h16'
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
command! -bar FormatJson :%!python3 -m json.tool

" Plugin commands.
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


" ========================================================================
" Plugin Settings.                                                       |
" ========================================================================

" Import Lua plugin configs.
lua << EOF
require('material').setup()
EOF
colorscheme material
if has('nvim')
  lua require('plugins.bufferline')
  " lua require('plugins.diagnosticls-configs-nvim')
  lua require('plugins.lsp_signature')
  lua require('plugins.lualine')
  lua require('plugins.nvim-autopairs')
  lua require('plugins.nvim-cmp')
  lua require('plugins.nvim-lsp-installer')
  lua require('plugins.nvim-treesitter')
  lua require('plugins.telescope')
  lua require('plugins.telescope-file-browser')
  lua require('colorizer').setup({ '*' })
  lua require('nvim-gps').setup()
  lua require('lsp-diagnostic')
  lua require('lsp-diagnostic')
  lua require('trouble').setup()
  lua require('plugins.theme-material')
  " lua require('package-info').setup({ package_manager = 'npm' })
endif

let g:Hexokinase_highlighters = ['backgroundfull']

" FZF.
let g:fzf_history_dir = '~/.local/share/fzf-history'

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
let g:indentLine_setConceal      = 0 " Don't change the conceallevel setting.

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
  \ 'coc-fzf-preview',
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

" Airline.
let g:airline_theme = 'badwolf'
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
let g:javascript_conceal_function                  = 'ƒ'
let g:javascript_conceal_null                      = 'ø'
let g:javascript_conceal_this                      = '@'
let g:javascript_conceal_return                    = '⇚'
let g:javascript_conceal_undefined                 = '¿'
let g:javascript_conceal_NaN                       = 'ℕ'
let g:javascript_conceal_prototype                 = '¶'
let g:javascript_conceal_static                    = '•'
let g:javascript_conceal_super                     = 'Ω'
let g:javascript_conceal_arrow_function            = '⇒'
let g:javascript_conceal_noarg_arrow_function      = 'φ'
let g:javascript_conceal_underscore_arrow_function = '?'


" ========================================================================
" Theme Settings.                                                        |
" ========================================================================

" Gruvbox.
let g:gruvbox_contrast_dark = 'hard'


" ========================================================================
" Plugin Mappings.                                                       |
" ========================================================================

" Default LSP config.
if has_key(g:plugs, 'nvim-lspconfig')
  nmap <silent> K :lua vim.lsp.buf.hover()<CR>
  nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nmap <silent> gD :lua vim.lsp.buf.declaration()<CR>
  nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
  nmap <silent> gt :lua vim.lsp.buf.type_definition()<CR>
  nmap <silent> gr :lua vim.lsp.buf.references()<CR>
  nmap <C-k> :lua vim.lsp.buf.signature_help()<CR>
  nmap <silent> K :lua vim.lsp.buf.hover()<CR>
  nmap <Leader>rn :lua vim.lsp.buf.rename()<CR>
  nmap <Leader>ca :lua vim.lsp.buf.code_action()<CR>
  nmap <silent> gl :lua vim.diagnostic.open_float()<CR>
  nmap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
  nmap <silent> ]d :lua vim.diagnostic.goto_next()<CR>
  nmap <Leader>ic :lua vim.lsp.buf.incoming_calls()<CR>
  nmap <Leader>oc :lua vim.lsp.buf.outgoing_calls()<CR>
endif

" coc.nvim.
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

  " Use <Enter> to confirm completion.
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  inoremap <silent><expr> <c-@> coc#refresh()

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <CR> could be remapped by other vim plugin.
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " <TAB> completion.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " LSP.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gt <Plug>(coc-type-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> K :call <SID>show_documentation()<CR>
  nmap <Leader>rn <Plug>(coc-rename)
  nmap <Leader>ca <Plug>(coc-codeaction)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  nmap <Leader>ic :call CocAction('showIncomingCalls')
" Telescope.nvim.
elseif has_key(g:plugs, 'telescope.nvim')
  " LSP.
  nmap <silent> gd :Telescope lsp_definitions<CR>
  nmap <silent> gi :Telescope lsp_implementations<CR>
  nmap <silent> gt :Telescope lsp_type_definitions<CR>
  nmap <silent> gr :Telescope lsp_references<CR>
  nmap <Leader>s :Telescope lsp_dynamic_workspace_symbols<CR>
  nmap <silent> gl :Telescope diagnostics<CR>

  " Find things.
  nmap <nowait> <Leader>b :Telescope buffers<CR>
  " nmap <nowait> <C-g> :lua require('plugins.telescope').project_files()<CR>
  nmap <nowait> <Leader>g :lua require('plugins.telescope').project_files()<CR>
  nmap <Leader>fb :Telescope file_browser<CR>
endif

" FZF.
if (executable('fzf') && has_key(g:plugs, 'fzf.vim'))
  if !has_key(g:plugs, 'telescope.nvim')
    nnoremap <nowait> <Leader>b :Buffers<CR>
  endif
  nnoremap <nowait> <C-g> :GFiles --cached --modified --others<CR>
  " nnoremap <nowait> <Leader>g :GFiles --cached --modified --others<CR>
  nnoremap <Leader>t :GGrep<CR>
endif

" Bufferline.
map <Leader>, :lclose<CR>:BufferLineCyclePrev<CR>
map <Leader>. :lclose<CR>:BufferLineCycleNext<CR>
noremap <C-Tab> :lclose<CR>:BufferLineCycleNext<CR>
noremap <C-S-Tab> :lclose<CR>:BufferLineCyclePrev<CR>

" Execute the buffer contents.
nmap <Leader>r :RunCode<CR>:setlocal nofoldenable<CR>

nmap <C-n> :NERDTreeToggle<CR>

nmap <nowait> <Leader>st :Vista!!<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip).
nmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)

" fzf-project.
if (executable('fzf') && has_key(g:plugs, 'fzf-project'))
  nnoremap <nowait> <C-p> :FzfSwitchProject<CR>
  nnoremap <nowait> <Leader>p :FzfSwitchProject<CR>
endif

" Linting.
nnoremap <Leader>l :Neomake<CR>


" ========================================================================
" Plugin Autocommands.                                                   |
" ========================================================================

" AutoClose. Disable for VimL files.
autocmd FileType vim let b:AutoCloseOn = 0

" Show signature help on placeholder jump.
if has_key(g:plugs, 'coc.nvim')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
endif

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

" startify. Disable folding on the start screen.
autocmd FileType startify setlocal nofoldenable

" Strip whitespace on save.
autocmd BufWritePre * StripWhitespace

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
