" @todo
" Get unit testing working with Jest.
" Try to get NULL_LS to use the local binary.
" Only include eslint and other linters if there's a config available in the repo.

set nocompatible " Enable Vim-specific features, disable Vi compatibility.
filetype off

" ========================================================================
" GUI Mode Specific.                                                     |
" ========================================================================

if has('gui_running')
  set guioptions-=m " Disable menu bar.
  set guioptions-=L " Disable left-hand scrollbar when vertical split open.
  set guioptions-=r " Disable right-hand scrollbar.
endif

if exists('g:neovide')
  " Map OSX shortcuts.
  let g:neovide_input_use_logo = v:true
  let g:neovide_input_macos_option_key_is_meta = v:true
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
" Import local before .vimrc `~/.vimrc.before.local`.                    |
" ========================================================================

" Initialize g:use_coc variable if not set
if !exists('g:use_coc')
  let g:use_coc = 0
endif

if filereadable(expand('~/.vimrc.before.local'))
  source ~/.vimrc.before.local
endif


" ========================================================================
" Plug: Search.                                                          |
" ========================================================================

Plug 'romainl/vim-cool' " Disables search highlighting when you are done searching and re-enables it when you search again.
if has('nvim')
  Plug 'nvim-telescope/telescope.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
    \| Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
endif


" ========================================================================
" Plug: Completion/LSP.                                                  |
" ========================================================================

if (has('nvim') && exists('g:use_coc') && g:use_coc) || !has('nvim')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
elseif has('nvim')
  Plug 'aznhe21/actions-preview.nvim'
  Plug 'OXY2DEV/markview.nvim' " Must be loaded before treesitter.
  Plug 'glepnir/lspsaga.nvim'
    \| Plug 'nvim-tree/nvim-web-devicons'
    \| Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'SmiteshP/nvim-navbuddy'
    \| Plug 'SmiteshP/nvim-navic'
    \| Plug 'MunifTanjim/nui.nvim'
    \| Plug 'nvim-telescope/telescope.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'folke/lazydev.nvim'
  Plug 'Bilal2453/luvit-meta'
  " Plug 'stevearc/conform.nvim'
  " Plug 'mfussenegger/nvim-lint'
  Plug 'neovim/nvim-lspconfig'
    \| Plug 'mason-org/mason.nvim', { 'do': ':MasonUpdate' }
    \| Plug 'mason-org/mason-lspconfig.nvim'
    \| Plug 'b0o/schemastore.nvim'
    " \| Plug 'zapling/mason-conform.nvim'
    " \| Plug 'rshkarin/mason-nvim-lint'
  Plug 'nvimtools/none-ls.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
    \| Plug 'nvimtools/none-ls-extras.nvim'
    \| Plug 'jay-babu/mason-null-ls.nvim'
  Plug 'saghen/blink.cmp'
  Plug 'saghen/blink.compat'
    \| Plug 'onsails/lspkind.nvim'
  Plug 'giuxtaposition/blink-cmp-copilot'
    \| Plug 'zbirenbaum/copilot.lua'
  Plug 'AndrewRadev/sideways.vim' " Move function arguments.
  Plug 'yioneko/nvim-vtsls'
  " Plug 'seblyng/roslyn.nvim'
  Plug 'Hoffs/omnisharp-extended-lsp.nvim'
endif


" ========================================================================
" Plug: Snippets.                                                        |
" ========================================================================

if has('nvim')
  Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
    \| Plug 'rafamadriz/friendly-snippets'
    \| Plug 'honza/vim-snippets'
endif



" ========================================================================
" Plug: Git.                                                             |
" ========================================================================

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter' " Git gutter column diff signs.
Plug 'esmuellert/vscode-diff.nvim'


" ========================================================================
" Plug: Visual.                                                          |
" ========================================================================

Plug 'norcalli/nvim-colorizer.lua'
Plug 'mhinz/vim-startify'             " Fancy start screen.
Plug 'wuelnerdotexe/vim-enfocado'
if has('nvim')
  Plug 'johnfrankmorgan/whitespace.nvim' " Whitespace highlighting and helper function.
  Plug 'kevinhwang91/nvim-ufo'
    \| Plug 'kevinhwang91/promise-async'
  Plug 'luukvbaal/statuscol.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'nvim-lualine/lualine.nvim'
    \| Plug 'nvim-tree/nvim-web-devicons'
  Plug 'akinsho/bufferline.nvim'
    \| Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'folke/todo-comments.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
