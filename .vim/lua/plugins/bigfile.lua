local default_config = {
  filesize = 2,
  pattern = { "*" },
  features = {
    "indent_blankline",
    "illuminate",
    "lsp",
    "treesitter",
    "syntax",
    "matchparen",
    "vimopts",
    "filetype",
  },
  vimopts = {
    swapfile = false,
    foldmethod = "manual" ,
    undolevels = -1,
    undoreload = 0,
    list = false
  }
}

require('bigfile').config({default_config})
local augroup = vim.api.nvim_create_augroup('core.bigfile', {})

vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*',
  group = augroup,
  callback = function(args)

    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats.size > 1024 * 1024 then
      vim.opt.syntax = 'off';
    end
  end,
  desc = string.format('Performance rule for handling files over 1MB'),
})
