-- Autocommands
local M = {}

M.setup = function()
  -- Create augroups
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  -- Highlight yank
  augroup('YankHighlight', { clear = true })
  autocmd('TextYankPost', {
    group = 'YankHighlight',
    pattern = '*',
    callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
  })

  -- Auto change directory
  augroup('AutoChdir', { clear = true })
  autocmd('BufEnter', {
    group = 'AutoChdir',
    pattern = '*',
    callback = function()
      if vim.bo.buftype ~= 'terminal' then
        local dir = vim.fn.expand('%:p:h')
        if vim.fn.isdirectory(dir) == 1 then
          vim.cmd('silent! lcd ' .. vim.fn.fnameescape(dir))
        end
      end
    end,
  })

  -- Follow symlinks (cache resolved paths)
  local symlink_cache = {}
  augroup('FollowSymlink', { clear = true })
  autocmd('BufReadPost', {
    group = 'FollowSymlink',
    pattern = '*',
    callback = function()
      local file = vim.fn.expand('<afile>')
      if file:match('^%w+://') then
        return
      end
      file = vim.fn.simplify(file)
      
      -- Check cache first
      if symlink_cache[file] then
        if symlink_cache[file] ~= file then
          vim.cmd('silent! edit ' .. vim.fn.fnameescape(symlink_cache[file]))
        end
        return
      end
      
      local resolved = vim.fn.resolve(file)
      symlink_cache[file] = resolved
      if resolved ~= file then
        vim.cmd('silent! edit ' .. vim.fn.fnameescape(resolved))
      end
    end,
  })

  -- Cursor line only in active window
  augroup('CursorLine', { clear = true })
  autocmd({ 'InsertLeave', 'WinEnter' }, {
    group = 'CursorLine',
    pattern = '*',
    command = 'set cursorline',
  })
  autocmd({ 'InsertEnter', 'WinLeave' }, {
    group = 'CursorLine',
    pattern = '*',
    command = 'set nocursorline',
  })

  -- Custom filetypes
  augroup('CustomFiletypes', { clear = true })
  -- Drupal
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = { '*.info', '*.engine', '*.inc', '*.install', '*.module', '*.profile', '*.test', '*.theme', '*.view' },
    command = 'setlocal filetype=php',
  })
  -- Other
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = '*.plist',
    command = 'setlocal filetype=xml',
  })
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = '*.scss',
    command = 'setlocal filetype=scss.css',
  })
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = '*.ipynb',
    command = 'setlocal filetype=python',
  })
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = '*.yml.dist',
    command = 'setlocal filetype=yaml',
  })
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = 'Jenkinsfile',
    command = 'setlocal filetype=groovy',
  })
  autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'CustomFiletypes',
    pattern = { '*.tftpl', '*.tf' },
    command = 'setlocal filetype=terraform',
  })

  -- Iskeyword modifications
  augroup('IskeywordMods', { clear = true })
  autocmd('FileType', {
    group = 'IskeywordMods',
    pattern = { 'css', 'scss', 'sass' },
    command = 'setlocal iskeyword+=-',
  })

  -- Comment strings
  augroup('CommentStrings', { clear = true })
  autocmd('FileType', {
    group = 'CommentStrings',
    pattern = 'apache',
    command = 'setlocal commentstring=#\\ %s',
  })
  autocmd('FileType', {
    group = 'CommentStrings',
    pattern = 'terraform',
    command = 'setlocal commentstring=#\\ %s',
  })
  autocmd('FileType', {
    group = 'CommentStrings',
    pattern = 'yaml',
    command = 'setlocal commentstring=#\\ %s',
  })
  autocmd('FileType', {
    group = 'CommentStrings',
    pattern = 'vim',
    command = 'setlocal commentstring="\\ %s',
  })

  -- Restore cursor position
  augroup('RestorePosition', { clear = true })
  autocmd('BufReadPost', {
    group = 'RestorePosition',
    pattern = '*',
    callback = function()
      local line = vim.fn.line("'\"")
      if line > 0 and line <= vim.fn.line('$') then
        vim.cmd('normal! g`"')
      end
    end,
  })

  -- Adjust quickfix window height
  augroup('QuickfixHeight', { clear = true })
  autocmd('FileType', {
    group = 'QuickfixHeight',
    pattern = 'qf',
    callback = function()
      local lines = vim.fn.line('$')
      local height = math.max(math.min(lines, 10), 3)
      vim.cmd(height .. 'wincmd _')
    end,
  })

  -- Disable search highlighting in command line
  if vim.fn.has('nvim') == 1 then
    autocmd('CmdlineEnter', {
      pattern = { '/', '?' },
      command = 'set nohlsearch',
    })
    autocmd('CmdlineLeave', {
      pattern = { '/', '?' },
      command = 'set hlsearch',
    })
  end

  -- FZF specific settings
  if vim.fn.has('nvim') == 1 then
    augroup('FZF', { clear = true })
    autocmd('FileType', {
      group = 'FZF',
      pattern = 'fzf',
      command = 'tnoremap <buffer> <Esc> <Esc>',
    })
  end

  -- Disable folding on start screen
  augroup('StartifyFold', { clear = true })
  autocmd('FileType', {
    group = 'StartifyFold',
    pattern = 'startify',
    command = 'setlocal nofoldenable',
  })

  -- Fugitive settings
  augroup('Fugitive', { clear = true })
  autocmd('BufRead', {
    group = 'Fugitive',
    pattern = 'fugitive://*',
    command = 'setlocal norelativenumber',
  })
end

return M