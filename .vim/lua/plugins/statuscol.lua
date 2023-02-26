require('statuscol').setup({
  foldfunc = 'builtin',
  setopt = true
})

-- vim.o.foldcolumn = '1'
vim.o.statuscolumn = '%= '
  .. '%s' -- sign column FIXME: figure out how to put on the other side without having to do a lot of shifting
  .. '%{%' -- evaluate this, and then evaluate what it returns
    .. '&number ?'
      .. '(v:relnum ?'
	    .. 'printf("%"..len(line("$")).."s", v:relnum)' -- when showing relative numbers, make sure to pad so things don't shift as you move the cursor
      .. ':'
		.. 'v:lnum'
      .. ')'
	.. ':'
      .. '""'
	.. ' ' -- space between lines and fold
  .. '%}'
  .. '%= '
  .. '%#FoldColumn#' -- highlight group for fold
  .. '%{' -- expression for showing fold expand/colapse
    .. 'foldlevel(v:lnum) > foldlevel(v:lnum - 1)' -- any folds?
      .. '? (foldclosed(v:lnum) == -1' -- currently open?
        .. '? ""' -- point down
        .. ':  ""' -- point to right
  	.. ')'
  	.. ': " "' -- blank for no fold, or inside fold
  .. '}'
  .. '%= ' -- spacing between end of column and start of text
