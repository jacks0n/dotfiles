require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',

    attach = function(_, lang)
      print('attach: ' .. lang)
      if string.find(lang, 'typescript') then
        vim.api.nvim_command('setlocal indentexpr=v:lua.javascript_docblock_indent()')
        -- vim.cmd[[autocmd FileType javascript,typescript,typescriptreact.typescript setlocal indentexpr=v:lua.javascript_docblock_indent()]]
      end
    end,

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
}
