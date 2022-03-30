local M = {}

local action = require('action')
local setup = require('setup')

M.setup = setup.setup
M.toggle_todo = action.toggle_todo
M.insert_date = action.insert_date

return M
