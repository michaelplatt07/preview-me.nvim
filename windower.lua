local state = require("preview-me.state")

local windower = {}

-- TODO(map) Is there a better way to pass the data here? Maybe create a struct to hold the buffer handle, window, and configs?
function windower.create_floating_window(buf, active, row, col, width, height)
	return vim.api.nvim_open_win(buf, active, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
	})
end

function windower.close_window()
	vim.api.nvim_win_close(state.referenceWin, false)
	vim.api.nvim_win_close(state.previewWin, false)
end

-- TODO(map) Refactor to pull out common functionality so I don't have to change things in each of the methods
function windower.open_in_curr_window()
	local data = state.currentLineData
	local uri = data.uri
	local row = data.range.start.line
	local col = data.range.start.character
	vim.api.nvim_win_close(state.referenceWin, false)
	vim.api.nvim_win_close(state.previewWin, false)
	local currWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	-- TODO(map) These should be declaring new buffers with names and such
	vim.api.nvim_win_set_buf(currWindow, buf)
	vim.api.nvim_win_set_cursor(currWindow, { row + 1, col })
end

function windower.open_in_new_tab()
	local data = state.currentLineData
	local uri = data.uri
	local row = data.range.start.line
	local col = data.range.start.character
	vim.api.nvim_win_close(state.referenceWin, false)
	vim.api.nvim_win_close(state.previewWin, false)
	vim.cmd("tabe")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })
end

function windower.split_v_ref()
	local data = state.currentLineData
	local uri = data.uri
	local row = data.range.start.line
	local col = data.range.start.character
	vim.api.nvim_win_close(state.referenceWin, false)
	vim.api.nvim_win_close(state.previewWin, false)
	vim.cmd("vsplit")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })
end

function windower.split_h_ref()
	local data = state.currentLineData
	local uri = data.uri
	local row = data.range.start.line
	local col = data.range.start.character
	vim.api.nvim_win_close(state.referenceWin, false)
	vim.api.nvim_win_close(state.previewWin, false)
	vim.cmd("split")
	local newCurWindow = vim.api.nvim_get_current_win()
	local buf = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(newCurWindow, buf)
	vim.api.nvim_win_set_cursor(newCurWindow, { row + 1, col })
end

return windower
