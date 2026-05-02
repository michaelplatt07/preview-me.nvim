local testUtils = require("tests.utils")

local windower = nil

describe("windower.init_required_buffers", function()
	before_each(function()
		package.loaded["preview-me.windower"] = nil
		windower = require("preview-me.windower")
		testUtils.reset_nvim()
	end)

	it("Should set the required buffers", function()
		assert.is_nil(windower.previewBuf)
		assert.is_nil(windower.referenceBuf)

		-- Make the call
		windower.init_required_buffers()

		-- Assert the buffers are set
		assert.is_not_nil(windower.previewBuf)
		assert.is_not_nil(windower.referenceBuf)
	end)
end)

describe("windower.window_management", function()
	before_each(function()
		package.loaded["preview-me.windower"] = nil
		windower = require("preview-me.windower")
		testUtils.reset_nvim()
	end)

	it("Should successfully create the preview window", function()
		assert.is_nil(windower.previewBuf)
		assert.is_nil(windower.referenceBuf)
		assert.is_nil(windower.previewWin)

		-- Make the call
		windower.init_required_buffers()
		windower.create_preview_window()

		-- Assert the buffers are set
		assert.is_not_nil(windower.previewBuf)
		assert.is_not_nil(windower.referenceBuf)
		assert.is_not_nil(windower.previewWin)
	end)

	it("Should successfully create the references window", function()
		assert.is_nil(windower.previewBuf)
		assert.is_nil(windower.referenceBuf)
		assert.is_nil(windower.referenceWin)

		-- Make the call
		windower.init_required_buffers()
		windower.create_references_window()

		-- Assert the buffers are set
		assert.is_not_nil(windower.previewBuf)
		assert.is_not_nil(windower.referenceBuf)
		assert.is_not_nil(windower.referenceWin)
	end)

	it("Should successfully close the windows", function()
		assert.is_nil(windower.previewBuf)
		assert.is_nil(windower.previewWin)
		assert.is_nil(windower.referenceBuf)
		assert.is_nil(windower.referenceWin)

		-- Open the windows
		windower.init_required_buffers()
		windower.create_references_window()
		windower.create_preview_window()

		-- Assert the buffers are set
		assert.is_not_nil(windower.previewBuf)
		assert.is_not_nil(windower.previewWin)
		assert.is_not_nil(windower.referenceBuf)
		assert.is_not_nil(windower.referenceWin)

		-- Close the windows and clean up
		windower.close_window()

		-- Assert the buffers are no longer set
		assert.is_nil(windower.previewBuf)
		assert.is_nil(windower.previewWin)
		assert.is_nil(windower.referenceBuf)
		assert.is_nil(windower.referenceWin)
	end)
end)
