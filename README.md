# Preview Me
A simple plugin for Neovim written in Lua that provides the ability to get references to functions and definitions using LSPs

## Install
This plugin is not currently fully configured for installation through all Neovim package managers. It currently only 
supports install by cloning the repository to the plugins folder and requiring it in the `init.lua` file like:

```lua
local previewer = require("previewer.previewer")
-- Set key binding of choice to the open_references function call
vim.keymap.set("n", "gr", previewer.open_references)
```

### Package Managers
Additional support for package managers coming soon...

### Dependencies
For the plugin to work, it requires an LSP running. Any LSP (such as those managed by the Mason plugin) should work to 
allow the plugin to make queries for references.

## Functionality
The plugin is designed to offer easy management for finding references in a project and opening the files in various ways.
As such, the functionality is fairly limited (as compared to a more robust plugin like Telescope) to the following:
* Find references to a function or variable
* Preview the line number, file containing the reference, and a preview around the reference for context
* Open the file in a number of ways:
** Open in the current tab
** Open in a new tab
** Open in a new buffer after splitting the current buffer vertically
** Open in a new buffer after splitting the current buffer horizontally

## Configuration
The plugin does not offer global keybindings. They are instead scoped to the preview buffer only so user's wont' have
to worry about collisions with global bindings. The default configurations are listed below but can be customized to
any individual's preferences:
| Mode | Binding | Method | Functionality |
|------|---------|--------|---------------|
| `n` | `<leader>o` | `open_in_curr_window` | Opens the file referenced on the current line in the current window in its own buffer. Equivalent to running `e FILE_NAME` |
| `n` | `<leader>t` | `open_in_new_tab` | Opens the file referenced on the current line in a new tab in a new buffer. Equivalent to running `tabe FILE_NAME` |
| `n` | `<leader>vs` | `open_in_curr_window` | Splits the current buffer vertically and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `vsplit` and then `e FILE_NAME` |
| `n` | `<leader>hs` | `open_in_curr_window` | Splits the current buffer horizontally and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `split` and then `e FILE_NAME` |
| `n` | `q` | `close_window` | Closes the preview window without opening any of the files |


