local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' }}))
-- If you want insert `(` after select function or method item
local autopairs_handlers = require('nvim-autopairs.completion.handlers')
cmp.event:on(
  'confirm_done',
  function()
    -- cmp_autopairs.on_confirm_done({ map_char = { tex = '' }})
    cmp_autopairs.on_confirm_done({
      filetypes = {
        ['*'] = {
          ['('] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
            handler = autopairs_handlers['*'],
          },
        },
      }
    })
  end
)
cmp.event:on(
  'complete_done',
  function()
    -- cmp_autopairs.on_confirm_done({ map_char = { tex = '' }})
    cmp_autopairs.on_confirm_done({
      filetypes = {
        ['*'] = {
          ['('] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
            handler = autopairs_handlers['*'],
          },
        },
      }
    })
  end
)

local function next_item_callback(fallback)
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  -- elseif has_words_before() then
  --   cmp.complete()
  else
    fallback()
  end
end

local function prev_item_callback(fallback)
  if cmp.visible() then
    cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

cmp.setup({
  experimental = {
    ghost_text = true,
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 120,
      ellipsis_char = '…',
      symbol_map = {
        Copilot = '',
        Codeium = '',
      },
    })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping(prev_item_callback, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(next_item_callback, { 'i', 's' }),
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(next_item_callback, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(prev_item_callback, { 'i', 's' }),
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help', priority_weight = 100 },
    { name = 'nvim_lsp', priority_weight = 90 },
    { name = 'nvim_lua', priority_weight = 90 },
    { name = 'codeium', priority_weight = 90 },
    { name = 'copilot', priority_weight = 70 }, -- group_index = 2,
    { name = 'cmp_tabnine', priority_weight = 70 },
    { name = 'luasnip', option = { show_autosnippets = true }, keyword_length = 2, priority_weight = 60 },
    { name = 'path', priority_weight = 50 },
    { name = 'buffer', priority_weight = 40 },
    { name = 'npm', keyword_length = 4, priority_weight = 40 },
    { name = 'spell', priority_weight = 30 },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' }
  })
})

cmp.setup.filetype('sagarename', {
  sources = {},
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
