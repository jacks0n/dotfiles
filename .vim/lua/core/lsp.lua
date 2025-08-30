local lspconfig = require("lspconfig")
local navbuddy = require("nvim-navbuddy")

-- Setup lazydev before lua_ls for fast Neovim development
require("plugins.lazydev")

vim.lsp.set_log_level("warn")

require("mason").setup({
  ui = {
    border = "rounded",
  },
})

require("mason-lspconfig").setup({
  -- ensure_installed = {
  --   "bashls",
  --   "cssls",
  --   "cucumber_language_server",
  --   "docker_compose_language_service",
  --   "dockerls",
  --   "eslint",
  --   "html",
  --   "intelephense",
  --   "jsonls",
  --   "lemminx",
  --   "lua_ls",
  --   "marksman",
  --   "phpactor",
  --   "psalm",
  --   "sqlls",
  --   "terraformls",
  --   "tflint",
  --   "ts_ls",
  --   "vimls",
  --   "yamlls",
  --   "jdtls",
  --   "pyright",
  -- },
  -- automatic_installation = false,
})

-- Diagnostics are configured in core.diagnostic

local tsserver_lang_config = {
  preferences = {
    importModuleSpecifier = "non-relative",
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  },
  suggest = {
    completeFunctionCalls = true,
    includeAutomaticOptionalChainCompletions = true,
  },
  updateImportsOnFileMove = {
    enabled = "always",
  },
  experimental = {
    tsserver = {
      web = {
        enableProjectWideIntellisense = true,
      },
    },
  },
}

local on_attach = function(client, buffer)
  if client.server_capabilities.documentSymbolProvider then
    navbuddy.attach(client, buffer)
  end

  -- Let eslint handle formatting for TypeScript
  if client.name == "ts_ls" or client.name == "vtsls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false
  end

  -- Set up LSP key mappings (diagnostic keymaps are in core.diagnostic)
  local opts = { noremap = true, silent = true, buffer = buffer }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- Use Telescope mapping instead
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gf", vim.lsp.buf.format, opts)
end

-- LSP servers are now configured individually below as needed

-- Lazy load LSP servers based on filetype
local lsp_configs = {
  jdtls = {
    filetypes = { "java" },
    settings = {
      java = {
        signatureHelp = {
          enabled = true,
        },
      },
    },
  },
  jsonls = {
    filetypes = { "json", "jsonc" },
    init_options = { provideFormatter = true },
    settings = {
      json = {
        schemas = function()
          return require("schemastore").json.schemas()
        end,
        validate = {
          enable = true,
        },
        configure = {
          allowComments = true,
        },
      },
    },
  },
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
          unusedLocalExclude = { "_*" },
        },
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          -- lazydev handles library loading dynamically
          checkThirdParty = false, -- Prevents the annoying workspace popup
          -- Limit workspace diagnostics to improve performance
          diagnosticRate = 30, -- 30% speed to reduce CPU usage
          workspaceDelay = 1000, -- 1 second delay before diagnosing workspace
          maxPreload = 10000, -- Increased to prevent preload limit popup
          preloadFileSize = 100, -- KB, limit file size for preloading
          ignoreDir = {
            vim.o.undodir,
            vim.o.backupdir,
            "plugged",
            ".git",
            ".cache",
            "node_modules",
            ".vim/backup",
            ".vim/swap",
            ".vim/undo",
          },
        },
        telemetry = {
          enable = true,
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
      },
    },
  },
  yamlls = {
    filetypes = { "yaml", "yml" },
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemas = function()
          return require("schemastore").json.schemas()
        end,
        schemastore = {
          enable = true,
        },
        customTags = {
          "!And sequence",
          "!And",
          "!Base64 scalar",
          "!Base64",
          "!Cidr scalar",
          "!Cidr sequence",
          "!Cidr",
          "!Condition scalar",
          "!Equals sequence",
          "!Equals",
          "!FindInMap sequence",
          "!FindInMap",
          "!GetAZs scalar",
          "!GetAZs",
          "!GetAtt scalar",
          "!GetAtt sequence",
          "!GetAtt",
          "!If sequence",
          "!If",
          "!ImportValue scalar",
          "!ImportValue sequence",
          "!ImportValue",
          "!Join sequence",
          "!Join",
          "!Not sequence",
          "!Not",
          "!Or sequence",
          "!Or",
          "!Ref scalar",
          "!Ref",
          "!Select sequence",
          "!Select",
          "!Split sequence",
          "!Split",
          "!Sub scalar",
          "!Sub sequence",
          "!Sub",
          "!Transform mapping",
        },
      },
    },
  },
  vimls = {
    filetypes = { "vim" },
    init_options = { isNeovim = true },
  },
  ts_ls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "typescriptreact.typescript",
    },
    commands = {
      OrganizeImports = {
        function()
          vim.lsp.buf.execute_command({
            command = "_typescript.organizeImports",
            arguments = { vim.fn.expand("%:p") },
          })
        end,
        description = "Organize Imports",
      },
    },
    settings = {
      typescript = tsserver_lang_config,
      javascript = tsserver_lang_config,
      implicitProjectConfig = {
        checkJs = true,
        enableImplicitProjectConfig = true,
      },
      completions = {
        completeFunctionCalls = true,
      },
      format = {
        indentSize = 2,
        tabSize = 2,
      },
    },
  },
}