else
  Plug 'vim-airline/vim-airline'
    \| Plug 'vim-airline/vim-airline-themes'
endif


" ========================================================================
" Plug: Utility.                                                         |
" ========================================================================

Plug 'editorconfig/editorconfig-vim' " Some default configs.
Plug 'tpope/vim-eunuch'              " Unix helpers. :Remove, :Move, :Rename, :Chmod, :SudoWrite, :SudoEdit, etc.
Plug 'rhysd/committia.vim'           " Better `git commit` interface, with status and diff window.
if !has('nvim')
  Plug 'sheerun/vim-polyglot'        " Language pack collection (syntax, indent, ftplugin, ftdetect). NeoVim uses treesitter instead.
endif
if has('nvim')
  Plug 'kevinhwang91/rnvimr'
  Plug 'm4xshen/hardtime.nvim'
        \| Plug 'MunifTanjim/nui.nvim'
  Plug 'monaqa/dial.nvim'
  Plug 'bennypowers/nvim-regexplainer'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    \| Plug 'MunifTanjim/nui.nvim'
  Plug 'rareitems/printer.nvim'
  Plug 'nvim-telescope/telescope-file-browser.nvim'
    \| Plug 'nvim-telescope/telescope.nvim'
  Plug 'ggandor/leap.nvim'
    \| Plug 'tpope/vim-repeat'
  Plug 'CKolkey/ts-node-action'
    \| Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " Plug 'folke/noice.nvim'
  "   \| Plug 'MunifTanjim/nui.nvim'
  "   \| Plug 'rcarriga/nvim-notify'
  Plug 'Wansmer/treesj'
  Plug 'nvim-neotest/neotest'
    \| Plug 'nvim-neotest/nvim-nio'
    \| Plug 'nvim-lua/plenary.nvim'
    \| Plug 'antoinemadec/FixCursorHold.nvim'
    \| Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'haydenmeade/neotest-jest'
  Plug 'abecodes/tabout.nvim'
  Plug 'CRAG666/code_runner.nvim'
    \| Plug 'nvim-lua/plenary.nvim'
  Plug 'vuki656/package-info.nvim'
    \| Plug 'MunifTanjim/nui.nvim'
else
  Plug 'tpope/vim-commentary'
endif


" ========================================================================
" Language: HTML, XML.                                                   |
" ========================================================================

if has('nvim')
  Plug 'windwp/nvim-ts-autotag' " Intelligently auto-close (X)HTML tags.
endif


" ========================================================================
" Language: JavaScript, JSON, Typescript.                                |
" ========================================================================

" ----------------------------------------
" Syntax and Indent.                     |
" ----------------------------------------



" ========================================================================
" Plug: Markdown.                                                        |
" ========================================================================

Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}


" ========================================================================
" Plug: Themes.                                                          |
" ========================================================================

Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
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
if has('nvim')
  Plug 'kylechui/nvim-surround'
else
  Plug 'tpope/vim-surround'
end


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

set autoread                  " Re-load files on external modifications and none locally.
set autowrite                 " Automatically save before :next, :make etc.
set whichwrap=b,s,h,l,<,>,[,] " Characters which wrap lines (b = <BS>, s = <Space>).
set updatetime=300            " Milliseconds to wait after typing to save the swap file.

set t_vb=
set noerrorbells              " Ring the bell (beep or screen flash) for error messages.
set visualbell                " Use visual bell instead of beeping.
set shortmess=aAIF            " ┐ Avoid all the hit-enter prompts.
                              " | a: All abbreviations.
                              " | A: No existing swap file 'ATTENTION' message.
                              " | I: No |:intro| starting message.
                              " ┘ F: No file info when editing (for gd, etc).

set iskeyword+=/              " Include slashes as part of a word
set mousemoveevent            " Enable hover events.
set confirm                   " Auto confirm.


