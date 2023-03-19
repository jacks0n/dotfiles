require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',

  -- Install parsers synchronously (only applied to `ensure_installed`).
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- phpdoc isn't supported on Apple Silicon.
  -- @see https://github.com/tree-sitter/tree-sitter/issues/942
  ignore_install = { 'phpdoc' },

  highlight = {
    enable = true,

    -- CSS doesn't highlight the colours yet.
    disable = { 'css' },

    additional_vim_regex_highlighting = true,
  },

  indent = {
    enable = false,
    disable = { 'json' },
  },

  disable = function(_, buf)
    local max_filesize = 1000 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
  end,

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
      }
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
      -- include_surrounding_whitespace = true,
    },
  },
}