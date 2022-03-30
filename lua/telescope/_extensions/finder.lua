local conf = require("telescope.config").values
local make_entry = require "telescope.make_entry"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local dump = require('util').dump

local function new_previewer()
  local cwd = vim.loop.cwd()
  local Path = require "plenary.path"
  local from_entry = require "telescope.from_entry"
  local ns_previewer = vim.api.nvim_create_namespace "telescope.previewers"

  local jump_to_line = function(self, bufnr, lnum)
    pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_previewer, 0, -1)
    if lnum and lnum > 0 then
      pcall(vim.api.nvim_buf_add_highlight, bufnr, ns_previewer, "TelescopePreviewLine", lnum - 1, 0, -1)
      pcall(vim.api.nvim_win_set_cursor, self.state.winid, { lnum, 0 })
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd "norm! zz"
      end)
    end
  end

  return previewers.new_buffer_previewer {
    title = "Preview",
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, true)):normalize(cwd)
    end,

    get_buffer_by_name = nil,

    define_preview = function(self, entry, _)
      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end

      -- Workaround for unnamed buffer when using builtin.buffer
      if entry.bufnr and (p == "[No Name]" or vim.api.nvim_buf_get_option(entry.bufnr, "buftype") ~= "") then
        local lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        jump_to_line(self, self.state.bufnr, entry.lnum)
      else
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
          preview = nil,
          callback = function(bufnr)
            jump_to_line(self, bufnr, entry.lnum)
          end,
        })
      end
    end,
  }
end

local function gen_new_finder(opts)
  local vimgrep_arguments = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
  local args = vim.tbl_flatten {
    "rg",
    vimgrep_arguments,
    "--",
    opts.search,
    '.'
  }
  return finders.new_oneshot_job(
    args,
    {
      entry_maker = make_entry.gen_from_vimgrep(opts)
    })
end

local function grep(opts)
  local previewer = conf.grep_previewer(opts)
  local picker = pickers.new(opts, {
      finder = gen_new_finder(opts),
      previewer = new_previewer(),
      sorter = conf.file_sorter(opts),
    })
  picker.opts = opts
  picker:find()
end

return {
  grep = grep,
  gen_new_finder = gen_new_finder,
}
