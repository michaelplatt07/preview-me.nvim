local testUtils = require("tests.utils")

local state = nil

describe("state.set_rows", function()
	before_each(function()
		package.loaded["preview-me.state"] = nil
		state = require("preview-me.state")
		testUtils.reset_nvim()
	end)

	it("Should set the rows on the state with the references", function()
		-- Get the directory for the tests
		local path = vim.fn.getcwd()

		-- Get the references and pass them to the the state method
		state.set_rows(testUtils.lsp_response())

		-- Confirm the data is set correctly
		assert.is_same({
			"3: 15 | file://" .. path .. "/lua/tests/fixtures/base.lua",
			"5: 7 | file://" .. path .. "/lua/tests/fixtures/references.lua",
		}, state.lines)
		assert.is_same({
			{
				"local base = {}",
				"",
				"function base.sample_func()",
				"	-- Do nothing",
				"end",
				"",
			},
			{
				'local base = require("lua.tests.fixtures.base")',
				"local references = {}",
				"",
				"function references.reference_base_sample_func()",
				"	base.sample_func()",
				"end",
				"",
			},
		}, state.previews)
		assert.is_same({
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
		}, state.lineToDataMap)
		assert.is_same({
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
		}, state.currentLineData)
		assert.is_same({
			"local base = {}",
			"",
			"function base.sample_func()",
			"	-- Do nothing",
			"end",
			"",
		}, state.currentPreview)
	end)
end)
