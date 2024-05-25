# Preview Me
A simple plugin for Neovim written in Lua that provides the ability to get references to functions and definitions using LSPs

## Install
This plugin can be installed through lazy in the normal way by declaring a file in the `lua/plugins` directory:
```lua
-- Contents of a file like previewme.lua
return {
	"michaelplatt07/preview-me.nvim",
	config = function()
		local previewme = require("preview-me")
		previewme.setup({
			keys = {
                -- Sample of applying custom key binding
				{ "n", "<leader>z", "<cmd>PreviewMeOpenInBuf<cr>", desc = "Opens the previewer" },
			},
		})
	end,
}
```
In the above code, the command to open the preview in the current buffer is being bound to the `<leader>z` button instead
of the default `<leader>o`.

Then in the `init.lua` file simply include the following to be able to call the plugin's entry command.
```lua
-- Binding the gr key combination to the PreviewMe command
vim.keymap.set("n", "gr", ":PreviewMe<cr>")
```

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
The plugin does not offer global keybindings. They are instead scoped to the preview buffer only so users won't have
to worry about collisions with global bindings. The default configurations are listed below but can be customized to
any individual's preferences:
| Mode | Binding | Method | Functionality |
|------|---------|--------|---------------|
| `n` | `<leader>o` | `open_in_curr_window` | Opens the file referenced on the current line in the current window in its own buffer. Equivalent to running `e FILE_NAME` |
| `n` | `<leader>t` | `open_in_new_tab` | Opens the file referenced on the current line in a new tab in a new buffer. Equivalent to running `tabe FILE_NAME` |
| `n` | `<leader>vs` | `open_in_curr_window` | Splits the current buffer vertically and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `vsplit` and then `e FILE_NAME` |
| `n` | `<leader>hs` | `open_in_curr_window` | Splits the current buffer horizontally and opens the file referenced on the current line of the preview window in the new split window. Equivalient to running `split` and then `e FILE_NAME` |
| `n` | `q` | `close_window` | Closes the preview window without opening any of the files |

### Commands
The following are commands that can be bound as desired:
| Command | Functionality |
|---------|---------------|
| `PreviewMe` | Opens the actual preview window |
| `PreviewMeOpenInBuf` | Opens the currently selected reference in the current buffer |
| `PreviewMeOpenVertSplit` | Opens the currently selected reference in a new buffer after donig a vertical split |
| `PreviewMeOpenHorSplit` | Opens the currently selected reference in a new buffer after doing a horizontal split |
| `PreviewMeOpenNewTab` | Opens the currently selected reference in a new buffer after opening it in a new tab |