" Persistent undo.
if has('persistent_undo')
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
  endif
  set undofile                 " Save undo after file closes.
  set undodir=~/.vim/undo      " Where to save undo histories.
  set undolevels=10000         " How many undoes to remember.
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
set spelloptions+=camel
if exists('+spelloptions') && has('nvim')
  set spelloptions+=noplainbuffer
endif
set nospell                  " Disable spell checking by default.
set spelllang=en_au          " Set the spell checking language.
set cursorline               " Highlight line of the cursor.
set showcmd                  " Show (partial) command being typed.
set showmode                 " Show current mode.
set tags=./tags,tags;
set clipboard=unnamedplus    " Use OS clipboard register by default.
set history=10000            " Number of commands remembered.
set nosmartindent            " Doesn't work well with treesitter.
set autoindent               " Auto-indent inserted lines.
set magic                    " Enable extended regex.
set copyindent               " Use current line indenting when starting a new line.
set foldmethod=indent        " Fold based on indent.
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

" This will show the popup menu (menu) even if there's only one match
" (menuone), and show a preview (preview) if there's documentation related.
set completeopt=menu,menuone,preview

set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " Completion ignore patterns.
set wildignore+=*.min.css,*.min.js        " Completion ignore patterns.

set smarttab                   " Emulate tab behaviour with spaces.
set expandtab                  " Tabs are spaces.
set shiftwidth=2               " Spaces per tab.
set softtabstop=2              " Number of spaces in tab when editing.
set tabstop=2                  " Number of visual spaces per tab.
set display+=lastline          " Display as much as possible of last line in window, '@@@' when truncated.
set ruler                      " Show the line and column number of the cursor position.
set viminfo^=%                 " Remember info about open buffers on close.
set t_RV=                      " Temporary fix prevents unexpected keypresses on startup.
set ttyfast                    " Send more characters for redraws.
set mouse=ar                   " Enable mouse use in all modes.
set backspace=indent,eol,start " Allow backspacing over autoindent, line breaks and start of insert action.
set synmaxcol=250              " Don't try to highlight long lines.
set fillchars=eob:\ ,fold:\ ,foldopen:,foldsep:\ ,foldclose:
set laststatus=2               " Always show the status line.

set foldenable
set foldcolumn=1
set foldlevelstart=999
set foldlevel=999
if has('nvim')
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
else
  set foldmethod=manual
endif

" Use a block cursor by default, i-beam cursor in insert mode, and underline cursor in replace mode.
set guicursor=a:block-nCursor,i:ver25-Cursor,r-cr-o:hor20
if empty($TMUX)
  let &t_SI = "\<esc>[5 q"
  let &t_SR = "\<esc>[5 q"
  let &t_EI = "\<esc>[2 q"
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
if !has('nvim')
  let &termencoding = &encoding
endif
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

set termguicolors

" Show a command's effects incrementally, as you type.
if has('nvim')
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
let g:python_recommended_style = 0


" ========================================================================
" Language Provider Settings.                                            |
" ========================================================================

let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0


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

" Repeat f, F, T, t commands.
noremap \ ;

" Easier EX mode.
nmap ; :

" Do not jump back to where you started after yanking.
vmap y ygv<Esc>

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

" Conceal lavel.
nmap <Leader>cl0 :setlocal conceallevel=0<CR>
nmap <Leader>cl1 :setlocal conceallevel=1<CR>
nmap <Leader>cl2 :setlocal conceallevel=2<CR>
nmap <Leader>cl3 :setlocal conceallevel=3<CR>

" Disable arrow keys. Get off my lawn.
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>

" Disable Ex mode.
nnoremap Q <NOP>

" Easier way to move between windows.
" map <C-k> <C-W>k
" map <C-j> <C-W>j
" map <C-h> <C-W>h
" map <C-l> <C-W>l

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
  exec 'silent! edit ' . resolvedfile
endfunction
augroup follow_symlink
  autocmd!
  autocmd BufReadPost * call FollowSymlink(expand('<afile>'))
