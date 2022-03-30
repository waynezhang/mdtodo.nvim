local M = {}

local keywords = { 'TODO', 'DOING', 'DONE' }
local regex = {}

local function setup_regex()
  if #regex == 0 then
    for _, keyword in pairs(keywords) do
      table.insert(regex, '^(%s*%- )('..keyword..')(%s*.*)$')
    end
  end
end

function M.rotate_todo(str)
  if str == nil then
    return
  end
  setup_regex()
  for idx, reg in pairs(regex) do
    if string.match(str, reg) then
      local next_state = keywords[idx % #keywords + 1]
      return string.gsub(str, reg, '%1'..next_state..'%3')
    end
  end
  return str
end

function M.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function M.log(msg)
  vim.api.nvim_echo({ { msg } }, true, {})
end

function M.splitstr(str, sp)
  if sp == nil then
    sp = "%s"
  end
  local result = {}
  for s in string.gmatch(str, "([^"..sp.."]+)") do
    table.insert(result, s)
  end
  return result
end

function M.insert_text(text)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = unpack(pos)
  row = row - 1
  local line = vim.api.nvim_get_current_line()
  if string.len(line) > 0 then
    col = col + 1
  end
  vim.api.nvim_buf_set_text(0, row, col, row, col, { text } )
end

return M
