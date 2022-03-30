local finder = require('telescope._extensions.finder')
local telescope = require('telescope')
local telescope_action_state = require('telescope.actions.state')

local action = require('action')

local function search()
  local keywords = { 'TODO', 'DOING' }
  local opts = {}
  opts.search = '^\\s*- ('..table.concat(keywords, '|')..').*'
  opts.prompt_title = "Find Todo"
  opts.layout_strategy = 'vertical'
  opts.cache_picker = false
  finder.grep(opts)
end

local function toggle_in_file(prompt_bufnr)
  local selection = telescope_action_state.get_selected_entry()
  local picker = telescope_action_state.get_current_picker(prompt_bufnr)
  local row = picker:get_selection_row()
  if selection == nil or selection.lnum == nil then
    return
  end
  local filename = selection.cwd .. package.config:sub(1,1) .. selection.filename
  local line = selection.lnum
  action.toggle_todo_in_file(filename, line)
  picker:refresh(finder.gen_new_finder(picker.opts))
  -- workaround to keep selection
  vim.defer_fn(function ()
    picker:set_selection(row)
  end, 100)
end

local function setup()
  telescope.setup {
    defaults = {
      mappings = {
        n = {
          ['t'] = toggle_in_file
        },
        i = {
          ['<C-t>'] = toggle_in_file
        },
      }
    }
  }
end

return telescope.register_extension {
  setup = setup,
  exports = {
    mdtodo = search
  }
}
