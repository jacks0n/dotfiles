require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    if filetype == 'lspsagafinder' then
      return ''
    end

    return {'treesitter', 'indent'}
  end
})
