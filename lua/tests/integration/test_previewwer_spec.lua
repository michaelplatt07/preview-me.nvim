local utils = require("tests.utils")

local previewer = nil
local state = nil

describe("preview-me.move_cursor_down", function()
	before_each(function()
		package.loaded["preview-me.previewer"] = nil
		package.loaded["preview-me.state"] = nil
		previewer = require("preview-me.previewer")
		state = require("preview-me.state")
		utils.reset_nvim()
	end)

	it("Move the cursor position down one line", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewBuf = currentBuf
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 1)

		-- Call to move the cursor
		previewer.move_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 2)
	end)
end)

describe("preview-me.move_cursor_up", function()
	before_each(function()
		package.loaded["preview-me.previewer"] = nil
		package.loaded["preview-me.state"] = nil
		previewer = require("preview-me.previewer")
		state = require("preview-me.state")
		utils.reset_nvim()
	end)

	it("Move the cursor position up one line", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(state.previewWin, { 2, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 2)

		-- Call to move the cursor
		previewer.move_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 1)
	end)
end)

describe("preview-me.page_cursor_down", function()
	before_each(function()
		package.loaded["preview-me.previewer"] = nil
		package.loaded["preview-me.state"] = nil
		previewer = require("preview-me.previewer")
		state = require("preview-me.state")
		utils.reset_nvim()
	end)

	it("Move the cursor position down ten lines because there was enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_larger_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewBuf = currentBuf
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 1)

		-- Call to move the cursor
		previewer.page_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 11)
	end)

	it("Move the cursor position down five lines because there was not enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_larger_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewBuf = currentBuf
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(state.previewWin, { 14, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 14)

		-- Call to move the cursor
		previewer.page_cursor_down()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 19)
	end)
end)

describe("preview-me.page_cursor_up", function()
	before_each(function()
		package.loaded["preview-me.previewer"] = nil
		package.loaded["preview-me.state"] = nil
		previewer = require("preview-me.previewer")
		state = require("preview-me.state")
		utils.reset_nvim()
	end)

	it("Move the cursor position up ten lines because there was enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_larger_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewBuf = currentBuf
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(state.previewWin, { 14, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 14)

		-- Call to move the cursor
		previewer.page_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 4)
	end)

	it("Move the cursor position up five lines because there was not enough space", function()
		-- Set up a preview window like it would be in the actual plugin
		utils.load_larger_base_fixture()
		local currentBuf = vim.api.nvim_get_current_buf()
		state.previewBuf = currentBuf
		state.previewWin = vim.api.nvim_open_win(currentBuf, false, {
			relative = "editor",
			row = 0,
			col = 0,
			width = 10,
			height = 10,
		})

		-- Check that the cursor is in the right start position
		vim.api.nvim_win_set_cursor(state.previewWin, { 6, 0 })
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 6)

		-- Call to move the cursor
		previewer.page_cursor_up()

		-- Ensure the cursor moved
		assert.is_equal(vim.api.nvim_win_get_cursor(state.previewWin)[1], 1)
	end)
end)