-- Setup function for LSP servers
local function setup_lsp_server(server_name)
  local config = lsp_configs[server_name] or {}
  config.on_attach = on_attach

  -- Resolve functions in settings
  if config.settings then
    local function resolve_functions(tbl)
      for k, v in pairs(tbl) do
        if type(v) == "function" then
          tbl[k] = v()
        elseif type(v) == "table" then
          resolve_functions(v)
        end
      end
    end
    resolve_functions(config.settings)
  end

  lspconfig[server_name].setup(config)
end

-- Create autocmds for lazy loading LSP servers
for server_name, config in pairs(lsp_configs) do
  if config.filetypes then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = config.filetypes,
      once = true,
      callback = function()
        setup_lsp_server(server_name)
      end,
    })
  end
end

-- Cache for Python environment detection
local python_env_cache = {}

-- Function to detect Poetry virtual environment (async)
local function get_poetry_venv_path_async(callback)
  local cwd = vim.fn.getcwd()

  -- Check cache first
  if python_env_cache[cwd] and python_env_cache[cwd].poetry_venv then
    callback(python_env_cache[cwd].poetry_venv)
    return
  end

  vim.fn.jobstart({ "poetry", "env", "info", "--path" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] and data[1]:match("^/") then
        local venv_path = data[1]:gsub("%s+", "")
        python_env_cache[cwd] = python_env_cache[cwd] or {}
        python_env_cache[cwd].poetry_venv = venv_path
        callback(venv_path)
      else
        callback(nil)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        callback(nil)
      end
    end,
  })
end

-- Function to detect Python interpreter path (async)
local function get_python_path_async(callback)
  local cwd = vim.fn.getcwd()

  -- Check cache first
  if python_env_cache[cwd] and python_env_cache[cwd].python_path then
    callback(python_env_cache[cwd].python_path)
    return
  end

  -- Try Poetry first
  get_poetry_venv_path_async(function(poetry_venv)
    if poetry_venv then
      local python_path = poetry_venv .. "/bin/python"
      python_env_cache[cwd] = python_env_cache[cwd] or {}
      python_env_cache[cwd].python_path = python_path
      callback(python_path)
    else
      -- Fall back to pipenv
      vim.fn.jobstart({ "pipenv", "--venv" }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and data[1] and data[1]:match("^/") then
            local python_path = data[1]:gsub("%s+", "") .. "/bin/python"
            python_env_cache[cwd] = python_env_cache[cwd] or {}
            python_env_cache[cwd].python_path = python_path
            callback(python_path)
          else
            -- Fall back to system python
            callback("python3")
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            -- Fall back to system python
            callback("python3")
          end
        end,
      })
    end
  end)
