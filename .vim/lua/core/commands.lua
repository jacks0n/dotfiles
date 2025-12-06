local M = {}

-- Clear Lua module cache for all modules in .vim/lua/
vim.api.nvim_create_user_command('ClearLuaCache', function()
  local cleared = {}
  local count = 0

  -- Get the .vim directory path
  local vim_dir = vim.fn.stdpath('config')

  for module_name, _ in pairs(package.loaded) do
    -- Try to get the module's source file
    local module_info = package.searchpath(module_name, package.path)

    -- Clear if module name matches common patterns from .vim/lua/
    -- or if the source file is in our .vim directory
    local should_clear = false

    if module_name:match('^core%.') or
       module_name:match('^plugins%.') or
       module_name:match('^utils%.') or
       module_name == 'core' or
       module_name == 'plugins' or
       module_name == 'utils' then
      should_clear = true
    elseif module_info and module_info:find(vim_dir, 1, true) then
      should_clear = true
    end

    if should_clear then
      package.loaded[module_name] = nil
      table.insert(cleared, module_name)
      count = count + 1
    end
  end

  if count > 0 then
    vim.notify(
      string.format('Cleared %d Lua module%s from cache', count, count == 1 and '' or 's'),
      vim.log.levels.INFO
    )
    -- Optionally print which modules were cleared (useful for debugging)
    -- vim.print(cleared)
  else
    vim.notify('No Lua modules found to clear', vim.log.levels.WARN)
  end
end, { desc = 'Clear Lua module cache for .vim/lua/* modules' })

return M
