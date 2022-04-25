require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = 'all',

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- phpdoc isn't supported on Apple Silicon.
  -- @see https://github.com/tree-sitter/tree-sitter/issues/942
  ignore_install = { 'phpdoc' },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- CSS doesn't highlight the colours yet.
    disable = { 'css' },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
