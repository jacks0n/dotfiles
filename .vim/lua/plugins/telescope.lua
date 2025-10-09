local actions = require('telescope.actions')
local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local utils = require('core.utils')

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
  defaults = {
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    -- Show hidden files.
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    mappings = {
      i = {
        ['<Esc>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-gg>'] = actions.move_to_top,
        ['<C-G>'] = actions.move_to_bottom,
        ['<Tab>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<S-Tab>'] = actions.move_selection_previous,
      },
    },
    layout_config = {
      vertical = {
        width = 0.85,
        height = 0.85,
      },
      horizontal = {
        width = 0.85,
        height = 0.85,
      },
    },
    -- path_display = function(_, path)
    --   local tail = telescope_utils.path_tail(path)
    --   local fullPath = string.format('%s (%s)', tail, path)
    --   return telescope_utils.path_display(string.gsub(fullPath, os.getenv('HOME') or '', '~'))
    -- end
  },
})

telescope.load_extension('fzf')

local M = {}

M.git_files_all = function()
  local git_opts = {
    git_command = { 'git', 'ls-files', '--modified', '--cached', '--others', '--deduplicate' },
    layout_strategy = 'vertical',
  }
  local ok = pcall(require('telescope.builtin').git_files, git_opts)
  if not ok then
    require('telescope.builtin').find_files({ layout_strategy = 'vertical' })
  end
end

M.grep_project = function()
  telescope_builtin.live_grep({ cwd = utils.project_dir(), layout_strategy = 'vertical' })
end

M.git_files_source = function()
  local git_opts = {
    git_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
    -- git_command = { 'git', 'ls-files', '--modified', '--cached', '--deduplicate', '--others', '--exclude-standard' },
    layout_strategy = 'vertical',
  }
  local ok = pcall(telescope_builtin.git_files, git_opts)
  if not ok then
    telescope_builtin.find_files({ layout_strategy = 'vertical' })
  end
end

vim.keymap.set('n', 'gs', function()
  telescope_builtin.lsp_workspace_symbols({
    query = '',
    layout_strategy = 'vertical',
    path_display = { 'smart' },
  })
end)

M.call_telescope_vertical = function(callback)
  return function()
    callback({ layout_strategy = 'vertical', path_display = { 'smart' }, show_line = true })
  end
end

return M
