# Preview Me
A simple plugin for Neovim written in Lua that provides the ability to get references to functions and definitions using LSPs

### Dependencies
For the plugin to work, it requires an LSP running. Any LSP (such as those managed by the Mason plugin) should work to 
allow the plugin to make queries for references.

## Features
Below is a list of commands that are exposed as features for the plugin:
| Command | Functionality |
|---------|---------------|
| `PreviewMe` | Opens the actual preview window |
| `PreviewMeOpenInBuf` | Opens the currently selected reference in the current buffer |
| `PreviewMeOpenVertSplit` | Opens the currently selected reference in a new buffer after donig a vertical split |
| `PreviewMeOpenHorSplit` | Opens the currently selected reference in a new buffer after doing a horizontal split |
| `PreviewMeOpenNewTab` | Opens the currently selected reference in a new buffer after opening it in a new tab |


## Installation
This plugin can be installed through lazy in the normal way by declaring a file in the `lua/plugins` directory:
```lua
-- Contents of a file like previewme.lua
return {
	"michaelplatt07/preview-me.nvim",
	config = function()
		local previewme = require("preview-me")
		previewme.setup({
			keys = {
				curr_window = { "<leader>z" },
			},
            preferences = {
                linesBefore = 3,
                linesAfter = 10,
            },
            }
		})
	end,
}
```
**Config Options Explained**
* `linesBefore`: Specifies the number of given lines shown before the line in question in the preview window
* `linesAfter`: Specifies the number of given lines shown after the line in question in the preview window

## Configuration
Below is a list of keybindings that are set by default to the scope of the preview windows created by the plugin:
| Mode | Binding | Method | Functionality |
|------|---------|--------|---------------|
| `n` | `o` | `open_in_curr_window` | Opens the file referenced on the current line in the current window in its own buffer. Equivalent to running `e FILE_NAME` |
| `n` | `<CR>` | `open_in_curr_window` | Opens the file referenced on the current line in the current window in its own buffer. Equivalent to running `e FILE_NAME` |
| `n` | `t` | `open_in_new_tab` | Opens the file referenced on the current line in a new tab in a new buffer. Equivalent to running `tabe FILE_NAME` |
| `n` | `v` | `open_in_curr_window` | Splits the current buffer vertically and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `vsplit` and then `e FILE_NAME` |
| `n` | `h` | `open_in_curr_window` | Splits the current buffer horizontally and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `split` and then `e FILE_NAME` |
| `n` | `q` | `close_window` | Closes the preview window without opening any of the files |
| `n` | `<Esc>` | `close_window` | Closes the preview window without opening any of the files |

To configure a custom keybinding provide the requested binding

