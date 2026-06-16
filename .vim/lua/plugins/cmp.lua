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
    ['<C-y>'] = { 'accept', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<C-x><C-f>'] = { 'show', 'fallback' }, -- Manual path completion trigger
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
    },
  },

  sources = {
    default = { 'lsp', 'path', 'buffer' },

    per_filetype = {
      typescript = { 'lsp', 'buffer' },
      typescriptreact = { 'lsp', 'buffer' },
      javascript = { 'lsp', 'buffer' },
      javascriptreact = { 'lsp', 'buffer' },
      gitcommit = { 'buffer' },
      sagarename = {},
      ['/'] = { 'buffer' },
      [':'] = { 'cmdline', 'path' },
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
      path = {
        name = 'Path',
        enabled = true,
        score_offset = 60,
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(_ctx)
            -- Expand environment variables in the current context
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = line:sub(1, col)

            -- Check if we're after an environment variable like $HOME/
            local env_path = before_cursor:match('%$([%w_]+)/[^%s"\']*$')
            if env_path then
              local expanded = vim.fn.expand('$' .. env_path)
              if expanded ~= '$' .. env_path then
                return expanded
              end
            end

            return vim.fn.getcwd()
          end,
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
        -- Deprecated @todo fix.
        -- pairs = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '"', '"' }, { "'", "'" } },
      },
    },

    trigger = {
      -- Enable path completion in strings by removing quotes from blocked characters
      show_on_x_blocked_trigger_characters = { '(', '{', '[' },
      -- Enable re-triggering on path separators
      show_on_insert_on_trigger_character = true,
      -- Trigger immediately on these characters (includes path separators)
      show_in_snippet = true,
    },

    list = {
      selection = {
        preselect = true, -- Auto-select first item like VSCode
        auto_insert = false, -- Don't auto-insert, wait for Tab/Enter
      },
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
      -- Deprecated. @todo fix
      -- regex = '[%w_\\-]',
      -- Deprecated. @todo fix
      -- exclude_from_prefix_regex = '[\\-]',
    },
  },

  signature = {
    enabled = true,
    window = {
      border = 'rounded',
      winblend = 0,
    },
  },

  cmdline = {
    enabled = false
    -- keymap = {
    --   preset = 'inherit',
    --   ['<CR>'] = {
    --     function(cmp)
    --       if cmp.is_visible() then
    --         return cmp.accept()
    --       end
    --     end,
    --     'fallback',
    --   },
    --   ['<Tab>'] = { 'show', 'select_next', 'fallback' },
    --   ['<S-Tab>'] = { 'select_prev', 'fallback' },
    --   ['<C-y>'] = { 'accept', 'fallback' },
    -- },
    -- completion = {
    --   menu = {
    --     -- Only show autocomplete in command mode (:), not search mode (/ or ?)
    --     auto_show = function(ctx)
    --       local cmdtype = vim.fn.getcmdtype()
    --       return cmdtype == ':' or cmdtype == '@'
    --     end
    --   },
    -- },
  },
})

return M
