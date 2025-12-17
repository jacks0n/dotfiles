local ts = require('nvim-treesitter')
local ts_textobjects = require('nvim-treesitter-textobjects')

local config = {
  ignore_install = { 'rnoweb' },
  indent_disabled = { python = true, yaml = true },
}

-- Setup nvim-treesitter (optional, defaults are fine)
ts.setup({})

-- Setup textobjects
ts_textobjects.setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

-- Install all parsers (run manually via :TSInstallAll [--force])
local function install_all(opts)
  local force = opts.bang or vim.tbl_contains(opts.fargs, '--force')
  local installed = ts.get_installed()
  local available = ts.get_available()
  local to_install = {}
  for _, parser in ipairs(available) do
    if vim.tbl_contains(config.ignore_install, parser) then
      -- Skip ignored parsers
    elseif force or not vim.tbl_contains(installed, parser) then
      table.insert(to_install, parser)
    end
  end
  if #to_install > 0 then
    ts.install(to_install)
  end
end

vim.api.nvim_create_user_command('TSInstallAll', install_all, {
  desc = 'Install all treesitter parsers (--force to reinstall)',
  bang = true,
  nargs = '?',
})

-- Enable treesitter highlighting for all filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
  callback = function(args)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end
    pcall(vim.treesitter.start)
  end,
})

-- Enable treesitter indentation (except for unreliable filetypes)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterIndent', { clear = true }),
  callback = function(args)
    if not config.indent_disabled[vim.bo[args.buf].filetype] then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Textobjects keymaps
local move = require('nvim-treesitter-textobjects.move')
local select = require('nvim-treesitter-textobjects.select')
local swap = require('nvim-treesitter-textobjects.swap')

-- Move mappings
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
  move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
  move.goto_next_start('@class.outer', 'textobjects')
end, { desc = 'Next class start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
  move.goto_next_start('@scope', 'locals')
end, { desc = 'Next scope' })

vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
  move.goto_next_start('@fold', 'folds')
end, { desc = 'Next fold' })

vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
  move.goto_next_start('@parameter.outer', 'textobjects')
end, { desc = 'Next parameter' })

vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
  move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
  move.goto_previous_start('@class.outer', 'textobjects')
end, { desc = 'Previous class start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[s', function()
  move.goto_previous_start('@scope', 'locals')
end, { desc = 'Previous scope' })

vim.keymap.set({ 'n', 'x', 'o' }, '[z', function()
  move.goto_previous_start('@fold', 'folds')
end, { desc = 'Previous fold' })

vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
  move.goto_previous_start('@parameter.outer', 'textobjects')
end, { desc = 'Previous parameter' })

-- Swap mappings
vim.keymap.set('n', '<C-Right>', function()
  swap.swap_next('@parameter.inner')
end, { desc = 'Swap next parameter' })

vim.keymap.set('n', '<C-Left>', function()
  swap.swap_previous('@parameter.inner')
end, { desc = 'Swap previous parameter' })

-- Select mappings
vim.keymap.set({ 'x', 'o' }, 'fo', function()
  select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Select outer function' })

vim.keymap.set({ 'x', 'o' }, 'fi', function()
  select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Select inner function' })

vim.keymap.set({ 'x', 'o' }, 'co', function()
  select.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Select outer class' })

vim.keymap.set({ 'x', 'o' }, 'ci', function()
  select.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Select inner class' })

vim.keymap.set({ 'x', 'o' }, 'ts', function()
  select.select_textobject('@scope', 'locals')
end, { desc = 'Select language scope' })
