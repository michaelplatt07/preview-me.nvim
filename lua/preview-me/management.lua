local state = require("preview-me.state")
local management = {}

local managementBuffGroup = vim.api.nvim_create_augroup("previewme.buffer.tracking", { clear = true })

local function get_buff_watch_flags()
	local ignoreTypes = { "nofile" }
	local bufferModifiable = vim.api.nvim_buf_get_option(0, "modifiable")
	local buffType = vim.api.nvim_buf_get_option(0, "buftype")
	local shouldIgnore = false
	for _, bType in ipairs(ignoreTypes) do
		if buffType == bType then
			shouldIgnore = true
			break
		end
	end

	return shouldIgnore, bufferModifiable
end

function management.create_bindings()
	vim.api.nvim_create_autocmd("BufLeave", {
		group = managementBuffGroup,
		pattern = "*",
		callback = function()
			-- Get additional flags to apply for later logic
			local shouldIgnore, bufferModifiable = get_buff_watch_flags()

			if bufferModifiable and not shouldIgnore then
				state.lastExitedBuffer = vim.api.nvim_get_current_buf()
			end
		end,
	})
end

return management
