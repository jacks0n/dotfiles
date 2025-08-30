-- nvim-comment configuration
-- A comment toggler for Neovim, written in Lua

require('nvim_comment').setup({
  -- Linters prefer comment and line to have a space in between markers
  marker_padding = true,
  -- Should comment out empty or whitespace only lines
  comment_empty = true,
  -- trim empty comment whitespace
  comment_empty_trim_whitespace = true,
  -- Should key mappings be created
  create_mappings = true,
  -- Normal mode mapping left hand side
  line_mapping = "gcc",
  -- Visual/Operator mapping left hand side
  operator_mapping = "gc",
  -- text object mapping, comment chunk,,
  comment_chunk_text_object = "ic",
})

-- Set up additional keymappings for consistency with common patterns
vim.keymap.set('n', '<Leader>cc', '<Cmd>CommentToggle<CR>', { desc = 'Comment toggle current line', silent = true })
vim.keymap.set('v', '<Leader>cc', '<Cmd>CommentToggle<CR>', { desc = 'Comment toggle selection', silent = true })
vim.keymap.set('n', '<Leader>c<Space>', '<Cmd>CommentToggle<CR>', { desc = 'Comment toggle current line', silent = true })
vim.keymap.set('v', '<Leader>c<Space>', '<Cmd>CommentToggle<CR>', { desc = 'Comment toggle selection', silent = true })