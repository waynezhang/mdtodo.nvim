local M = {}

local rotate_todo = require('util').rotate_todo

function M.toggle_todo()
  local line = vim.api.nvim_get_current_line()
  local rotated = rotate_todo(line)
  vim.api.nvim_set_current_line(rotated)
end

function M.toggle_todo_in_file(filename, line)
  local file, err = io.open(filename, 'r')
  if not file then
    error(err)
    return
  end
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  io.close(file)

  lines[line] = rotate_todo(lines[line])

  file = io.open(filename, 'w')
  for _, value in ipairs(lines) do
    file:write(value..'\n')
  end
  io.close(file)
end

function M.insert_date()
  require('date').insert_date()
end

return M
