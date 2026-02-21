local state = require("preview-me.state")
local config = require("preview-me.config")
local keybindings = require("preview-me.keybindings")
local windower = require("preview-me.windower")
local util = require("preview-me.util")
local previewer = {}

-- TODO(map) Add ability to go up one directory level at a time in searching

-- Initialize the settings
config.init()

function previewer.open_references()
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
		buffer = state.referenceBuf,
		callback = function()
			if #state.lines > 0 then
				state.update_selected_row()
				vim.api.nvim_buf_set_lines(state.previewBuf, 0, #state.currentPreview, false, {})
				vim.api.nvim_buf_set_lines(state.previewBuf, 0, #state.currentPreview, false, state.currentPreview)

				-- Set the new currsor position based on the updated selected row
				if config.lineBeforeCount == nil then
					-- No config provided so we can just use the start line
					vim.api.nvim_win_set_cursor(state.previewWin, { state.currentLineData.range.start.line + 1, 0 })
				elseif config.lineBeforeCount > state.currentLineData.range.start.line then
					-- Case when line before count is greater than start line which means we are displaying all the lines before
					-- the line of interest so we can use the start line
					vim.api.nvim_win_set_cursor(state.previewWin, { state.currentLineData.range.start.line + 1, 0 })
				else
					-- Case when line before count is less than start line which means we need to set the new relative position
					-- based on the lineBeforeCount being the zero starting point
					vim.api.nvim_win_set_cursor(state.previewWin, { config.lineBeforeCount + 1, 0 })
				end
			end
		end,
	})

	-- Populate the buffers with the reference information and previews
	if #state.lines > 0 then
		vim.api.nvim_buf_set_lines(state.referenceBuf, 0, 2, false, state.lines)
		vim.api.nvim_buf_set_lines(state.previewBuf, 0, 6, false, state.currentPreview)
	end

	-- Set the filetype for the buffer
	vim.api.nvim_buf_set_option(state.previewBuf, "filetype", util.get_file_type(state.currentLineData.uri))

	-- Create the windows and set them in the state
	state.referenceWin = windower.create_references_window(
		state.referenceBuf,
		true,
		config.referencesWindowRow,
		config.referencesWindowCol,
		config.width,
		config.height,
		"References"
	)
	state.previewWin = windower.create_preview_window(
		state.previewBuf,
		false,
		config.previewWindowRow,
		config.previewWindowCol,
		config.width,
		config.height,
		"Preview"
	)
	-- Set the cursor to the correct line
	if config.lineBeforeCount == nil then
		-- No config provided so we can just use the start line
		vim.api.nvim_win_set_cursor(state.previewWin, { state.currentLineData.range.start.line + 1, 0 })
	elseif config.lineBeforeCount > state.currentLineData.range.start.line then
		-- Case when line before count is greater than start line which means we are displaying all the lines before
		-- the line of interest so we can use the start line
		vim.api.nvim_win_set_cursor(state.previewWin, { state.currentLineData.range.start.line + 1, 0 })
	else
		-- Case when line before count is less than start line which means we need to set the new relative position
		-- based on the lineBeforeCount being the zero starting point
		vim.api.nvim_win_set_cursor(state.previewWin, { config.lineBeforeCount + 1, 0 })
	end

	-- Initialize key bindings
	keybindings.map_keys(state.referenceBuf)

	-- Set buffer to not modifiable
	vim.api.nvim_buf_set_option(state.referenceBuf, "modifiable", false)
	-- TODO(map) Figure out how to make the preview buffer not be able to me modified
end

function previewer.move_cursor_down()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(state.previewWin)[1]
	if cursorPos + 1 < #vim.api.nvim_buf_get_lines(state.previewBuf, 0, -1, true) then
		vim.api.nvim_win_set_cursor(state.previewWin, { cursorPos + 1, 0 })
	end
end

function previewer.page_cursor_down()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(state.previewWin)[1]
	local lineCount = #vim.api.nvim_buf_get_lines(state.previewBuf, 0, -1, true)
	if cursorPos + 10 < lineCount then
		vim.api.nvim_win_set_cursor(state.previewWin, { cursorPos + 10, 0 })
	else
		vim.api.nvim_win_set_cursor(state.previewWin, { lineCount, 0 })
	end
end

function previewer.move_cursor_up()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(state.previewWin)[1]
	if cursorPos - 1 > 0 then
		vim.api.nvim_win_set_cursor(state.previewWin, { cursorPos - 1, 0 })
	end
end

function previewer.page_cursor_up()
	-- Get the preview window handle
	local cursorPos = vim.api.nvim_win_get_cursor(state.previewWin)[1]
	if cursorPos - 10 > 0 then
		vim.api.nvim_win_set_cursor(state.previewWin, { cursorPos - 10, 0 })
	else
		vim.api.nvim_win_set_cursor(state.previewWin, { 1, 0 })
	end
end

return previewer
