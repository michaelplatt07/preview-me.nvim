local state = require("previewer.state")
local config = require("previewer.config")
local windower = require("previewer.windower")
local keybindings = require("previewer.keybindings")
local previewer = {}

-- TODO(map) Add ability to go up one directory level at a time in searching

-- Initialize the settings
config.init()

function close_window()
	vim.api.nvim_win_close(0, false)
end

function previewer.open_references()
	-- Get the references and set them on the state
	local params = vim.lsp.util.make_position_params()
	local references, err = vim.lsp.buf_request_sync(0, "textDocument/references", params, 1000)
	if err then
		print(string.format("Got an error: %s", err))
	end
	state.set_rows(references)

	-- Create new buffer and attach an autocmd for CursorMoved
	local buf = vim.api.nvim_create_buf(false, true)
	-- Callback for when the cursor moves around in the buffer
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		callback = function()
			state.update_selected_row()
		end,
	})
	-- TODO(map) Prevent going into insert mode all together with an autocmd

	-- Populate the lines
	vim.api.nvim_buf_set_lines(buf, 0, 2, false, state.lines)

	-- Create the window
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = config.row,
		col = config.col,
		width = config.width,
		height = config.height,
	})

	-- Initialize key bindings
	keybindings.map_keys(buf)
end

return previewer
