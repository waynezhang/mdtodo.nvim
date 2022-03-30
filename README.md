# mdtodo.nvim

A simple plugin to add simple task management features to markdown files.

This is just some toy project and not fully tested. Please use it at your own risk.

## Features

1. Four statuses are supported: `TODO`, `DOING`, `DONE` and `CANCELED`.  
  The task format is inspired by [logseq](http://logseq.com) but not intented to be fully compatible with it.
2. Toggle task by `:TodoToggle` command.
3. Search all `TODO` and `DOING` from files in current directory powered by `telescope.nvim`.

## Installation

`telescope.nvim` is required by this plugin.

1. Install this plugin by your favorite plugin manager.
1. Add `setup` to your `init.lua`.

    ```lua
    require'mdtodo'.setup({})
    ```
  
## Screenshots

<img width="799" alt="Screen Shot 2022-03-30 at 18 30 33" src="https://user-images.githubusercontent.com/480052/160799846-7ff65b34-60e7-47f0-9dd7-4f67348ee9c9.png">
<img width="799" alt="Screen Shot 2022-03-30 at 18 31 15" src="https://user-images.githubusercontent.com/480052/160799898-1dc11ea7-8a9e-4e3e-bf20-9d04a131b399.png">
