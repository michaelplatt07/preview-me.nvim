local state = require("preview-me.state")
local keybindings = require("preview-me.keybindings")
local windower = require("preview-me.windower")
local util = require("preview-me.util")
local previewer = {}

-- TODO(map) Add ability to go up one directory level at a time in searching

-- Initialize the settings

function previewer.open_references()
	-- Init what we need
	windower.init_required_buffers()

	-- Get the references and set them on the state
	local params = vim.lsp.util.make_position_params()
	params.context = { includeDeclaration = true }
	local references, err = vim.lsp.buf_request_sync(0, "textDocument/references", params, 5000)
	if err then
		print(string.format("Got an error: %s", err))
	end
	state.set_rows(references)

	-- Callback for when the cursor moves around in the buffer
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		buffer = windower.referenceBuf,
		callback = function()
			if #state.lines > 0 then
				state.update_selected_row()
				vim.api.nvim_buf_set_lines(windower.previewBuf, 0, #state.currentPreview, false, {})
				vim.api.nvim_buf_set_lines(windower.previewBuf, 0, #state.currentPreview, false, state.currentPreview)

				-- Set the new currsor position based on the updated selected row
				if state.lineBeforeCount == nil then
					-- No state provided so we can just use the start line
					vim.api.nvim_win_set_cursor(windower.previewWin, { state.currentLineData.range.start.line + 1, 0 })
				elseif state.lineBeforeCount > state.currentLineData.range.start.line then
					-- Case when line before count is greater than start line which means we are displaying all the lines before
					-- the line of interest so we can use the start line
					vim.api.nvim_win_set_cursor(windower.previewWin, { state.currentLineData.range.start.line + 1, 0 })
				else
					-- Case when line before count is less than start line which means we need to set the new relative position
					-- based on the lineBeforeCount being the zero starting point
					vim.api.nvim_win_set_cursor(windower.previewWin, { state.lineBeforeCount + 1, 0 })
				end
			end
		end,
	})

	-- Populate the buffers with the reference information and previews
	if #state.lines > 0 then
		vim.api.nvim_buf_set_lines(windower.referenceBuf, 0, 2, false, state.lines)
		vim.api.nvim_buf_set_lines(windower.previewBuf, 0, 6, false, state.currentPreview)
	end

	-- Set the filetype for the buffer
	vim.api.nvim_buf_set_option(windower.previewBuf, "filetype", util.get_file_type(state.currentLineData.uri))

	-- Create the windows and set them in the state
	windower.create_references_window()
	windower.create_preview_window()
	-- Set the cursor to the correct line
	if state.lineBeforeCount == nil then
		-- No state provided so we can just use the start line
		vim.api.nvim_win_set_cursor(windower.previewWin, { state.currentLineData.range.start.line + 1, 0 })
	elseif state.lineBeforeCount > state.currentLineData.range.start.line then
		-- Case when line before count is greater than start line which means we are displaying all the lines before
		-- the line of interest so we can use the start line
		vim.api.nvim_win_set_cursor(windower.previewWin, { state.currentLineData.range.start.line + 1, 0 })
	else
		-- Case when line before count is less than start line which means we need to set the new relative position
		-- based on the lineBeforeCount being the zero starting point
		vim.api.nvim_win_set_cursor(windower.previewWin, { state.lineBeforeCount + 1, 0 })
	end

	-- Initialize key bindings
	keybindings.map_keys(windower.referenceBuf)

	-- Set buffer to not modifiable
	vim.api.nvim_buf_set_option(windower.referenceBuf, "modifiable", false)
	vim.api.nvim_buf_set_option(windower.previewBuf, "modifiable", false)
end

local function _get_buff_data()
	local data = state.currentLineData
	return data.uri, data.range.start.line, data.range.start.character
end

function previewer.open_in_curr_window()
	-- Get the data on the currently selected line from the state
	local uri, row, col = _get_buff_data()

	-- Close the plugin
	windower.close_window()

	-- Grab the current window so we can set its buffer to the selected buffer
	local currWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_buf_set_option(buf, "buftype", "")
	vim.api.nvim_buf_set_option(buf, "swapfile", true)
	vim.api.nvim_buf_set_option(buf, "buflisted", true)
	vim.api.nvim_win_set_buf(currWindow, buf)
	vim.api.nvim_win_set_cursor(currWindow, { row + 1, col })

	-- Clean up the state
	state.clear_state()
end

function previewer.split_v_ref()
	-- Get the data on the currently selected line from the state
	local uri, row, col = _get_buff_data()

	-- Close the plugin
	windower.close_window()

	-- Split and set the buffer accordingly
	vim.cmd("vsplit")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_buf_set_option(buf, "buftype", "")
	vim.api.nvim_buf_set_option(buf, "swapfile", true)
	vim.api.nvim_buf_set_option(buf, "buflisted", true)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })

	-- Clean up the state
	state.clear_state()
end

function previewer.split_h_ref()
	-- Get the data on the currently selected line from the state
	local uri, row, col = _get_buff_data()

	-- Close the plugin
	windower.close_window()

	-- Split and set the buffer accordingly
	vim.cmd("split")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_buf_set_option(buf, "buftype", "")
	vim.api.nvim_buf_set_option(buf, "swapfile", true)
	vim.api.nvim_buf_set_option(buf, "buflisted", true)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })

	-- Clean up the state
	state.clear_state()
end

function previewer.open_in_new_tab()
	-- Get the data on the currently selected line from the state
	local uri, row, col = _get_buff_data()

	-- Close the plugin
	windower.close_window()

	-- Split and set the buffer accordingly
	vim.cmd("tabe")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_buf_set_option(buf, "buftype", "")
	vim.api.nvim_buf_set_option(buf, "swapfile", true)
	vim.api.nvim_buf_set_option(buf, "buflisted", true)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })

	-- Clean up the state
	state.clear_state()
end

function previewer.move_cursor_down()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(windower.previewWin)[1]
	if cursorPos + 1 < #vim.api.nvim_buf_get_lines(windower.previewBuf, 0, -1, true) then
		vim.api.nvim_win_set_cursor(windower.previewWin, { cursorPos + 1, 0 })
	end
end

function previewer.page_cursor_down()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(windower.previewWin)[1]
	local lineCount = #vim.api.nvim_buf_get_lines(windower.previewBuf, 0, -1, true)
	if cursorPos + 10 < lineCount then
		vim.api.nvim_win_set_cursor(windower.previewWin, { cursorPos + 10, 0 })
	else
		vim.api.nvim_win_set_cursor(windower.previewWin, { lineCount, 0 })
	end
end

function previewer.move_cursor_up()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(windower.previewWin)[1]
	if cursorPos - 1 > 0 then
		vim.api.nvim_win_set_cursor(windower.previewWin, { cursorPos - 1, 0 })
	end
end

function previewer.page_cursor_up()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(windower.previewWin)[1]
	if cursorPos - 10 > 0 then
		vim.api.nvim_win_set_cursor(windower.previewWin, { cursorPos - 10, 0 })
	else
		vim.api.nvim_win_set_cursor(windower.previewWin, { 1, 0 })
	end
end

function previewer.set_up_state(config)
	if config ~= nil then
		if config.keys ~= nil then
			for func, custombind in pairs(config.keys) do
				keybindings.update_key_binding(func, custombind)
			end
		end
		if config.preferences ~= nil then
			for property, value in pairs(config.preferences) do
				if property == "linesBefore" then
					state.lineBeforeCount = value
				elseif property == "linesAfter" then
					state.lineAfterCount = value
				else
				end
			end
		end
	end
end

return previewer
