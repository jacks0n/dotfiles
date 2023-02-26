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

Plug 'nat-418/boole.nvim'
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
  Plug 'David-Kunz/markid'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'lewis6991/impatient.nvim'
  Plug 'ggandor/leap.nvim'
else
  Plug 'cohama/lexima.vim'
endif

Plug 'vuki656/package-info.nvim'
  \| Plug 'MunifTanjim/nui.nvim'


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

if has('nvim')
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'jay-babu/mason-null-ls.nvim'
  Plug 'VonHeikemen/lsp-zero.nvim'
    \| Plug 'neovim/nvim-lspconfig'
    \| Plug 'williamboman/mason.nvim'
    \| Plug 'williamboman/mason-lspconfig.nvim'
    \| Plug 'hrsh7th/nvim-cmp'
    \| Plug 'hrsh7th/cmp-buffer'
    \| Plug 'hrsh7th/cmp-path'
    \| Plug 'L3MON4D3/LuaSnip'
    \| Plug 'saadparwaiz1/cmp_luasnip'
    \| Plug 'hrsh7th/cmp-nvim-lsp'
    \| Plug 'hrsh7th/cmp-nvim-lua'
    \| Plug 'hrsh7th/cmp-cmdline'
    \| Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
    \| Plug 'b0o/schemastore.nvim'
  Plug 'zbirenbaum/copilot-cmp'
    \| Plug 'zbirenbaum/copilot.lua'
  Plug 'AndrewRadev/sideways.vim'
  Plug 'onsails/lspkind.nvim'
    \| Plug 'hrsh7th/nvim-cmp'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'Maan2003/lsp_lines.nvim'
  Plug 'weilbith/nvim-code-action-menu'
  Plug 'SmiteshP/nvim-navic'
  Plug 'glepnir/lspsaga.nvim'
    \| Plug 'nvim-tree/nvim-web-devicons'
    \| Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'honza/vim-snippets'
  Plug 'roobert/node-type.nvim'
elseif v:version >= 704 && has('patch1578')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'antoinemadec/coc-fzf'
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
if has('nvim')
  Plug 'johnfrankmorgan/whitespace.nvim' " Whitespace highlighting and helper function.
else
  Plug 'ntpeters/vim-better-whitespace' " Whitespace highlighting and helper function.
endif
Plug 'matze/vim-move'                 " Move lines and selections up and down.
Plug 'jaxbot/semantic-highlight.vim'  " Where every variable is a different color.
Plug 'mhinz/vim-startify'             " Fancy start screen.
Plug 'liuchengxu/vista.vim'
if has('nvim')
  Plug 'kevinhwang91/nvim-ufo'
    \| Plug 'kevinhwang91/promise-async'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'nvim-lualine/lualine.nvim'
    \| Plug 'nvim-tree/nvim-web-devicons'
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
    \ | Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'nvim-treesitter/nvim-treesitter-context'
    \| Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'folke/todo-comments.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
else
  Plug 'Yggdroot/indentLine' " Adds vertical and/or horizontal alignment lines.
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
  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
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

if has('nvim')
  Plug 'jose-elias-alvarez/typescript.nvim'
else
  Plug 'leafgarland/typescript-vim'  " TypeScript syntax
  Plug 'peitalin/vim-jsx-typescript' " Syntax and indentation for JSX in Typescript (typescriptreact filetypes).
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " Syntax for styled components. Unmaintained.
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

Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}


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
Plug 'Matsuuu/pinkmare'
if has('nvim')
  Plug 'EdenEast/nightfox.nvim'
  Plug 'catppuccin/nvim', {'as': 'catppuccin'}
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'rebelot/kanagawa.nvim'
  Plug 'rose-pine/neovim'
  Plug 'ellisonleao/gruvbox.nvim'
endif


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
" Plug: Functional.                                                      |
" ========================================================================

Plug '0x84/vim-coderunner'           " Run the buffer on the fly.
Plug 'chrisbra/Recover.vim'          " Show a diff whenever recovering a buffer.
Plug 'editorconfig/editorconfig-vim' " Some default configs.
Plug 'tpope/vim-eunuch'              " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'tpope/vim-repeat'              " Enable repeating supported plugin maps with '.'.
Plug 'vim-utils/vim-troll-stopper'   " Highlight Unicode trolls/homoglyph.
" Plug 'joonty/vdebug'                 " DBGP protocol debugger  (e.g. Xdebug).
Plug 'rhysd/committia.vim'           " Better `git commit` interface, with status and diff window.
if !has_key(g:plugs, 'nvim-treesitter')
  Plug 'sheerun/vim-polyglot'          " Language pack collection (syntax, indent, ftplugin, ftdetect).
