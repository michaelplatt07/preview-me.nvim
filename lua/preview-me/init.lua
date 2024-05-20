local previewer = require("preview-me.previewer")
local windower = require("preview-me.windower")
local M = {}

function M.open()
	previewer.open_references()
end

function M.open_in_buf()
	windower.open_in_curr_window()
end

function M.setup(config) end

return M