end

-- Function to get project root and set appropriate paths (deferred)
local function setup_python_lsp()
  local root_dir = vim.fn.getcwd()

  -- Base paths for Python analysis
  local extra_paths = { "." }

  -- Add common Python project paths
  local common_paths = { "src", "tests", "lib" }
  for _, path in ipairs(common_paths) do
    local full_path = root_dir .. "/" .. path
    if vim.fn.isdirectory(full_path) == 1 then
      table.insert(extra_paths, full_path)
    end
  end

  -- Default settings (will be updated async)
  local python_settings = {
    python_path = "python3",
    venv_path = ".venv",
    extra_paths = extra_paths,
  }

  -- Setup pyright with default settings first
  lspconfig.pyright.setup({
    on_attach = on_attach,
    single_file_support = false,
    filetypes = { "python" },
    settings = {
      python = {
        pythonPath = python_settings.python_path,
        venvPath = python_settings.venv_path,
        analysis = {
          extraPaths = python_settings.extra_paths,
          completeFunctionParens = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
          typeCheckingMode = "off",
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = "none",
            reportOptionalMemberAccess = "none",
            reportOptionalSubscript = "none",
            reportPrivateImportUsage = "none",
          },
        },
      },
      pyright = {
        disableOrganizeImports = false,
        autoImportCompletions = true,
      },
    },
  })

  -- Update Python path asynchronously after initial setup
  get_python_path_async(function(python_path)
    get_poetry_venv_path_async(function(poetry_venv)
      -- Update settings with actual paths
      python_settings.python_path = python_path
      python_settings.venv_path = poetry_venv or ".venv"

      -- Add Poetry venv site-packages if available
      if poetry_venv then
        local site_packages = poetry_venv .. "/lib/python*/site-packages"
        local globbed = vim.fn.glob(site_packages)
        if globbed and globbed ~= "" then
          table.insert(python_settings.extra_paths, globbed)
        end
      end

      -- Update pyright config if it's already attached to buffers
      local clients = vim.lsp.get_active_clients({ name = "pyright" })
      for _, client in ipairs(clients) do
        client.config.settings.python.pythonPath = python_settings.python_path
        client.config.settings.python.venvPath = python_settings.venv_path
        client.config.settings.python.analysis.extraPaths = python_settings.extra_paths
        client.notify("workspace/didChangeConfiguration", {
          settings = client.config.settings,
        })
      end
    end)
  end)
end

-- Python LSP will be set up on demand
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    setup_python_lsp()
  end,
})

-- Setup basic LSP servers from Mason on demand
local basic_servers = {
  bashls = { "sh", "bash" },
  cssls = { "css", "scss", "less" },
  html = { "html" },
  dockerls = { "dockerfile" },
  terraformls = { "terraform", "tf" },
  marksman = { "markdown" },
  sqlls = { "sql" },
  intelephense = { "php" },
}

for server, filetypes in pairs(basic_servers) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    once = true,
    callback = function()
      lspconfig[server].setup({ on_attach = on_attach })
    end,
  })
end

if vim.g.use_bun then
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    if config.cmd[1] == "node" then
      config.cmd = vim.list_extend({ "bun", "run", "--bun" }, config.cmd)
    else
      local cmd_handle = io.popen("which " .. config.cmd[1])
      if not cmd_handle then
        return
      end
      local cmd_path = string.gsub(cmd_handle:read("*a"), "%s+", "")
      if not cmd_path then
        return
      end
      cmd_handle:close()

      local cmd_file = io.open(cmd_path)
      if not cmd_file then
        return
      end
      for l in cmd_file:lines() do
        if string.sub(l, -4) == "node" then
          config.cmd[1] = cmd_path
          table.insert(config.cmd, 1, "bun run --bun")
        end
      end
    end
  end)
end
