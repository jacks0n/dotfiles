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

    additional_vim_regex_highlighting = true,

    disable = { 'css' }
  },

  indent = {
    enable = true,
    disable = { 'json', 'typescript', 'javascript' },
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
