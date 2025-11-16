local M = {
  json = {},
  file = {},
}

function M.project_dir()
  local path = vim.fn.expand('%:p')
  local found = vim.fs.find('.git', {
    path = path,
    upward = true,
    stop = vim.loop.os_homedir(),
  })[1]

  if found then
    return vim.fs.dirname(found)
  end
  return nil
end

function M.is_executable(name)
  return vim.fn.executable(name) == 1
end

function M.is_large_file(bufnr)
  local max_filesize = 1000 * 1024 -- 1MB
  local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  return (file_size > max_filesize or line_count > 10000)
end

function M.is_in_undo_dir(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  return filepath:match('^' .. vim.o.undodir)
end

--- Encode a table into a JSON string.
-- @param data Data to encode.
-- @param[opt=0]? Indent level.
-- @return Encoded table as a JSON string.
function M.json.encode(data, indent)
  if type(data) == 'string' then
    return '"' .. data .. '"'
  end
  if not indent then
    indent = 0
  end
  local toprint = '{\n'
  indent = indent + 2
  for k, v in pairs(data) do
    toprint = toprint .. string.rep(' ', indent)
    if type(k) == 'number' then
      toprint = toprint .. '[' .. k .. '] = '
    elseif type(k) == 'string' then
      toprint = toprint .. k .. ' = '
    end
    if type(v) == 'number' then
      toprint = toprint .. v .. ',\n'
    elseif type(v) == 'string' then
      toprint = toprint .. "'" .. v .. "',\n"
    elseif type(v) == 'table' then
      toprint = toprint .. M.json.encode(v, indent) .. ',\n'
    else
      toprint = toprint .. "'" .. tostring(v) .. "',\n"
    end
  end
  toprint = toprint .. string.rep(' ', indent - 2) .. '}'

  return toprint
end

function M.file.append_line(filename, ...)
  local file = io.open(filename, 'a')
  local data = {}
  for _, value in pairs({ ... }) do
    if type(value) == 'boolean' or type(value) == 'number' or type(value) == 'string' then
      table.insert(data, tostring(value))
    else
      table.insert(data, M.json.encode(value))
    end
  end
  if file then
    file:write(table.concat(data, ', ') .. '\n')
    file:close()
  end
end



--- Write a string to a file.
-- @param data Table to encode.
-- @param[opt=0 Indent level.
-- @return Encoded table as a JSON string.
function M.to_file(data, filepath)
  local file = io.open(filepath, 'w')
  if not file then
    error(string.format('Error opening file: %s', filepath))
  end
  local ok, _ = file:write(data)
  if not ok then
    error(string.format('Error writing to file: %s', filepath))
  end
  file:close()
end

-- Cache for Python settings keyed by root directory
local _python_settings_cache = {}

--- Check if a project uses UV package manager.
-- Checks for uv.lock file or [tool.uv] section in pyproject.toml
-- @param root_dir The root directory of the project
-- @return Boolean indicating if UV is detected
function M.is_uv_project(root_dir)
  -- Check for uv.lock file
  local uv_lock = root_dir .. '/uv.lock'
  if vim.fn.filereadable(uv_lock) == 1 then
    return true
  end

  -- Check for [tool.uv] in pyproject.toml
  local pyproject = root_dir .. '/pyproject.toml'
  if vim.fn.filereadable(pyproject) == 1 then
    local file = io.open(pyproject, 'r')
    if file then
      local content = file:read('*all')
      file:close()
      if content:match('%[tool%.uv%]') then
        return true
      end
    end
  end

  return false
end

--- Detect Python settings for a given project root directory.
-- Searches for Python binary in this order:
-- 1. Local virtual environments (.venv, venv, env, .env)
-- 2. UV environment (if uv.lock or [tool.uv] detected)
-- 3. Poetry environment
-- 4. Pipenv environment
-- 5. Environment variables (VIRTUAL_ENV, CONDA_PREFIX)
-- 6. System Python (python3 or python)
-- Results are cached per root directory.
-- @param root_dir The root directory of the project
-- @param force_refresh Optional: force cache refresh
-- @return Table with pythonPath, venvPath (optional), and venv (optional)
function M.detect_python_settings(root_dir, force_refresh)
  -- Check cache first
  if not force_refresh and _python_settings_cache[root_dir] then
    return _python_settings_cache[root_dir]
  end

  local python_path = nil

  -- Check for local virtual environments
  local venv_dirs = { '.venv', 'venv', 'env', '.env' }
  for _, vdir in ipairs(venv_dirs) do
    local venv_python = root_dir .. '/' .. vdir .. '/bin/python'
    if vim.fn.filereadable(venv_python) == 1 then
      python_path = venv_python
      break
    end
  end

  -- Try UV
  if not python_path and M.is_uv_project(root_dir) then
    local uv_cmd = string.format('cd %s && uv run python -c "import sys; print(sys.prefix)" 2>/dev/null', vim.fn.shellescape(root_dir))
    local uv_venv = vim.fn.system(uv_cmd)
    if vim.v.shell_error == 0 and uv_venv ~= '' then
      python_path = vim.trim(uv_venv) .. '/bin/python'
    end
  end

  -- Try Poetry
  if not python_path then
    local poetry_cmd = string.format('cd %s && poetry env info --path 2>/dev/null', vim.fn.shellescape(root_dir))
    local poetry_venv = vim.fn.system(poetry_cmd)
    if vim.v.shell_error == 0 and poetry_venv ~= '' then
      python_path = vim.trim(poetry_venv) .. '/bin/python'
    end
  end

  -- Try Pipenv
  if not python_path then
    local pipenv_cmd = string.format('cd %s && pipenv --venv 2>/dev/null', vim.fn.shellescape(root_dir))
    local pipenv_venv = vim.fn.system(pipenv_cmd)
    if vim.v.shell_error == 0 and pipenv_venv ~= '' then
      python_path = vim.trim(pipenv_venv) .. '/bin/python'
    end
  end

  -- Check environment variables
  if not python_path then
    if vim.env.VIRTUAL_ENV then
      local env_path = vim.env.VIRTUAL_ENV .. '/bin/python'
      if vim.fn.filereadable(env_path) == 1 then
        python_path = env_path
      end
    elseif vim.env.CONDA_PREFIX then
      local conda_path = vim.env.CONDA_PREFIX .. '/bin/python'
      if vim.fn.filereadable(conda_path) == 1 then
        python_path = conda_path
      end
    end
  end

  -- Default to system Python
  if not python_path then
    python_path = vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python3'
  end


  -- Verify the path exists
  if vim.fn.filereadable(python_path) ~= 1 and vim.fn.executable(python_path) ~= 1 then
  end

  -- Build settings object
  local settings = {
    pythonPath = python_path,
  }

  -- Extract venv information if python_path was found before falling back to system Python
  -- This indicates it's a virtual environment
  if python_path ~= vim.fn.exepath('python3') and python_path ~= vim.fn.exepath('python') then
    local bin_python_pattern = '/bin/python'
    local bin_idx = python_path:find(bin_python_pattern, 1, true)
    if bin_idx then
      local venv_root = python_path:sub(1, bin_idx - 1)
      settings.venvPath = vim.fs.dirname(venv_root)
      settings.venv = vim.fs.basename(venv_root)
    end
  end

  -- Cache the result
  _python_settings_cache[root_dir] = settings

  return settings
end

function M.find_git_root(bufnr)
  bufnr = bufnr or 0
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == '' then return nil end
  local start = vim.fs.dirname(file)
  local git_dir = vim.fs.find({ '.git' }, { path = start, upward = true })[1]
  if not git_dir then return nil end
  return vim.fs.dirname(git_dir)
end

function M.discover_python_extra_paths(root_dir, python_executable)
  local paths = {}
  -- Project root first
  if vim.fn.isdirectory(root_dir) == 1 then
    table.insert(paths, root_dir)
  end
  -- Site-packages locations from interpreter
  if python_executable and vim.fn.filereadable(python_executable) == 1 then
    local site_cmd = python_executable .. [[ -c 'import sys; [print(p) for p in sys.path if p.endswith("site-packages")]']]
    local output = vim.fn.system(site_cmd)
    if vim.v.shell_error == 0 and output ~= '' then
      for line in output:gmatch('[^\n]+') do
        if vim.fn.isdirectory(line) == 1 then
          table.insert(paths, line)
        end
      end
    end
  end
  -- Deduplicate
  local dedup = {}
  local final = {}
  for _, p in ipairs(paths) do
    if not dedup[p] then
      dedup[p] = true
      table.insert(final, p)
    end
  end
  return final
end

return M
