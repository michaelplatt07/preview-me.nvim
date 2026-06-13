local state = {
	lines = nil,
	previews = nil,
	lineToDataMap = nil,
	currentLineData = nil,
	currentPreview = nil,
	lineBeforeCount = nil,
	lineAfterCount = nil,
	savedReferences = {},
	currentSavedReference = nil,
}

local util = require("preview-me.util")

function state.set_rows(references)
	local lines = {}
	local previews = {}
	local lineToDataMap = {}
	for _, reference in pairs(references) do
		if reference.result then
			for idx, data in pairs(reference.result) do
				local previewLines =
					util.generate_preview(data.uri, data.range.start.line, state.lineBeforeCount, state.lineAfterCount)
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

function state.clear_state()
	state.lines = {}
	state.previews = {}
	state.lineToDataMap = {}
	state.currentLineData = {}
	state.currentPreview = {}
end

function state.update_selected_row()
	state.currentLineData = state.lineToDataMap[vim.api.nvim_win_get_cursor(0)[1]]
	state.currentPreview = state.previews[vim.api.nvim_win_get_cursor(0)[1]]
end

function state.update_selected_reference()
	state.currentSavedReference = state.savedReferences[vim.api.nvim_win_get_cursor(0)[1]]
end

function state.save_reference(reference)
	table.insert(state.savedReferences, {
		data = reference,
		lineText = string.format(
			"%d: %d | %s",
			reference.range.start.line + 1,
			reference.range.start.character + 1,
			reference.uri
		),
	})
end

return state
