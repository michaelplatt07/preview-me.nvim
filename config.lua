local config = {}

-- TODO(map) Make the height and width percentage configurable
function config.init()
	local rowHeight = vim.api.nvim_list_uis()[1].height
	local rowWidth = vim.api.nvim_list_uis()[1].width

	local current_win = vim.api.nvim_get_current_win()
	config.width = vim.api.nvim_win_get_width(current_win) * 0.75
	config.height = vim.api.nvim_win_get_height(current_win) * 0.75
	config.row = (rowHeight - config.height) * 0.5
	config.col = (rowWidth - config.width) * 0.5
end

return config
