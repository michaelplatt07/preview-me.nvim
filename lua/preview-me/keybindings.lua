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
	quit = { mode = "n", key = "q" },
	quit_esc = { mode = "n", key = "<Esc>" },
}

function keybindings.update_key_binding(func, custombind)
	keybindings[func][2] = custombind[1]
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
		require("preview-me.windower").open_in_curr_window()
	end, { buffer = buf })
	vim.keymap.set(keybindings.curr_window_enter.mode, keybindings.curr_window_enter.key, function()
		require("preview-me.windower").open_in_curr_window()
	end, { buffer = buf })
	vim.keymap.set(keybindings.quit.mode, keybindings.quit.key, function()
		require("preview-me.windower").close_window()
	end, { buffer = buf })
	vim.keymap.set(keybindings.quit_esc.mode, keybindings.quit_esc.key, function()
		require("preview-me.windower").close_window()
	end, { buffer = buf })
end

return keybindings
