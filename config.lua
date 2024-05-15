local config = {}

-- TODO(map) Make the height and width percentage configurable
function config.init()
	local current_win = vim.api.nvim_get_current_win()
	config.width = math.floor(vim.api.nvim_win_get_width(current_win) * 0.4)
	config.height = math.floor(vim.api.nvim_win_get_height(current_win) * 0.4)
	config.referencesWindowRow = vim.api.nvim_win_get_height(current_win) * 0.1
	config.referencesWindowCol = vim.api.nvim_win_get_width(current_win) * 0.1
	config.previewWindowRow = vim.api.nvim_win_get_height(current_win) * 0.1
	config.previewWindowCol = vim.api.nvim_win_get_width(current_win) * 0.5
end

return config
