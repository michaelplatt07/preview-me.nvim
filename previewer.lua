local state = require("preview-me.state")
local config = require("preview-me.config")
local keybindings = require("preview-me.keybindings")
local windower = require("preview-me.windower")
local previewer = {}

-- TODO(map) Add ability to go up one directory level at a time in searching

-- Initialize the settings
config.init()

function previewer.open_references()
	-- Get the references and set them on the state
	local params = vim.lsp.util.make_position_params()
	local references, err = vim.lsp.buf_request_sync(0, "textDocument/references", params, 1000)
	if err then
		print(string.format("Got an error: %s", err))
	end
	state.set_rows(references)

	-- Callback for when the cursor moves around in the buffer
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		callback = function()
			state.update_selected_row()
			vim.api.nvim_buf_set_lines(state.previewBuf, 0, 6, false, {})
			-- TODO(map) Why is this being called several times? Probably because the cursor moves in several buffers? Limit this to one buffer autocmd only
			if state.currentPreview ~= nil then
				vim.api.nvim_buf_set_lines(state.previewBuf, 0, 6, false, state.currentPreview)
			end
		end,
	})
	-- TODO(map) Prevent going into insert mode all together with an autocmd

	-- Populate the buffers with the reference information and previews
	vim.api.nvim_buf_set_lines(state.referenceBuf, 0, 2, false, state.lines)
	vim.api.nvim_buf_set_lines(state.previewBuf, 0, 6, false, state.currentPreview)

	-- Create the windows and set them in the state
	state.referenceWin = windower.create_floating_window(
		state.referenceBuf,
		true,
		config.referencesWindowRow,
		config.referencesWindowCol,
		config.width,
		config.height
	)
	state.previewWin = windower.create_floating_window(
		state.previewBuf,
		false,
		config.previewWindowRow,
		config.previewWindowCol,
		config.width,
		config.height
	)

	-- Initialize key bindings
	keybindings.map_keys(state.referenceBuf)
end

return previewer
