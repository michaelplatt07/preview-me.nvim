local keybindings = {
	split_v = { "n", "<leader>vs", ':lua require("preview-me.windower").split_v_ref()<CR>', {} },
	split_h = { "n", "<leader>hs", ':lua require("preview-me.windower").split_h_ref()<CR>', {} },
	new_tab = { "n", "<leader>t", ':lua require("preview-me.windower").open_in_new_tab()<CR>', {} },
	curr_window = { "n", "<leader>o", ':lua require("preview-me.windower").open_in_curr_window()<CR>', {} },
	quit = { "n", "q", ':lua require("preview-me.windower").close_window()<CR>', {} },
}

function keybindings.update_key_binding(custombind)
	keybindings.curr_window[1] = custombind[1]
	keybindings.curr_window[2] = custombind[2]
end

function keybindings.map_keys(buf)
	vim.api.nvim_buf_set_keymap(buf, keybindings.split_v[1], keybindings.split_v[2], keybindings.split_v[3], {})
	vim.api.nvim_buf_set_keymap(buf, keybindings.split_h[1], keybindings.split_h[2], keybindings.split_h[3], {})
	vim.api.nvim_buf_set_keymap(buf, keybindings.new_tab[1], keybindings.new_tab[2], keybindings.new_tab[3], {})
	vim.api.nvim_buf_set_keymap(
		buf,
		keybindings.curr_window[1],
		keybindings.curr_window[2],
		keybindings.curr_window[3],
		{}
	)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ':lua require("preview-me.windower").close_window()<CR>', {})
end

return keybindings