augroup END

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
  autocmd BufRead,BufNewFile *.tftpl     setlocal filetype=terraform
  autocmd BufRead,BufNewFile *.tf        setlocal filetype=terraform

  " Typescript/React.
  " autocmd BufRead,BufNewFile *.jsx setlocal filetype=javascriptreact.javascript
  " autocmd BufRead,BufNewFile *.js  setlocal filetype=javascriptreact.javascript
  " autocmd BufRead,BufNewFile *.ts  setlocal filetype=typescriptreact.typescript
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
  call delete(expand('~/Desktop/profile.log'))
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
  if colorscheme_index >= len(colorschemes)
    echo 'if colorscheme_index >= len(colorschemes)'
    let colorscheme_index = 0
  endif
  let new_colorscheme = colorschemes[colorscheme_index]
  execute ':colorscheme ' . new_colorscheme
  echo new_colorscheme
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
autocmd FileType qf call AdjustWindowHeight(3, 10)
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

" Wipe all deleted (unloaded & unlisted) or all unloaded buffers.
function! BufferWipeoutAll(listed)
    let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded && (!v.listed || a:listed)})
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
    endif
endfunction


" ========================================================================
" Commands.                                                              |
" ========================================================================

" Custom commands.
command! -bar BufferWipeoutAll call BufferWipeoutAll(<bang>0)
command! -bar NextColorScheme call NextColorScheme()
command! -bar NextFont call NextFont()
if executable('yq')
  command! -bar FormatJson :%!yq -oj eval .
elseif executable('python3')
  command! -bar FormatJson :%!python3 -m json.tool
endif
command! -bar FormatXml :%!xmllint --format --recover -
command! -bar CopyMessages redir @+ | silent messages | redir END



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

let g:better_whitespace_filetypes_blacklist=['lspsagafinder', 'mason']

" Import Lua plugin configs.
if has('nvim')
  " Load core configuration
  lua require('core.settings').setup()
  lua require('core.keymaps').setup()
  lua require('core.autocmds').setup()
  lua require('core.commands')

  if !exists('g:use_coc') || !g:use_coc
    lua require('core.diagnostic')
    lua require('plugins.cmp')
    lua require('plugins.mason')
    lua require('core.lsp')
    " lua require('plugins.nvim-lint')
    " lua require('plugins.conform')
    " lua require('plugins.mason-conform')
    " lua require('plugins.mason-nvim-lint')
    lua require('plugins.copilot-lua')
    lua require('plugins.nvim-navbuddy')
    lua require('plugins.lspsaga')
    lua require('plugins.trouble')
    lua require('plugins.actions-preview')
    lua require('plugins.none-ls')
    lua require('plugins.mason-null-ls')
    " lua require('plugins.roslyn')
  endif

  augroup LazyLoadLua
    autocmd!
    autocmd VimEnter * ++once lua require('nvim-web-devicons').setup({})
    autocmd VimEnter * ++once lua require('plugins.printer')
    autocmd VimEnter * ++once lua require('plugins.neotest')
    autocmd VimEnter * ++once lua require('plugins.code_runner')
    autocmd VimEnter * ++once lua require('plugins.treesj')
    autocmd VimEnter * ++once lua require('plugins.regexplainer')
    " autocmd VimEnter * ++once lua require('plugins.notify')
    " autocmd VimEnter * ++once lua require('plugins.noice')
    autocmd VimEnter * ++once lua require('plugins.luasnip')
    autocmd VimEnter * ++once lua require('plugins.whitespace')
    autocmd VimEnter * ++once lua require('plugins.todo-comments')
    autocmd VimEnter * ++once lua require('plugins.bufferline')
    autocmd VimEnter * ++once lua require('plugins.lualine')
    autocmd VimEnter * ++once lua require('plugins.treesitter')
    autocmd VimEnter * ++once lua require('plugins.telescope')
    autocmd VimEnter * ++once lua require('plugins.telescope-file-browser')
    autocmd VimEnter * ++once lua require('plugins.leap')
    autocmd VimEnter * ++once lua require('plugins.tabout')
    autocmd VimEnter * ++once lua require('colorizer').setup({ '*' })
    autocmd VimEnter * ++once lua require('gruvbox').setup()
    autocmd VimEnter * ++once lua require('plugins.nvim-ufo')
    autocmd VimEnter * ++once lua require('nvim-surround').setup({})
    autocmd VimEnter * ++once lua require('ibl').setup()
    autocmd VimEnter * ++once lua require('plugins.statuscol')
    autocmd VimEnter * ++once lua require('plugins.package-info')
    autocmd VimEnter * ++once lua require('plugins.dial')
    autocmd VimEnter * ++once lua require('plugins.ts-node-action')
    autocmd VimEnter * ++once lua require('plugins.nvim-ts-autotag')
    autocmd VimEnter * ++once lua require('ts_context_commentstring').setup({})
    autocmd VimEnter * ++once lua require('plugins.vscode-diff')
  augroup END
