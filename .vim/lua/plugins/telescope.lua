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
    -- @todo Is this the default?
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
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
-- telescope.load_extension('frecency')
-- telescope.load_extension('noice')

local function git_files_all()
  local git_opts = {
    git_command = { 'git', 'ls-files', '--modified', '--cached', '--others', '--deduplicate' },
    layout_strategy = 'vertical',
  }
  local ok = pcall(require('telescope.builtin').git_files, git_opts)
  if not ok then
    require('telescope.builtin').find_files({ layout_strategy = 'vertical' })
  end
end

local function grep_project()
  telescope_builtin.live_grep({ cwd = utils.project_dir(), layout_strategy = 'vertical' })
end

local function git_files_source()
  local git_opts = {
    git_command = { 'git', 'ls-files', '--modified', '--cached', '--deduplicate', '--others', '--exclude-standard' },
    layout_strategy = 'vertical',
  }
  local ok = pcall(telescope_builtin.git_files, git_opts)
  if not ok then
    telescope_builtin.find_files({ layout_strategy = 'vertical' })
  end
end

vim.keymap.set('n', 'gs', function()
  local query = vim.fn.input('LSP Workspace Symbols❯ ')
  if query ~= '' then
    telescope_builtin.lsp_workspace_symbols({
      query = query,
      layout_strategy = 'vertical',
    })
  end
end)

local function call_telescope_vertical(callback)
  return function()
    callback({ layout_strategy = 'vertical', path_display = { 'smart' }, show_line = false })
  end
end

vim.keymap.set('n', 'gr', call_telescope_vertical(telescope_builtin.lsp_references), { desc = 'LSP references' })
vim.keymap.set(
  'n',
  'gt',
  call_telescope_vertical(telescope_builtin.lsp_type_definitions),
  { desc = 'LSP type definition(s)' }
)
vim.keymap.set('n', 'gd', call_telescope_vertical(telescope_builtin.lsp_definitions), { desc = 'LSP definition(s)' })
vim.keymap.set(
  'n',
  'gi',
  call_telescope_vertical(telescope_builtin.lsp_implementations),
  { desc = 'LSP implementation(s)' }
)
vim.keymap.set(
  'n',
  '<Leader>ic',
  call_telescope_vertical(telescope_builtin.lsp_incoming_calls),
  { desc = 'LSP incoming calls' }
)
vim.keymap.set(
  'n',
  '<Leader>oc',
  call_telescope_vertical(telescope_builtin.lsp_outgoing_calls),
  { desc = 'LSP outgoing calls' }
)
vim.keymap.set('n', '<Leader>b', call_telescope_vertical(telescope_builtin.buffers), { desc = 'LSP buffers' })
vim.keymap.set('n', '<C-t>', grep_project, { desc = 'Grep project' })
vim.keymap.set('n', '<Leader>h', git_files_source, { desc = 'Git source files' })
vim.keymap.set('n', '<C-g>', git_files_all, { desc = 'Git files (all)' })
vim.keymap.set('n', '<Leader>gg', grep_project, { desc = 'Git grep in project' })

-- Project switching with configurable workspaces
vim.keymap.set('n', '<Leader>p', function()
  local workspaces = vim.g.telescope_project_workspaces
  local dirs = {}

  -- Expand and collect all directories from workspaces
  for _, workspace in ipairs(workspaces) do
    local expanded = vim.fn.expand(workspace)
    if vim.fn.isdirectory(expanded) == 1 then
      table.insert(dirs, expanded)
    end
  end

  if #dirs == 0 then
    vim.notify('No valid project workspaces found', vim.log.levels.WARN)
    return
  end

  -- Use Telescope to find directories in workspaces
  telescope_builtin.find_files({
    search_dirs = dirs,
    prompt_title = 'Switch Project',
    layout_strategy = 'vertical',
    find_command = { 'fd', '--type', 'd', '--max-depth', '1' },
    attach_mappings = function(prompt_bufnr, map)
      local action_state = require('telescope.actions.state')
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          telescope_builtin.find_files({
            cwd = selection.value,
            layout_strategy = 'vertical',
          })
        end
      end)
      return true
    end,
  })
end, { desc = 'Switch project' })
