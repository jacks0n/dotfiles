local M = {}

local blink = require('blink.cmp')
blink.setup({
  -- Use Lua implementation to avoid fuzzy library warnings
  fuzzy = {
    implementation = 'lua',
  },

  keymap = {
    preset = 'default',
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-d>'] = {
      function(cmp)
        cmp.scroll_documentation_up(4)
      end,
      'fallback',
    },
    ['<C-f>'] = {
      function(cmp)
        cmp.scroll_documentation_down(4)
      end,
      'fallback',
    },
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
    kind_icons = {
      Text = '󰉿',
      Method = '󰊕',
      Function = '󰊕',
      Constructor = '󰒓',
      Field = '󰜢',
      Variable = '󰆦',
      Class = '󱡠',
      Interface = '󱡠',
      Module = '󰅩',
      Property = '󰖷',
      Unit = '󰪚',
      Value = '󰦨',
      Enum = '󰦨',
      Keyword = '󰻾',
      Snippet = '󱄽',
      Color = '󰏘',
      File = '󰈔',
      Reference = '󰬲',
      Folder = '󰉋',
      EnumMember = '󰦨',
      Constant = '󰏿',
      Struct = '󱡠',
      Event = '󱐋',
      Operator = '󰪚',
      TypeParameter = '󰬛',
      Copilot = '', -- Copilot icon
    },
  },

  sources = {
    default = { 'lsp', 'copilot', 'path', 'buffer' },

    per_filetype = {
      -- For TS/JS files, prioritize LSP for path completions
      typescript = { 'lsp', 'copilot', 'buffer' },
      typescriptreact = { 'lsp', 'copilot', 'buffer' },
      javascript = { 'lsp', 'copilot', 'buffer' },
      javascriptreact = { 'lsp', 'copilot', 'buffer' },
      gitcommit = { 'buffer' },
      sagarename = {},
      ['/'] = { 'buffer' },
      [':'] = { 'cmdline' },
    },

    providers = {
      lsp = {
        name = 'LSP',
        enabled = true,
        score_offset = 100, -- Give LSP higher priority
      },
      lazydev = {
        name = 'Development',
        module = 'lazydev.integrations.blink',
        score_offset = 85,
        enabled = function()
          return vim.bo.filetype == 'lua'
        end,
      },
      copilot = {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        score_offset = 100,
        async = true,
        transform_items = function(_, items)
          local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = 'Copilot'
          for _, item in ipairs(items) do
            item.kind = kind_idx
          end
          return items
        end,
      },
      path = {
        name = 'Path',
        enabled = true,
        score_offset = 60,
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = vim.fn.getcwd,
          show_hidden_files_by_default = false,
        },
      },
      buffer = {
        name = 'Buffer',
        enabled = true,
        min_keyword_length = 3,
        score_offset = 50,
      },
      cmdline = {
        name = 'Commands',
        enabled = true,
        score_offset = 40,
      },
    },
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
        pairs = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '"', '"' }, { "'", "'" } },
      },
    },

    trigger = {
      -- Enable path completion in strings by removing quotes from blocked characters
      show_on_x_blocked_trigger_characters = { '(', '{', '[' },
    },

    menu = {
      enabled = true,
      auto_show = true,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
      },
      border = 'rounded',
      winblend = 0,
      max_height = 10,
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      update_delay_ms = 50,
      treesitter_highlighting = true,
      window = {
        border = 'rounded',
        winblend = 0,
      },
    },

    ghost_text = {
      enabled = true,
    },

    keyword = {
      range = 'prefix',
      regex = '[%w_\\-]',
      exclude_from_prefix_regex = '[\\-]',
    },
  },

  signature = {
    enabled = true,
    window = {
      border = 'rounded',
      winblend = 0,
    },
  },
})

return M