endif

let g:Hexokinase_highlighters = ['backgroundfull']

let g:embark_terminal_italics = 1

let g:indexed_search_mappings = 0

" Move line up.
" nnoremap <Esc><Up> :m .-2<CR>==
" vnoremap <Esc><Down> :m '>+1<CR>gv=gv
" vnoremap <Esc><Up> :m '<-2<CR>gv=gv
"
" " Move line down.
" nnoremap <M-j> :m .+1<CR>==       " Meta notation
"
" " Move selection up.
" vnoremap <M-j> :m '>+1<CR>gv=gv
" vnoremap ∆ :m '>+1<CR>gv=gv
"
" " Move selection down.
" vnoremap <M-k> :m '<-2<CR>gv=gv
" vnoremap ˚ :m '<-2<CR>gv=gv
"
" GitGutter.
let g:gitgutter_max_signs               = 1000 " Bump up from default 500.
let g:gitgutter_sign_added              = '┃+'
let g:gitgutter_sign_modified           = '┃…'
let g:gitgutter_sign_modified_removed   = '┃±'
let g:gitgutter_sign_removed            = '┃−'
let g:gitgutter_sign_removed_first_line = '┃⇈'
let g:gitgutter_map_keys                = 0
highlight clear SignColumn

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
  \ '@yaegassy/coc-intelephense',
  \ '@yaegassy/coc-phpstan',
  \ '@yaegassy/coc-pylsp',
  \ 'coc-cfn-lint',
  \ 'coc-copilot',
  \ 'coc-css',
  \ 'coc-diagnostic',
  \ 'coc-dictionary',
  \ 'coc-docker',
  \ 'coc-eslint',
  \ 'coc-fzf-preview',
  \ 'coc-html',
  \ 'coc-html-css-support',
  \ 'coc-htmlhint',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-lightbulb',
  \ 'coc-lua',
  \ 'coc-markdownlint',
  \ 'coc-omni',
  \ 'coc-pairs',
  \ 'coc-php-cs-fixer',
  \ 'coc-psalm',
  \ 'coc-pydocstring',
  \ 'coc-pyright',
  \ 'coc-python',
  \ 'coc-sh',
  \ 'coc-sql',
  \ 'coc-stylua',
  \ 'coc-sumneko-lua',
  \ 'coc-syntax',
  \ 'coc-tag',
  \ 'coc-tsserver',
  \ 'coc-ultisnips',
  \ 'coc-vimlsp',
  \ 'coc-word',
  \ 'coc-xml',
  \ 'coc-yaml',
  \ ]

" vim-instant-markdown.
let g:instant_markdown_autostart = 0

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


" ========================================================================
" Theme Settings.                                                        |
" ========================================================================

" Gruvbox.
let g:gruvbox_contrast_dark = 'hard'


" ========================================================================
" Plugin Mappings.                                                       |
" ========================================================================

