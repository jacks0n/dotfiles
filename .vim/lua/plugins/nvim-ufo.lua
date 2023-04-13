require('ufo').setup({
  provider_selector = function(_bufnr, filetype, buftype)
    if filetype == 'lspsagafinder' then
      return ''
    end

    return {'treesitter', 'indent'}
  end
})
