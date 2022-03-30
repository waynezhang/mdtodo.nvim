local M = {}
local util = require('util')

function M.insert_date()
  -- DEADLINE: <2022-05-08 Sun +1w> SCHEDULED: <2022-03-31 Thu>
  local date = os.date('<%Y-%m-%d %a>')
  util.insert_text(date)
end

return M
