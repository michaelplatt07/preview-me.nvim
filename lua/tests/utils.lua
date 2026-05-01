local utils = {}

function utils.reset_nvim()
	vim.cmd("silent! %bwipeout!")
	vim.cmd("enew!")
	vim.cmd("silent! only")

	-- Handle floating windows if they are still opened
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end
end

function utils.lsp_response()
	local path = vim.fn.getcwd()
	return {
		{
			context = {
				bufnr = 260,
				client_id = 1,
				method = "textDocument/references",
				params = {
					context = {
						includeDeclaration = true,
					},
					position = {
						character = 14,
						line = 2,
					},
					textDocument = {
						uri = "file://" .. path .. "/lua/tests/fixtures/base.lua",
					},
				},
				version = 0,
			},
			result = {
				{
					range = {
						["end"] = {
							character = 25,
							line = 2,
						},
						start = {
							character = 14,
							line = 2,
						},
					},
					uri = "file://" .. path .. "/lua/tests/fixtures/base.lua",
				},
				{
					range = {
						["end"] = {
							character = 17,
							line = 4,
						},
						start = {
							character = 6,
							line = 4,
						},
					},
					uri = "file://" .. path .. "/lua/tests/fixtures/references.lua",
				},
			},
		},
	}
end

function utils.load_base_fixture()
	vim.api.nvim_cmd({
		cmd = "edit",
		args = { "lua/tests/fixtures/base.lua" },
	}, {})
end

function utils.load_larger_base_fixture()
	vim.api.nvim_cmd({
		cmd = "edit",
		args = { "lua/tests/fixtures/larger_base.lua" },
	}, {})
end

return utils
