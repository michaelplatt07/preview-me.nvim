local previewer = require("preview-me.previewer")
local M = {}

function M.open()
	previewer.open_references()
end

function M.setup(config) end

return M
