local config = {}

function config.init()
	local rowHeight = vim.api.nvim_list_uis()[1].height
	local rowWidth = vim.api.nvim_list_uis()[1].width
	config.width = 100 -- TODO(map) Get the width and height to be calculated instead of hard values
	config.height = 20

	config.row = (rowHeight - config.height) * 0.5
	config.col = (rowWidth - config.width) * 0.5
end

return config
