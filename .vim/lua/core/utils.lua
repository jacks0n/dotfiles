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

return M
