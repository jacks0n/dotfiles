local neotest = require('neotest');

neotest.setup({
  require('neotest-jest')({
    jestCommand = 'npm test --',
    jestConfigFile = '/Users/jackson/Code/bom/admin-portal-cloud/jest.config.js',
    env = { CI = true },
    cwd = function()
      return '/Users/jackson/Code/bom/admin-portal-cloud';
    end,
  }),
  -- adapters = {
  --   require('neotest-jest')({
  --     jestCommand = '/Users/jackson.cooperflightcentre.com.au/Code/fares-data-processing/node_modules/.bin/jest --silent=false --detectOpenHandles --maxWorkers=1 --colors',
  --     jestConfigFile = 'jest.config.ts',
  --     env = { CI = true, STAGE = 'dev' },
  --     cwd = function(_path)
  --       return '/Users/jackson.cooperflightcentre.com.au/Code/fares-data-processing';
  --     end,
  --   }),
  -- },
  output = {
    enabled = true,
    open_on_run = 'short',
  },
})


vim.keymap.set('n', '<Leader>tn', neotest.run.run, { silent = true, desc = 'Run nearest test' })
vim.keymap.set('n', '<Leader>tf', function()
  neotest.run.run(vim.fn.expand('%'))
end, { silent = true, desc = 'Run test file' })
vim.keymap.set('n', '<Leader>tt', neotest.summary.toggle, { silent = true, desc = 'Toggle test summary' })
vim.keymap.set('n', '<Leader>to', neotest.output.open, { silent = true, desc = 'View test output' })
vim.keymap.set('n', '<Leader>tp', neotest.output_panel.open, { silent = true, desc = 'View test output' })
