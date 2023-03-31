require('code_runner').setup({
  float = {
    border = 'rounded',
  },
  filetype = {
		python = 'python3 -u',
		typescript = 'ts-node',
		sh = 'bash',
		zsh = 'zsh',
	},
})

vim.keymap.set('n', '<Leader>rf', ':RunFile float<CR>', { noremap = true, silent = true })
