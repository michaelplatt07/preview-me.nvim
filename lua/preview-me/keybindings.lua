local keybindings = {
	split_v = {
		mode = "n",
		key = "v",
	},
	split_h = { mode = "n", key = "h" },
	new_tab = { mode = "n", key = "t" },
	curr_window = {
		mode = "n",
		key = "o",
	},
	curr_window_enter = {
		mode = "n",
		key = "<CR>",
	},
	move_cursor_down = { mode = "n", key = "<C-n>" },
	move_cursor_up = { mode = "n", key = "<C-p>" },
	page_cursor_down = { mode = "n", key = "<C-d>" },
	page_cursor_up = { mode = "n", key = "<C-u>" },
	quit = { mode = "n", key = "q" },
	quit_esc = { mode = "n", key = "<Esc>" },
}

function keybindings.update_key_binding(func, custombind)
	keybindings[func].key = custombind
end

function keybindings.map_keys(buf)
	vim.keymap.set(keybindings.split_v.mode, keybindings.split_v.key, function()
		require("preview-me.windower").split_v_ref()
	end, { buffer = buf })
	vim.keymap.set(keybindings.split_h.mode, keybindings.split_h.key, function()
		require("preview-me.windower").split_h_ref()
	end, { buffer = buf })
	vim.keymap.set(keybindings.new_tab.mode, keybindings.new_tab.key, function()
		require("preview-me.windower").open_in_new_tab()
	end, { buffer = buf })
	vim.keymap.set(keybindings.curr_window.mode, keybindings.curr_window.key, function()
		vim.schedule(function()
			require("preview-me.windower").open_in_curr_window()
		end)
	end, {
		buffer = buf,
		expr = true,
		noremap = true,
		silent = true,
	})
	vim.keymap.set(keybindings.curr_window_enter.mode, keybindings.curr_window_enter.key, function()
		require("preview-me.windower").open_in_curr_window()
	end, { buffer = buf })
	vim.keymap.set(keybindings.move_cursor_down.mode, keybindings.move_cursor_down.key, function()
		require("preview-me.previewer").move_cursor_down()
	end, { buffer = buf })
	vim.keymap.set(keybindings.move_cursor_up.mode, keybindings.move_cursor_up.key, function()
		require("preview-me.previewer").move_cursor_up()
	end, { buffer = buf })
	vim.keymap.set(keybindings.page_cursor_down.mode, keybindings.page_cursor_down.key, function()
		require("preview-me.previewer").page_cursor_down()
	end, { buffer = buf })
	vim.keymap.set(keybindings.page_cursor_up.mode, keybindings.page_cursor_up.key, function()
		require("preview-me.previewer").page_cursor_up()
	end, { buffer = buf })
	vim.keymap.set(keybindings.quit.mode, keybindings.quit.key, function()
		require("preview-me.windower").close_window()
	end, { buffer = buf })
	vim.keymap.set(keybindings.quit_esc.mode, keybindings.quit_esc.key, function()
		require("preview-me.windower").close_window()
	end, { buffer = buf })
end

return keybindings
