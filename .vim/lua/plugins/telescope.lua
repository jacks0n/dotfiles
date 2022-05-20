local actions = require('telescope.actions')
local telescope = require('telescope')

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- or "ignore_case" or "respect_case"
                                      -- the default case_mode is "smart_case"
    }
  },
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
}

telescope.load_extension('fzf')
telescope.load_extension('frecency')

local M = {}
M.project_files = function()
  local git_opts = { git_command = { 'git', 'ls-files', '--modified', '--cached', '--deduplicate' } }
  local ok = pcall(require'telescope.builtin'.git_files, git_opts)
  if not ok then
    require'telescope.builtin'.find_files({})
  end
end

return M
