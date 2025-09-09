local M = {
  json = {},
  logger = {},
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

--- Log an error message.
-- @param string Message to log.
function M.logger.error(message)
  if vim then
    vim.cmd('echom "' .. message .. '"')
  else
    io.stderr:write(string.format(message .. '\n', -2))
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

--- Detect Python path for a given project root directory.
-- Searches for Python binary in this order:
-- 1. Local virtual environments (.venv, venv, env, .env)
-- 2. Poetry environment
-- 3. Pipenv environment
-- 4. Environment variables (VIRTUAL_ENV, CONDA_PREFIX)
-- 5. System Python (python3 or python)
-- @param root_dir The root directory of the project
-- @return The path to the Python binary
function M.detect_python_path(root_dir)
  local python_path = nil

  -- Check for local virtual environments
  local venv_dirs = { '.venv', 'venv', 'env', '.env' }
  for _, vdir in ipairs(venv_dirs) do
    local venv_python = root_dir .. '/' .. vdir .. '/bin/python'
    if vim.fn.filereadable(venv_python) == 1 then
      vim.notify('venv_python:' .. venv_python)
      python_path = venv_python
      break
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

  return python_path
end

return M
