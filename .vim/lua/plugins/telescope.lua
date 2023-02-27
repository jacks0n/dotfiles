local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = actions.close,
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
      }
    },
    path_display = function(_, path)
      local tail = require'telescope.utils'.path_tail(path)
      local fullPath = string.format('%s (%s)', tail, path)
      return string.gsub(fullPath, os.getenv('HOME') or '', '~')
    end
  },
})

telescope.load_extension('fzf')
telescope.load_extension('frecency')

local M = {}
M.git_files_all = function()
  local git_opts = { git_command = { 'git', 'ls-files', '--modified', '--cached', '--deduplicate', '--others' } }
  local ok = pcall(require'telescope.builtin'.git_files, git_opts)
  if not ok then
    require'telescope.builtin'.find_files({})
  end
end

M.project_files = function()
  local git_opts = { git_command = { 'git', 'ls-files', '--modified', '--cached', '--deduplicate' } }
  local ok = pcall(require'telescope.builtin'.git_files, git_opts)
  if not ok then
    require'telescope.builtin'.find_files({})
  end
end

return M
