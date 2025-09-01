local M = {}

local blink = require('blink.cmp')
blink.setup({
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

    -- Tab/S-Tab for both completion and snippets
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    -- ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    -- ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
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

    -- Force LSP items to appear before snippets by adjusting scores
    -- transform_items = function(ctx, items)
    --   for _, item in ipairs(items) do
    --     if item.source_name == 'LSP' or item.source_id == 'lsp' then
    --       item.score_offset = (item.score_offset or 0) + 1000
    --     elseif item.source_name == 'Snippets' or item.source_id == 'snippets' then
    --       item.score_offset = (item.score_offset or 0) - 1000
    --     end
    --   end
    --   return items
    -- end,

    per_filetype = {
      lua = { 'lsp', 'lazydev', 'copilot', 'path', 'buffer' },
      gitcommit = { 'buffer' },
      gitrebase = { 'buffer' },
      ['.'] = {},
    },

    providers = {
      lsp = {
        name = 'LSP',
        module = 'blink.cmp.sources.lsp',
        score_offset = 999,
      },

      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 85,
      },

      copilot = {
        name = 'Copilot',
        module = 'blink.compat.source',
        score_offset = 70,
        opts = {
          source = 'copilot',
        },
        transform_items = function(_ctx, items)
          for _, item in ipairs(items) do
            -- Use Text kind (1) for Copilot suggestions
            item.kind = 1
          end
          return items
        end,
      },

      -- snippets = {
      --   name = 'Snippets',
      --   module = 'blink.cmp.sources.snippets',
      --   score_offset = -9999,
      -- },

      path = {
        name = 'Path',
        module = 'blink.cmp.sources.path',
        score_offset = 50,
        opts = {
          trailing_slash = true,
          label_trailing_slash = true,
          get_cwd = function(context)
            return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
          end,
        },
      },

      buffer = {
        name = 'Buffer',
        module = 'blink.cmp.sources.buffer',
        score_offset = 40,
        opts = {
          -- Get text from all visible buffers (matching nvim-cmp behavior)
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.api.nvim_buf_is_loaded(buf) then
                bufs[buf] = true
              end
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },

      cmdline = {
        name = 'Cmdline',
        module = 'blink.cmp.sources.cmdline',
      },
    },
  },

  completion = {
    keyword = {
      range = 'full',
    },

    trigger = {
      -- Show immediately after typing trigger characters (like . or :)
      show_on_trigger_character = true,
      -- Show when entering insert mode on a trigger character
      show_on_insert_on_trigger_character = true,
      -- Optional: show on specific trigger characters when accepting a completion
      show_on_accept_on_trigger_character = true,
    },

    list = {
      -- Maximum items to show
      max_items = 200,
      selection = { preselect = true },
    },

    accept = {
      -- Auto-brackets feature (replaces nvim-autopairs integration)
      auto_brackets = {
        enabled = true,
        default_brackets = { '(', ')' },
        override_brackets_for_filetypes = {},
        -- Automatically detect functions/methods
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue' },
        },
        -- Use semantic tokens for better detection
        semantic_token_resolution = {
          enabled = true,
          blocked_filetypes = { 'java' },
          timeout_ms = 400,
        },
      },
    },

    menu = {
      enabled = true,
      min_width = 15,
      max_height = 10,
      border = 'rounded',
      winblend = 0,
      scrollbar = true,

      draw = {
        gap = 1,
        padding = 1,
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
      },
    },

    documentation = {
      auto_show = false,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
      treesitter_highlighting = true,
      window = {
        min_width = 10,
        max_width = 60,
        max_height = 20,
        border = 'rounded',
        winblend = 0,
        scrollbar = true,
      },
    },

    ghost_text = {
      enabled = true,
    },
  },

  fuzzy = {
    max_typos = 2,
    use_frecency = true,
    use_proximity = true,
  },

  -- snippets = {
  --   preset = 'luasnip',
  --   score_offset = -10,
  -- },

  cmdline = {
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == '/' or type == '?' then
        return { 'buffer' }
      elseif type == ':' then
        return { 'cmdline' }
      end
      return {}
    end,
  },

  signature = {
    enabled = true,
    trigger = {
      enabled = true,
      show_on_trigger_character = true,
      show_on_insert = false,
    },
    window = {
      min_width = 1,
      max_width = 100,
      max_height = 30,
      border = 'rounded',
      winblend = 0,
      scrollbar = false,
    },
  },
})

vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'BlinkCmpDocumentation', { link = 'NormalFloat' })
vim.api.nvim_set_hl(0, 'BlinkCmpDocumentationBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { link = 'NormalFloat' })
vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { link = 'Comment' })

-- Kind highlight groups for icons
vim.api.nvim_set_hl(0, 'BlinkCmpKindCopilot', { fg = '#6CC644' })

-- Setup cmdline completion
vim.opt.wildoptions:append('fuzzy')

return M
