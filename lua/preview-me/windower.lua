local windower = {
	previewBuf = nil,
	referenceBuf = nil,
	previewWin = nil,
	referenceWin = nil,
}

local function get_full_window_dimensions()
	-- Gets the UI which should always actually be available. The else block is strictly for handling integrations as
	-- they are being ran through the --headless switch.
	local uis = vim.api.nvim_list_uis()
	if uis and uis[1] then
		return uis[1]
	else
		return {
			height = 100,
			width = 100,
		}
	end
end

function windower.init_required_buffers()
	if windower.previewBuf == nil then
		windower.previewBuf = vim.api.nvim_create_buf(false, true)
	end
	if windower.referenceBuf == nil then
		windower.referenceBuf = vim.api.nvim_create_buf(false, true)
	end
end

-- TODO(map) Is there a better way to pass the data here? Maybe create a struct to hold the buffer handle, window, and configs?
function windower.create_references_window()
	local windowInfo = get_full_window_dimensions()
	windower.referenceWin = vim.api.nvim_open_win(windower.referenceBuf, true, {
		relative = "editor",
		row = math.floor(windowInfo.height * 0.2),
		col = math.floor(windowInfo.width * 0.1),
		width = math.floor(windowInfo.width * 0.4),
		height = math.floor(windowInfo.height * 0.4),
		border = "double",
		style = "minimal",
		title = "Refernces",
	})
end

function windower.create_preview_window()
	local windowInfo = get_full_window_dimensions()
	windower.previewWin = vim.api.nvim_open_win(windower.previewBuf, false, {
		relative = "editor",
		row = math.floor(windowInfo.height * 0.2),
		col = math.floor(windowInfo.width * 0.51),
		width = math.floor(windowInfo.width * 0.4),
		height = math.floor(windowInfo.height * 0.4),
		border = "double",
		title = "Preview",
	})
end

function windower.close_window()
	-- Close the windows and buffers
	vim.api.nvim_win_close(windower.referenceWin, { force = true })
	vim.api.nvim_buf_delete(windower.referenceBuf, { force = true })
	vim.api.nvim_win_close(windower.previewWin, { force = true })
	vim.api.nvim_buf_delete(windower.previewBuf, { force = true })

	windower.previewBuf = nil
	windower.referenceBuf = nil
	windower.previewWin = nil
	windower.referenceWin = nil
end

return windower