endif

if has('nvim')
  Plug 'abecodes/tabout.nvim'
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
set selection=old            " Do not select past the EOL in visual mode.

" This will show the popup menu even if there's only one match (menuone),
" prevent automatic selection (noselect) and prevent automatic text injection
" into the current line (noinsert).
set completeopt=noinsert,menuone,noselect,preview

set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " Completion ignore patterns.
set wildignore+=*.min.css,*.min.js        " Completion ignore patterns.

set smarttab                   " Emulate tab behaviour with spaces.
set expandtab                  " Tabs are spaces.
set shiftwidth=2               " Spaces per tab.
set softtabstop=2              " Number of spaces in tab when editing.
set tabstop=2                  " Number of visual spaces per tab.
set cindent                    " Indent from previous line, with C syntax.
set display+=lastline          " Display as much as possible of last line in window, '@@@' when truncated.
set ruler                      " Show the line and column number of the cursor position.
set viminfo^=%                 " Remember info about open buffers on close.
set t_RV=                      " Temporary fix prevents unexpected keypresses on startup.
set lazyredraw                 " Don't redraw while executing macros (good performance config).
set ttyfast                    " Send more characters for redraws.
set mouse=ar                   " Enable mouse use in all modes.
set backspace=indent,eol,start " Allow backspacing over autoindent, line breaks and start of insert action.
set guicursor=a:blinkon0       " Disable cursor blink.
set synmaxcol=250              " Don't try to highlight long lines.
set fillchars=eob:\ ,fold:\ ,foldopen:,foldsep:\ ,foldclose:
set laststatus=2               " Always show the status line.
set nofoldenable
if has('nvim')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
else
  set foldmethod=manual          " Manually fold.
endif

" Use a block cursor in normal mode, i-beam cursor in insert mode, and underline cursor in replace mode.
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

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

" Python.
let g:no_plugin_maps = 1
let g:python_recommended_style = 0


" ========================================================================
" Language Provider Settings.                                            |
" ========================================================================

let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0


" ========================================================================
" GUI Mode Specific.                                                     |
" ========================================================================

if has('gui_running')
  set guioptions+=c " Use console dialogs instead of popup dialogs for simple choices.
  set guioptions-=m " Disable menu bar.
  set guioptions-=L " Disable left-hand scrollbar when vertical split open.
  set guioptions-=r " Disable right-hand scrollbar.
endif

if exists('g:neovide')
  " Map OSX shortcuts.
  let g:neovide_input_use_logo = v:true
  let g:neovide_input_macos_alt_is_meta = v:true
  map <D-v> "+p<CR>
  map! <D-v> <C-R>+
  tmap <D-v> <C-R>+
  vmap <D-c> "+y<CR>
endif

if has('gui_running') || exists('g:neovide')
  " Change font size.
  nmap <D-=> :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')<CR>
  nmap <D--> :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')<CR>
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

" Repeat f, F, T, t commands.
noremap \ ;

" Easier EX mode.
nmap ; :

" Code formatting.
nmap <Leader>fj :FormatJson<CR>
nmap <Leader>fx :FormatXml<CR>

" Don't lose selection when shifting sidewards.
" xnoremap < <gv
" xnoremap > >gv

" Code folding options.
nmap <Leader>fl- :setlocal nofoldenable<CR>
nmap <Leader>fl= :setlocal foldenable<CR>
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
map <C-k> <C-W>k
map <C-j> <C-W>j
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

" Follow symlinks when opening files.
function! FollowSymlink(...)
  let fname = a:0 ? a:1 : expand('%')
  if fname =~ '^\w\+:/'
    " Do not mess with 'fugitive://', etc.
    return
  endif
  let fname = simplify(fname)

  let resolvedfile = resolve(fname)
  if resolvedfile == fname
    return
  endif
  let resolvedfile = fnameescape(resolvedfile)
  exec 'file ' . resolvedfile
endfunction
augroup follow_symlink
  autocmd!
  autocmd BufReadPost * call FollowSymlink(expand('<afile>'))
augroup END

" Toggle search highlighting.
if has('nvim')
  noremap <silent><Esc> :set hlsearch! hlsearch?<CR>
