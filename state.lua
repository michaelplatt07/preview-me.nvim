local state = {}

local util = require("previewer.util")

function state.set_rows(references)
	local lines = {}
	local lineToDataMap = {}
	for _, reference in ipairs(references) do
		if reference.result then
			for idx, data in ipairs(reference.result) do
				print("uri = ", data.uri)
				local preview = util.generate_preview(data.uri, data.range.start.line)
				lineToDataMap[idx] = data
				-- TODO(map) Add the file name here as nice to have
				table.insert(
					lines,
					string.format("%d: %d | %s", data.range.start.line + 1, data.range.start.character + 1, preview)
				)
			end
		end
	end
	state.lines = lines
	state.lineToDataMap = lineToDataMap
	state.currentLineData = lineToDataMap[1]
end

function state.update_selected_row()
	state.currentLineData = state.lineToDataMap[vim.api.nvim_win_get_cursor(0)[1]]
end

return state
