-- Core Neovim settings
local M = {}

M.setup = function()
  -- Leader key
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- General settings
  vim.opt.autoread = true
  vim.opt.autowrite = true
  vim.opt.backup = true
  vim.opt.backupdir = vim.fn.expand('~/.vim/backup')
  vim.opt.backupskip = '/tmp/*,/private/tmp/*,~/tmp/*'
  vim.opt.writebackup = true

  -- Swap files
  vim.opt.directory = vim.fn.expand('~/.vim/swap') .. '//,/tmp//,~/tmp//'

  -- Persistent undo
  if vim.fn.has('persistent_undo') == 1 then
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.expand('~/.vim/undo')
    vim.opt.undolevels = 10000
    vim.opt.undoreload = 100000
  end

  -- Display settings
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.cursorline = true
  vim.opt.showcmd = true
  vim.opt.showmode = true
  vim.opt.showmatch = true
  vim.opt.ruler = true
  vim.opt.laststatus = 2
  vim.opt.signcolumn = 'yes'

  -- Search settings
  vim.opt.hlsearch = true
  vim.opt.incsearch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Indentation
  vim.opt.autoindent = true
  vim.opt.smartindent = false -- Doesn't work well with treesitter
  vim.opt.cindent = true
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.tabstop = 2
  vim.opt.smarttab = true
  vim.opt.shiftround = true

  -- Folding
  vim.opt.foldenable = true
  vim.opt.foldcolumn = '1'
  vim.opt.foldlevel = 999
  vim.opt.foldlevelstart = 999
  if vim.fn.has('nvim') == 1 then
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  else
    vim.opt.foldmethod = 'manual'
  end

  -- Completion
  vim.opt.completeopt = { 'menu', 'menuone', 'preview' }
  vim.opt.pumheight = 20
  vim.opt.wildmode = { 'longest', 'list', 'full' }
  vim.opt.wildmenu = true
  vim.opt.wildignorecase = true

  -- Behavior
  vim.opt.hidden = true
  vim.opt.confirm = true
  vim.opt.mouse = 'a'
  vim.opt.clipboard = 'unnamedplus'
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.scrolloff = 1
  vim.opt.sidescrolloff = 5
  vim.opt.updatetime = 300
  vim.opt.timeout = true
  vim.opt.timeoutlen = 1000
  vim.opt.ttimeout = true
  vim.opt.ttimeoutlen = 10

  -- Text formatting
  vim.opt.wrap = false
  vim.opt.textwidth = 0
  vim.opt.formatoptions:remove('t')
  vim.opt.formatoptions:append('c')
  vim.opt.formatoptions:append('r')
  vim.opt.formatoptions:append('o')
  vim.opt.formatoptions:append('q')
  vim.opt.formatoptions:append('n')
  vim.opt.formatoptions:append('j')

  -- Visual
  vim.opt.conceallevel = 0
  vim.opt.synmaxcol = 500 -- Increased from 250
  vim.opt.display:append('lastline')

  -- Listchars
  vim.opt.listchars = {
    tab = '→ ',
    trail = '·',
    eol = '↲',
    extends = '»',
    precedes = '«',
    nbsp = '⣿',
  }
  vim.opt.showbreak = '↪'

  -- Spell checking
  vim.opt.spell = false
  vim.opt.spelllang = 'en_us'
  if vim.fn.exists('+spelloptions') == 1 then
    vim.opt.spelloptions:append('camel')
    if vim.fn.has('nvim') == 1 then
      vim.opt.spelloptions:append('noplainbuffer')
    end
  end

  -- Terminal colors
  if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
  end

  -- Incremental command preview
  if vim.fn.exists('&inccommand') == 1 then
    vim.opt.inccommand = 'nosplit'
  end

  -- Disable some built-in plugins
  vim.g.loaded_matchparen = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_tar = 1

  -- Language providers
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_python_provider = 0
  vim.g.python3_host_prog = vim.fn.exepath('python3')

  -- Filetype settings
  vim.g.is_bash = 1
  vim.g.is_posix = 1
  vim.g.no_plugin_maps = 1
  vim.g.python_recommended_style = 0
end

return M
