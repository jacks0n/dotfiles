require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  auto_install = true,

  markid = { enable = true },

  -- ipkg is gone.
  ignore_install = { 'ipkg' },
  modules = {},

  sync_install = false,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,

    disable = function(_lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  indent = {
    enable = true,
    -- Unreliable.
    disable = { 'python', 'yaml' },
  },

  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    highlight_current_scope = {
      enable = false,
    },
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next = {
        [']f'] = { query = '@function.outer', desc = 'Next function start' },
        [']c'] = { query = '@class.outer', desc = 'Next class start' },
        [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
        [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
        [']p'] = { query = '@parameter.outer', desc = 'Next parameter' },
      },
      goto_previous = {
        ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
        ['[c'] = { query = '@class.outer', desc = 'Next class start' },
        ['[s'] = { query = '@scope', query_group = 'locals', desc = 'Previous scope' },
        ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
        ['[p'] = { query = '@parameter.outer', desc = 'Previous parameter' },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<C-Right>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<C-Left>'] = '@parameter.inner',
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['fo'] = '@function.outer',
        ['fi'] = '@function.inner',
        ['co'] = '@class.outer',
        ['ci'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
        ['ts'] = { query = '@scope', desc = 'Select language scope' },
      },
    },
  },
})