else
  " Vim starts with '2R' in ex mode otherwise.
  autocmd InsertEnter * noremap <silent><Esc> :set hlsearch! hlsearch?<CR>
endif

" Only set the cursorline when out of insert mode.
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Commenting.
autocmd FileType apache setlocal commentstring=#\ %s
autocmd FileType terraform setlocal commentstring=#\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s

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
  autocmd BufRead,BufNewFile *.ipynb     setlocal filetype=python
  autocmd BufRead,BufNewFile *.yml.dist  setlocal filetype=yaml
  autocmd BufRead,BufNewFile Jenkinsfile setlocal filetype=groovy
  autocmd BufNewFile,BufRead *.tftpl     setlocal filetype=terraform

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

function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
      silent execute 'bwipeout' buf
  endfor
endfunction

function! ProfileStart()
  delete(expand('~/Desktop/profile.log'))
  profile start ~/Desktop/profile.log
  profile func *
  profile file *
endfunction

function! ProfileEnd()
  profile pause
  noautocmd qall!
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
if executable('yq')
  command! -bar FormatJson :%!yq -oj eval .
elseif executable('python3')
  command! -bar FormatJson :%!python3 -m json.tool
endif
command! -bar FormatXml :%!xmllint --format --recover -

" Plugin commands.
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


" ========================================================================
" Plugin Settings.                                                       |
" ========================================================================

" Disable some core plugins.
let g:loaded_matchparen      = 1
let g:loaded_zipPlugin       = 1
let g:loaded_2html_plugin    = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_netrwPlugin     = 1
let g:loaded_rrhelper        = 1
let g:loaded_tarPlugin       = 1
let g:loaded_tar             = 1

" Import Lua plugin configs.
if has('nvim')
  lua require('plugins.whitespace')
  lua require('plugins.lspsaga')
  lua require('plugins.todo-comments')
  lua require('plugins.lspconfig')
  lua require('plugins.typescript')
  lua require('plugins.bufferline')
  lua require('plugins.lsp_signature')
  lua require('plugins.lualine')
  lua require('plugins.nvim-autopairs')
  lua require('plugins.copilot-lua')
  lua require('copilot_cmp').setup()
  lua require('plugins.nvim-cmp')
  lua require('plugins.lsp-zero')
  lua require('plugins.null-ls')
  lua require('plugins.mason-null-ls')
  lua require('plugins.nvim-treesitter')
  lua require('plugins.telescope')
  lua require('plugins.markid')
  lua require('plugins.telescope-file-browser')
  lua require('plugins.leap')
  lua require('plugins.lsp_lines')
  lua require('plugins.boole')
  lua require('plugins.tabout')
  lua require('colorizer').setup({ '*' })
  lua require('lsp-diagnostic')
  lua require('trouble').setup()
  lua require('gruvbox').setup()
  lua require('node-type').setup()
  lua require('plugins.nvim-ufo')
  lua require('plugins.package-info')
endif

let g:Hexokinase_highlighters = ['backgroundfull']

let g:indexed_search_mappings = 0

" vim-move.
let g:move_map_keys = 0

" vim-coderunner.
let g:vcr_languages = {}
let g:vcr_languages['javascriptreact'] = {
  \   'cmd': 'node',
  \ }
let g:vcr_languages['typescriptreact'] = {
  \   'cmd': 'ts-node',
  \ }

" FZF.
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

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
let g:gitgutter_map_keys                = 0
highlight clear SignColumn

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
  \ 'coc-tag',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-word',
  \ 'coc-yaml',
  \ ]
  " \ 'coc-tabnine',

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

if has_key(g:plugs, 'package-info.nvim')
  nnoremap <silent> <Leader>nd <cmd>lua require('package-info').delete()<CR>
  nnoremap <silent> <Leader>nv <cmd>lua require('package-info').change_version()<CR>
  nnoremap <silent> <Leader>ni <cmd>lua require('package-info').install()<CR>
  nnoremap <silent> <Leader>nt <cmd>lua require('package-info').toggle()<CR>
  tnoremap <silent> <Leader>nu <cmd>lua require('package-info').update()<CR>
  nnoremap <silent> <Leader>ns <cmd>lua require('package-info').show()<CR>
  nnoremap <silent> <Leader>nh <cmd>lua require('package-info').hide()<CR>
endif

