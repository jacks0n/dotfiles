local keymap = vim.keymap.set

local M = {}

M.setup = function()
  -- Better movement
  keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

  -- Window navigation
  keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
  keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
  keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
  keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

  -- Resize windows
  keymap('n', '<C-Up>', '<C-w>+', { desc = 'Increase window height' })
  keymap('n', '<C-Down>', '<C-w>-', { desc = 'Decrease window height' })
  keymap('n', '<C-Left>', '<C-w><', { desc = 'Decrease window width' })
  keymap('n', '<C-Right>', '<C-w>>', { desc = 'Increase window width' })

  -- Better indenting
  keymap('v', '<', '<gv', { desc = 'Indent left' })
  keymap('v', '>', '>gv', { desc = 'Indent right' })

  -- Move lines
  keymap('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
  keymap('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
  keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })
  keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })

  -- Better yank behavior
  keymap('v', 'y', 'ygv<Esc>', { desc = 'Yank without moving cursor' })
  keymap('v', 'Y', 'y$', { desc = 'Yank to end of line' })

  -- Search and replace
  keymap('n', '<Leader>/', ':noh<CR>', { desc = 'Clear search highlight' })
  keymap(
    'n',
    '<Leader>sr',
    ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
    { desc = 'Search and replace word under cursor' }
  )

  -- Quick save and quit
  keymap('n', '<Leader>w', ':w<CR>', { desc = 'Save file' })
  keymap('n', '<Leader>q', ':q<CR>', { desc = 'Quit' })
  keymap('n', '<Leader>Q', ':qa<CR>', { desc = 'Quit all' })

  -- Buffer navigation
  keymap('n', '<Leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
  keymap('n', '<Leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
  keymap('n', '<Leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })

  -- Tab navigation
  keymap('n', '<Leader>tn', ':tabnew<CR>', { desc = 'New tab' })
  keymap('n', '<Leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
  keymap('n', '<Leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })

  -- Toggle settings
  keymap('n', '<Leader>tw', ':set wrap!<CR>', { desc = 'Toggle word wrap' })
  keymap('n', '<Leader>ts', ':set spell!<CR>', { desc = 'Toggle spell check' })
  keymap('n', '<Leader>tn', ':set number!<CR>', { desc = 'Toggle line numbers' })
  keymap('n', '<Leader>tr', ':set relativenumber!<CR>', { desc = 'Toggle relative numbers' })

  -- File operations
  keymap('n', '<Leader>e', ':enew<CR>', { desc = 'New empty buffer' })
  keymap('n', '<Leader>v', ':edit $MYVIMRC<CR>', { desc = 'Edit vimrc' })
  keymap('n', '<Leader>z', ':edit ~/.zshrc<CR>', { desc = 'Edit zshrc' })

  -- Folding
  keymap('n', '<Leader>fl-', ':setlocal nofoldenable<CR>', { desc = 'Disable folding' })
  keymap('n', '<Leader>fl=', ':setlocal foldenable<CR>', { desc = 'Enable folding' })
  for i = 0, 9 do
    keymap('n', '<Leader>fl' .. i, ':setlocal foldlevel=' .. i .. '<CR>', { desc = 'Set fold level ' .. i })
  end

  -- Conceal level
  for i = 0, 3 do
    keymap('n', '<Leader>cl' .. i, ':setlocal conceallevel=' .. i .. '<CR>', { desc = 'Set conceal level ' .. i })
  end

  -- Better command line
  keymap('n', ';', ':', { desc = 'Enter command mode' })
  keymap('n', '\\', ';', { desc = 'Repeat f/t command' })

  -- Disable arrow keys in normal mode
  keymap('n', '<Up>', '<NOP>')
  keymap('n', '<Down>', '<NOP>')
  keymap('n', '<Left>', '<NOP>')
  keymap('n', '<Right>', '<NOP>')

  -- Disable Ex mode
  keymap('n', 'Q', '<NOP>')

  -- Keep cursor in place when joining lines
  keymap('n', 'J', 'mzJ`z', { desc = 'Join lines' })

  -- Keep cursor centered when scrolling
  keymap('n', '<C-d>', '<C-d>zz')
  keymap('n', '<C-u>', '<C-u>zz')
  keymap('n', 'n', 'nzzzv')
  keymap('n', 'N', 'Nzzzv')

  -- Better paste
  keymap('x', '<Leader>p', '"_dP', { desc = 'Paste without yanking' })

  -- System clipboard
  keymap('n', '<Leader>y', '"+y', { desc = 'Yank to system clipboard' })
  keymap('v', '<Leader>y', '"+y', { desc = 'Yank to system clipboard' })
  keymap('n', '<Leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
  keymap('n', '<Leader>p', '"+p', { desc = 'Paste from system clipboard' })
  keymap('n', '<Leader>P', '"+P', { desc = 'Paste from system clipboard before' })

  -- Quick fix navigation
  keymap('n', '[q', ':cprevious<CR>', { desc = 'Previous quickfix item' })
  keymap('n', ']q', ':cnext<CR>', { desc = 'Next quickfix item' })
  keymap('n', '<Leader>qo', ':copen<CR>', { desc = 'Open quickfix' })
  keymap('n', '<Leader>qc', ':cclose<CR>', { desc = 'Close quickfix' })

  -- Location list navigation
  keymap('n', '[l', ':lprevious<CR>', { desc = 'Previous location item' })
  keymap('n', ']l', ':lnext<CR>', { desc = 'Next location item' })
  keymap('n', '<Leader>lo', ':lopen<CR>', { desc = 'Open location list' })
  keymap('n', '<Leader>lc', ':lclose<CR>', { desc = 'Close location list' })

  -- Terminal
  keymap('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = 'Terminal left window nav' })
  keymap('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = 'Terminal down window nav' })
  keymap('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = 'Terminal up window nav' })
  keymap('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = 'Terminal right window nav' })
  keymap('t', '<Esc>', '<C-\\><C-n>', { desc = 'Terminal normal mode' })

  -- Set up diagnostic keymaps
  keymap('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
  keymap('n', '[d', function()
    vim.diagnostic.jump({ count = -1 })
  end, { desc = 'Go to previous diagnostic' })
  keymap('n', ']d', function()
    vim.diagnostic.jump({ count = 1 })
  end, { desc = 'Go to next diagnostic' })
  keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

  -- Toggle diagnostics
  vim.keymap.set('n', '[[', function()
    vim.diagnostic.enable(false)
  end, { desc = 'Disable diagnostics', noremap = true })
  vim.keymap.set('n', ']]', function()
    vim.diagnostic.enable(true)
  end, { desc = 'Enable diagnostics', noremap = true })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
      -- Undo the core ftplugin/markdown.lua mappings.
      vim.keymap.del('n', '[[', { buffer = true })
      vim.keymap.del('n', ']]', { buffer = true })

      -- Toggle diagnostics
      vim.keymap.set('n', '[[', function()
        vim.diagnostic.enable(false)
      end, { desc = 'Disable diagnostics', noremap = true })
      vim.keymap.set('n', ']]', function()
        vim.diagnostic.enable(true)
      end, { desc = 'Enable diagnostics', noremap = true })
    end,
  })

  -- Customize diagnostic severity navigation
  keymap('n', '[e', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Go to previous error' })

  keymap('n', ']e', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Go to next error' })

  keymap('n', '[w', function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
  end, { desc = 'Go to previous warning' })

  keymap('n', ']w', function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
  end, { desc = 'Go to next warning' })
end

return M
