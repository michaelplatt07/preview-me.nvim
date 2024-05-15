local state = {
	previewBuf = vim.api.nvim_create_buf(false, true),
	referenceBuf = vim.api.nvim_create_buf(false, true),
	previewWin = nil,
	referenceWin = nil,
}

local util = require("preview-me.util")

function state.set_rows(references)
	local lines = {}
	local previews = {}
	local lineToDataMap = {}
	for _, reference in ipairs(references) do
		if reference.result then
			for idx, data in ipairs(reference.result) do
				print("uri = ", data.uri)
				local previewLines = util.generate_preview(data.uri, data.range.start.line)
				lineToDataMap[idx] = data
				table.insert(
					lines,
					string.format("%d: %d | %s", data.range.start.line + 1, data.range.start.character + 1, data.uri)
				)
				table.insert(previews, previewLines)
			end
		end
	end
	state.lines = lines
	state.previews = previews
	state.lineToDataMap = lineToDataMap
	state.currentLineData = lineToDataMap[1]
	state.currentPreview = previews[1]
end

function state.update_selected_row()
	state.currentLineData = state.lineToDataMap[vim.api.nvim_win_get_cursor(0)[1]]
	state.currentPreview = state.previews[vim.api.nvim_win_get_cursor(0)[1]]
end

return state
