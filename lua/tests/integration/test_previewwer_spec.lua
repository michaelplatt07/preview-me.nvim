local previewer = nil

describe("preview-me.open_references", function()
	before_each(function()
		package.loaded["preview-me.previewer"] = nil
		previewer = require("preview-me.previewer")
	end)

	it("Should open the buffer with two references to the base.sample_func", function()
		-- Open the fixture in the current buffer
		vim.api.nvim_cmd({
			cmd = "edit",
			args = { "lua/tests/fixtures/base.lua" },
		}, {})
		local current_buf = vim.api.nvim_get_current_buf()

		assert.same(vim.api.nvim_buf_get_lines(current_buf, 0, -1, true), {
			"local base = {}",
			"",
			"function base.sample_func()",
			"\t-- Do nothing",
			"end",
			"",
			"return base",
		})
	end)
end)
