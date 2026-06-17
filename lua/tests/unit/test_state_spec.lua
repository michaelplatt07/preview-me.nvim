-- Mock Vim so we can mock returns on method bindings
_G.vim = {
	fn = {},
}
-- End mocking

local testUtils = require("tests.utils")

local state = nil

local function reset_packages()
	package.loaded["preview-me.state"] = nil
	state = require("preview-me.state")
end

describe("state.store_reference", function()
	local stub_getcwd

	before_each(function()
		stub_getcwd = stub(vim.fn, "getcwd", function()
			return "sample/path"
		end)
		reset_packages()
	end)

	after_each(function()
		stub_getcwd:revert()
	end)

	it("Should store the reference in a way to be used later", function()
		-- Get a reference for the data insertion
		local data = testUtils.lsp_response()

		-- Make the call
		state.save_reference(data[1].result[1])

		-- Assert the state is setup correctly
		assert.is_same(state.savedReferences, {
			{ data = data[1].result[1], lineText = "3: 15 | file://sample/path/lua/tests/fixtures/base.lua" },
		})
	end)
end)