if has_key(g:plugs, 'nvim-lspconfig')
  nmap <silent> K :lua vim.lsp.buf.hover()<CR>
  nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nmap <silent> gD :lua vim.lsp.buf.declaration()<CR>
  nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
  nmap <silent> gt :lua vim.lsp.buf.type_definition()<CR>
  nmap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
  nmap <silent> ]d :lua vim.diagnostic.goto_next()<CR>
  nmap <silent> [[ :lua vim.diagnostic.disable()<CR>
  nmap <silent> ]] :lua vim.diagnostic.enable()<CR>
"   nmap <Leader>ic :lua vim.lsp.buf.incoming_calls()<CR>
"   nmap <Leader>oc :lua vim.lsp.buf.outgoing_calls()<CR>
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
  nnoremap <silent> gd <Plug>(coc-definition)
  nnoremap <silent> gi <Plug>(coc-implementation)
  nnoremap <silent> gt <Plug>(coc-type-definition)
  nnoremap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  nnoremap <silent> rn <Plug>(coc-rename)
  nnoremap <Leader>ca <Plug>(coc-codeaction)
  nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]d <Plug>(coc-diagnostic-next)
  nnoremap <Leader>ic :call CocAction('showIncomingCalls')
" Telescope.nvim.
elseif has_key(g:plugs, 'telescope.nvim')
  nnoremap <nowait> <Leader>b :Telescope buffers<CR>
  nnoremap <nowait> <C-g> :lua require('plugins.telescope').git_files_all()<CR>
  nnoremap <nowait> <Leader>h :lua require('plugins.telescope').project_files()<CR>
  nnoremap <Leader>fb :Telescope file_browser<CR>
  nnoremap gr :Telescope lsp_references<CR>
endif

if has_key(g:plugs, 'lspsaga.nvim')
  nnoremap <silent> gp <cmd>Lspsaga lsp_finder<CR>
  nnoremap pgd <cmd>Lspsaga peek_definition<CR>
  nnoremap pgt <cmd>Lspsaga peek_type_definition<CR>
  nnoremap go <cmd>Lspsaga outline<CR>
  nnoremap <Leader>gi  <cmd>Lspsaga incoming_calls<CR>
  nnoremap <Leader>go <cmd>Lspsaga outgoing_calls<CR>
  nnoremap <silent> <Leader>lp <cmd>Lspsaga lsp_finder<CR>
  nnoremap <silent> rn <cmd>Lspsaga rename<CR>
endif

" weilbith/nvim-code-action-menu.
if has_key(g:plugs, 'nvim-code-action-menu')
  nnoremap <Leader>ca :lua require('code_action_menu').open_code_action_menu()<CR>
endif

nnoremap <C-h> :SidewaysLeft<cr>
nnoremap <C-l> :SidewaysRight<cr>

" vim-mode.
nnoremap <D-k> <Plug>MoveLineUp
nnoremap <D-j> <Plug>MoveLineDown
vnoremap <D-k> <Plug>MoveBlockDown
vnoremap <D-j> <Plug>MoveBlockUp

" Trouble.nvim.
if has_key(g:plugs, 'trouble.nvim')
  nnoremap <leader>xx <cmd>TroubleToggle<cr>
  nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
  nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
  nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
  nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
endif

" FZF.
if (executable('fzf') && has_key(g:plugs, 'fzf.vim'))
  if !has_key(g:plugs, 'telescope.nvim')
    nnoremap <nowait> <Leader>b :Buffers<CR>
  endif
  if !has_key(g:plugs, 'telescope.nvim')
    nnoremap <nowait> <C-g> :GFiles --cached --modified --others<CR>
  endif
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
  nnoremap <nowait> <Leader>p :FzfSwitchProject<CR>
endif


" ========================================================================
" Plugin Autocommands.                                                   |
" ========================================================================

" AutoClose. Disable for VimL files.
autocmd FileType vim let b:AutoCloseOn = 0

autocmd FileType sagacodeaction nnoremap <buffer> <ESC> :bw<CR>
autocmd FileType sagarename nnoremap <buffer> <ESC> :bw<CR>

autocmd FileType lspsagafinder let b:better_whitespace_enabled = 0

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

" startify. Disable folding on the start screen.
autocmd FileType startify setlocal nofoldenable

" Strip whitespace on save.
if has_key(g:plugs, 'whitespace.nvim')
  autocmd BufWritePre * lua require('whitespace-nvim').trim()
elseif has_key(g:plugs, 'vim-better-whitespace')
  autocmd BufWritePre * StripWhitespace
endif

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
