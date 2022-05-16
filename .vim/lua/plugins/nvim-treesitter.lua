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

    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  -- @see https://github.com/p00f/nvim-ts-rainbow
  rainbow = {
    enable = true,
    -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean.
    extended_mode = true,
    -- Do not enable for files with more than n lines, int.
    max_file_lines = 10000,
  },

  -- @see https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true
  }
}
