require('mason').setup({
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
  PATH = 'prepend',
})

local function get_lsp_mason_packages()
  local lsp_servers = require('core.lsp').lsp_servers
  local lspconfig_to_mason = require('mason-lspconfig').get_mappings().lspconfig_to_package

  local packages = {}
  for _, server in ipairs(lsp_servers) do
    table.insert(packages, lspconfig_to_mason[server] or server)
  end
  return packages
end

local function get_null_ls_mason_packages()
  local linters_config = require('core.linters').get_config()
  local source_mappings = require('mason-null-ls.mappings.source')

  local packages = {}
  for name, cfg in pairs(linters_config) do
    if cfg.mason_name ~= false then
      table.insert(packages, source_mappings.getPackageFromNullLs(name))
    end
  end
  return packages
end

local function is_headless()
  return #vim.api.nvim_list_uis() == 0
end

-- Options:
--   force: boolean - reinstall even if already installed
--   headless: boolean - wait synchronously for completion (auto-detected if nil)
--   update_only: boolean - only update already installed packages
local function install_packages(packages, label, opts)
  opts = opts or {}
  local headless = opts.headless
  if headless == nil then
    headless = is_headless()
  end

  local mason_registry = require('mason-registry')
  local seen = {}
  local to_install = {}

  for _, name in ipairs(packages) do
    if not seen[name] then
      seen[name] = true
      local ok, pkg = pcall(mason_registry.get_package, name)
      if ok then
        local is_installed = pkg:is_installed()
        if opts.update_only then
          if is_installed then
            table.insert(to_install, name)
          end
        elseif opts.force or not is_installed then
          table.insert(to_install, name)
        end
      elseif not ok then
        vim.notify('Mason: package not found: ' .. name, vim.log.levels.WARN)
      end
    end
  end

  if #to_install == 0 then
    local msg = opts.update_only
        and ('Mason ' .. label .. ': no installed packages to update')
        or ('Mason ' .. label .. ': all packages already installed')
    vim.notify(msg, vim.log.levels.INFO)
    if headless then
      vim.cmd('qa!')
    end
    return
  end

  local action = opts.update_only and 'updating' or (opts.force and 'reinstalling' or 'installing')
  vim.notify('Mason ' .. label .. ': ' .. action .. ' ' .. #to_install .. ' packages...', vim.log.levels.INFO)

  if not headless then
    require('mason.ui').open()
  end

  local pending = #to_install
  local completed = 0
  local failed = {}

  local function on_complete(pkg_name, success)
    completed = completed + 1
    if not success then
      table.insert(failed, pkg_name)
    end

    if completed >= pending then
      if #failed > 0 then
        vim.notify('Mason ' .. label .. ': failed: ' .. table.concat(failed, ', '), vim.log.levels.ERROR)
      else
        vim.notify('Mason ' .. label .. ': completed ' .. action .. ' ' .. pending .. ' packages', vim.log.levels.INFO)
      end

      if headless then
        vim.schedule(function()
          vim.cmd('qa!')
        end)
      end
    end
  end

  mason_registry.refresh(function()
    for _, name in ipairs(to_install) do
      local ok, pkg = pcall(mason_registry.get_package, name)
      if ok then
        local handle = pkg:install()
        handle:once('closed', function()
          local success = pkg:is_installed()
          vim.schedule(function()
            on_complete(name, success)
          end)
        end)
      else
        vim.schedule(function()
          on_complete(name, false)
        end)
      end
    end
  end)

  if headless then
    vim.wait(600000, function()
      return completed >= pending
    end, 100)
  end
end

vim.api.nvim_create_user_command('MasonInstallLsp', function(cmd)
  install_packages(get_lsp_mason_packages(), 'LSP', { force = cmd.bang })
end, { bang = true, desc = 'Install configured LSP servers (! to force reinstall)' })

vim.api.nvim_create_user_command('MasonInstallNullLs', function(cmd)
  install_packages(get_null_ls_mason_packages(), 'null-ls', { force = cmd.bang })
end, { bang = true, desc = 'Install configured linters/formatters (! to force reinstall)' })

vim.api.nvim_create_user_command('MasonInstallAll', function(cmd)
  local all_packages = vim.list_extend(get_lsp_mason_packages(), get_null_ls_mason_packages())
  install_packages(all_packages, 'all', { force = cmd.bang })
end, { bang = true, desc = 'Install all configured packages (! to force reinstall)' })

vim.api.nvim_create_user_command('MasonUpdateLsp', function()
  install_packages(get_lsp_mason_packages(), 'LSP', { force = true, update_only = true })
end, { desc = 'Update installed LSP servers to latest versions' })

vim.api.nvim_create_user_command('MasonUpdateNullLs', function()
  install_packages(get_null_ls_mason_packages(), 'null-ls', { force = true, update_only = true })
end, { desc = 'Update installed linters/formatters to latest versions' })

vim.api.nvim_create_user_command('MasonUpdateAll', function()
  local all_packages = vim.list_extend(get_lsp_mason_packages(), get_null_ls_mason_packages())
  install_packages(all_packages, 'all', { force = true, update_only = true })
end, { desc = 'Update all installed Mason packages to latest versions' })