" if has_key(g:plugs, 'nvim-lspconfig') && !has_key(g:plugs, 'telescope.nvim')
"   nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
"   nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
"   nmap <silent> gt :lua vim.lsp.buf.type_definition()<CR>
"   nmap <silent> gr :lua vim.lsp.buf.references()<CR>
"   nmap <Leader>ic :lua vim.lsp.buf.incoming_calls()<CR>
"   nmap <Leader>oc :lua vim.lsp.buf.outgoing_calls()<CR>
" endif
"
" if !has_key(g:plugs, 'coc.nvim') && has_key(g:plugs, 'nvim-lspconfig')
"   nmap <silent> K :lua vim.lsp.buf.hover()<CR>
"   nmap <silent> [d :lua vim.diagnostic.goto_prev({ desc = 'Go to previous diagnostic message' })<CR>
"   nmap <silent> ]d :lua vim.diagnostic.goto_next({ desc = 'Go to next diagnostic message' })<CR>
"   nmap <silent> [e :lua vim.diagnostic.goto_prev({ desc = 'Go to previous error message', severity = vim.diagnostic.severity.ERROR })<CR>
"   nmap <silent> ]e :lua vim.diagnostic.goto_next({ desc = 'Go to next error message', severity = vim.diagnostic.severity.ERROR })<CR>
"   nmap <silent> [w :lua vim.diagnostic.goto_prev({ desc = 'Go to previous error message', severity = vim.diagnostic.severity.WARN })<CR>
"   nmap <silent> ]w :lua vim.diagnostic.goto_next({ desc = 'Go to next error message', severity = vim.diagnostic.severity.WARN })<CR>
"   nmap <silent> [w :lua vim.diagnostic.goto_prev({ desc = 'Go to previous error message', severity = vim.diagnostic.severity.WARN })<CR>
"   nmap <silent> ]w :lua vim.diagnostic.goto_next({ desc = 'Go to next error message', severity = vim.diagnostic.severity.WARN })<CR>
"   nmap <silent> gf :lua vim.lsp.buf.format()<CR>
"   nmap <silent> [[ :lua vim.diagnostic.disable()<CR>
"   nmap <silent> ]] :lua vim.diagnostic.enable()<CR>
" end

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

  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
  " remap for complete to use tab and <cr>
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  inoremap <silent><expr> <C-space> coc#refresh()

  " Use <Enter> to confirm completion.
  " inoremap <silent><expr> <c-@> coc#refresh()

  " LSP.
  nnoremap <silent> gd <Plug>(coc-definition)
  nnoremap <silent> gi <Plug>(coc-implementation)
  nnoremap <silent> gt <Plug>(coc-type-definition)
  nnoremap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  nnoremap <Leader>rn <Plug>(coc-rename)
  nnoremap <Leader>ca <Plug>(coc-codeaction)
  nnoremap <silent> [d <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]d <Plug>(coc-diagnostic-next)
  nnoremap <Leader>ic :call CocAction('showIncomingCalls')
  nnoremap <silent> gf <Plug>(coc-format)
end

if has_key(g:plugs, 'telescope-file-browser.nvim')
  nnoremap <Leader>fb :Telescope file_browser<CR>
endif

nnoremap <A-h> :SidewaysLeft<cr>
nnoremap <A-l> :SidewaysRight<cr>
nnoremap <A-h> :SidewaysLeft<cr>
nnoremap ˙ :SidewaysLeft<cr> " Unicode character (Option+h on Mac)
nnoremap ¬ :SidewaysLeft<cr> " Unicode character (Option+l on Mac)

" Start interactive EasyAlign in visual mode (e.g. vipga).
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>).
vmap <Enter> <Plug>(EasyAlign)


" ========================================================================
" Plugin Autocommands.                                                   |
" ========================================================================

" AutoClose. Disable for VimL files.
autocmd FileType vim let b:AutoCloseOn = 0

autocmd FileType sagacodeaction nnoremap <buffer> <ESC> :bw<CR>
autocmd FileType sagarename nnoremap <buffer> <ESC> :bw<CR>

autocmd FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Show signature help on placeholder jump.
if has_key(g:plugs, 'coc.nvim')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
endif

" Fugitive.
autocmd BufRead fugitive://* setlocal norelativenumber

" startify. Disable folding on the start screen.
autocmd FileType startify setlocal nofoldenable

" Strip whitespace on save.
if has_key(g:plugs, 'whitespace.nvim')
  autocmd BufWritePre * lua require('whitespace-nvim').trim()
elseif has_key(g:plugs, 'vim-better-whitespace')
  autocmd BufWritePre * StripWhitespace
endif



" ========================================================================
" Import local after .vimrc `~/.vimrc.after.local`.                      |
" ========================================================================

if filereadable(expand('~/.vimrc.after.local'))
  source ~/.vimrc.after.local
endif
