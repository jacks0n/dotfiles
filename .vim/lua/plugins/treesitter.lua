local ts = require('nvim-treesitter')

local config = {
  -- Parsers kept installed by :TSInstallAll and the vim-plug `do` hook.
  -- nvim-treesitter's main branch has no ensure_installed and installs nothing
  -- on its own, so this list is the source of truth. Anything absent can still
  -- be pulled in ad hoc with :TSInstall <lang>.
  ensure_installed = {
    -- Languages with an LSP server or linter configured (core/lsp.lua,
    -- core/linters.lua). jsonc, sh and zsh are covered by json and bash.
    'bash', 'c', 'c_sharp', 'cpp', 'css', 'dockerfile', 'go', 'html', 'java',
    'javascript', 'json', 'lua', 'markdown', 'php', 'python', 'rust', 'scss',
    'sql', 'terraform', 'tsx', 'typescript', 'vim', 'xml', 'yaml',
    -- Companions to the above.
    'gomod', 'gosum', 'hcl', 'groovy', -- groovy: Jenkinsfile, see init.vim
    -- Injected into the languages above, or used by Neovim itself.
    'comment', 'jsdoc', 'luadoc', 'markdown_inline', 'phpdoc', 'query',
    'regex', 'vimdoc',
    -- Git.
    'diff', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore',
    -- Config formats in this repo.
    'csv', 'editorconfig', 'ini', 'kdl', 'make', 'ssh_config', 'toml',
  },
  indent_disabled = { python = true, yaml = true },
}

local function is_headless()
  return #vim.api.nvim_list_uis() == 0
end

local function get_installable_parsers()
  local installed = ts.get_installed()
  local to_install = {}

  for _, parser in ipairs(config.ensure_installed) do
    if not vim.tbl_contains(installed, parser) then
      table.insert(to_install, parser)
    end
  end
  return to_install
end

-- Install the parsers listed above (run via :TSInstallAll [--force]).
-- --force reinstalls everything, which also repairs a parser left half-written
-- by an interrupted install (a .so with no matching parser-info/*.revision --
-- one of those makes :TSUpdate fail for every language, not just that one).
local function install_all(opts)
  local force = opts.bang or vim.tbl_contains(opts.fargs, '--force')
  local headless = is_headless()

  local to_install = force and vim.list_extend({}, config.ensure_installed)
    or get_installable_parsers()

  if #to_install == 0 then
    vim.notify('Treesitter: all parsers already installed', vim.log.levels.INFO)
    return
  end

  vim.notify('Treesitter: installing ' .. #to_install .. ' parsers...', vim.log.levels.INFO)

  -- force has to be passed through: install() skips any language that already
  -- has a parser .so, so without this --force silently does nothing.
  local task = ts.install(to_install, { force = force })

  -- Block when headless so `nvim --headless -c TSInstallAll -c qa!` and the
  -- vim-plug `do` hook both run to completion. Quitting is left to the caller:
  -- this also runs as a post-update hook, where a qa! here would abandon the
  -- rest of the PlugUpdate.
  if headless then
    task:wait()
    vim.notify('Treesitter: completed installing parsers', vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command('TSInstallAll', install_all, {
  desc = 'Install the configured treesitter parsers (--force to reinstall)',
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

-- Textobjects blows up in buffers with no parser: its find_best_range() returns
-- an empty table (truthy) rather than nil, so the caller ends up comparing two
-- nil scores. Skip the motion entirely instead of throwing a stack trace.
local function with_parser(fn, ...)
  local args = { ... }
  return function()
    -- get_parser returns nil plus a message rather than throwing.
    local parser, err = vim.treesitter.get_parser(0)
    if not parser then
      vim.notify(err, vim.log.levels.WARN)
      return
    end
    fn(unpack(args))
  end
end

-- Move mappings
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']f',
  with_parser(move.goto_next_start, '@function.outer', 'textobjects'),
  { desc = 'Next function start' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  ']c',
  with_parser(move.goto_next_start, '@class.outer', 'textobjects'),
  { desc = 'Next class start' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  ']s',
  with_parser(move.goto_next_start, '@scope', 'locals'),
  { desc = 'Next scope' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  ']z',
  with_parser(move.goto_next_start, '@fold', 'folds'),
  { desc = 'Next fold' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  ']p',
  with_parser(move.goto_next_start, '@parameter.outer', 'textobjects'),
  { desc = 'Next parameter' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  '[f',
  with_parser(move.goto_previous_start, '@function.outer', 'textobjects'),
  { desc = 'Previous function start' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  '[c',
  with_parser(move.goto_previous_start, '@class.outer', 'textobjects'),
  { desc = 'Previous class start' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  '[s',
  with_parser(move.goto_previous_start, '@scope', 'locals'),
  { desc = 'Previous scope' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  '[z',
  with_parser(move.goto_previous_start, '@fold', 'folds'),
  { desc = 'Previous fold' }
)

vim.keymap.set(
  { 'n', 'x', 'o' },
  '[p',
  with_parser(move.goto_previous_start, '@parameter.outer', 'textobjects'),
  { desc = 'Previous parameter' }
)

-- Swap mappings
vim.keymap.set(
  'n',
  '<C-Right>',
  with_parser(swap.swap_next, '@parameter.inner'),
  { desc = 'Swap next parameter' }
)

vim.keymap.set(
  'n',
  '<C-Left>',
  with_parser(swap.swap_previous, '@parameter.inner'),
  { desc = 'Swap previous parameter' }
)

-- Select mappings
vim.keymap.set(
  { 'x', 'o' },
  'fo',
  with_parser(select.select_textobject, '@function.outer', 'textobjects'),
  { desc = 'Select outer function' }
)

vim.keymap.set(
  { 'x', 'o' },
  'fi',
  with_parser(select.select_textobject, '@function.inner', 'textobjects'),
  { desc = 'Select inner function' }
)

vim.keymap.set(
  { 'x', 'o' },
  'co',
  with_parser(select.select_textobject, '@class.outer', 'textobjects'),
  { desc = 'Select outer class' }
)

vim.keymap.set(
  { 'x', 'o' },
  'ci',
  with_parser(select.select_textobject, '@class.inner', 'textobjects'),
  { desc = 'Select inner class' }
)

vim.keymap.set(
  { 'x', 'o' },
  'ts',
  with_parser(select.select_textobject, '@scope', 'locals'),
  { desc = 'Select language scope' }
)
