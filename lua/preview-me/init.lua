local previewer = require("preview-me.previewer")
local M = {}

function M.open()
	previewer.open_references()
end

function M.open_in_buf()
	previewer.open_in_curr_window()
end

function M.split_v_ref()
	previewer.split_v_ref()
end

function M.split_h_ref()
	previewer.split_h_ref()
end

function M.open_in_new_tab()
	previewer.open_in_new_tab()
end

function M.setup(config)
	previewer.set_up_state(config)
end

return M
