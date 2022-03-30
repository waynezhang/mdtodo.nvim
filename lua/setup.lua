local function setup_commands()
  vim.cmd('command! TodoToggle lua require"mdtodo".toggle_todo()')
end

local function setup_syntax()
  vim.cmd([[
    fun s:markdown()
      syn keyword markdownTodo      contained TODO
      syn keyword markdownDoing     contained DOING
      syn keyword markdownDone      contained DONE
      syn keyword markdownCanceled  contained CANCELED
      syn region  markdownTodos start="^\s*- " end=" " oneline contains=markdownTodo,markdownDoing,markdownDone,markdownCanceled
      hi markdownTodo      cterm=bold, ctermfg=215
      hi markdownDoing     cterm=bold, ctermfg=151
      hi markdownDone      cterm=bold, ctermfg=145
      hi markdownCanceled  cterm=bold, ctermfg=243

      syn match markdownDateType /\(DEADLINE\|SCHEDULED\|CLOSED\):/ containedIn=ALL
      syn match markdownDate     /\(<\d\d\d\d-\d\d-\d\d \k\k\k\(\s\+[+\-\.]\?[+\-]\d\+[hdmwy]\)\?\(\s\+[+\-\.]\?[+\-]\d\+[hdmwy]\)\?>\)/ containedIn=ALL

      hi link markdownDateType PreProc
      hi link markdownDate     PreProc
    endfun

    augroup mdtodo
      autocmd!
      autocmd Syntax markdown call s:markdown()
    augroup end
  ]])
end

local function setup_telescope()
  require'telescope'.load_extension('mdtodo')
end

local M = {}

function M.setup()
  local has_telescope, _ = pcall(require, 'telescope')
  if not has_telescope then
    error('This plugins requires nvim-telescope/telescope.nvim')
  end

  setup_commands()
  setup_syntax()
  setup_telescope()
end

return M
