local previewer = require("preview-me.previewer")
local windower = require("preview-me.windower")
local keybindings = require("preview-me.keybindings")
local M = {}

function M.open()
	previewer.open_references()
end

function M.open_in_buf()
	windower.open_in_curr_window()
end

function M.split_v_ref()
	windower.split_v_ref()
end

function M.split_h_ref()
	windower.split_h_ref()
end

function M.open_in_new_tab()
	windower.open_in_new_tab()
end

function M.setup(config)
	if config ~= nil then
		if config.keys ~= nil then
			for func, custombind in pairs(config.keys) do
				keybindings.update_key_binding(func, custombind)
			end
		end
	end
end

return M
