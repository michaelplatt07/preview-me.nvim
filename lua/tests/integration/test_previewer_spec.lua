local utils = require("tests.utils")

local previewer = nil
local state = nil
local windower = nil

local function reset_packages()
	package.loaded["preview-me.previewer"] = nil
	package.loaded["preview-me.state"] = nil
	package.loaded["preview-me.windower"] = nil
	previewer = require("preview-me.previewer")
	state = require("preview-me.state")
	windower = require("preview-me.windower")
end

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

		-- Move the definition of sample_func
		vim.api.nvim_win_set_cursor(0, { 3, 14 })
	end)
end)

describe("preview-me.move_cursor_down", function()
	before_each(function()
		reset_packages()
		utils.reset_nvim()
	end)

	it("Move the cursor position down one line", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_base_fixture()

		-- Check that the cursor is in the right start position
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 1)

		-- Call to move the cursor
		previewer.move_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 2)
	end)
end)

describe("preview-me.move_cursor_up", function()
	before_each(function()
		reset_packages()
		utils.reset_nvim()
	end)

	it("Move the cursor position up one line", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_base_fixture()

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(windower.previewWin, { 2, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 2)

		-- Call to move the cursor
		previewer.move_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 1)
	end)
end)

describe("preview-me.page_cursor_down", function()
	before_each(function()
		reset_packages()
		utils.reset_nvim()
	end)

	it("Move the cursor position down ten lines because there was enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_larger_base_fixture()

		-- Check that the cursor is in the right start position
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 1)

		-- Call to move the cursor
		previewer.page_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 11)
	end)

	it("Move the cursor position down five lines because there was not enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_larger_base_fixture()

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(windower.previewWin, { 14, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 14)

		-- Call to move the cursor
		previewer.page_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 19)
	end)
end)

describe("preview-me.page_cursor_up", function()
	before_each(function()
		reset_packages()
		utils.reset_nvim()
	end)

	it("Move the cursor position up ten lines because there was enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_larger_base_fixture()

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(windower.previewWin, { 14, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 14)

		-- Call to move the cursor
		previewer.page_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 4)
	end)

	it("Move the cursor position up five lines because there was not enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		windower.init_required_buffers()
		windower.create_preview_window()
		vim.api.nvim_set_current_win(windower.previewWin)
		utils.load_larger_base_fixture()

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(windower.previewWin, { 6, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 6)

		-- Call to move the cursor
		previewer.page_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(windower.previewWin)[1], 1)
	end)
end)
