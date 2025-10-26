local builtin = require('statuscol.builtin')

require('statuscol').setup({
  setopt = true,
  segments = {
    -- Fold column
    {
      text = { builtin.foldfunc, ' ' },
      click = 'v:lua.ScFa',
    },
    -- Signs (git, diagnostics, etc)
    {
      sign = {
        namespace = { '.*' },
        maxwidth = 1,
        auto = true,
      },
      click = 'v:lua.ScSa',
    },
    -- Line numbers
    {
      text = { builtin.lnumfunc, ' ' },
      click = 'v:lua.ScLa',
    },
  },
})
