local keybindings = {}

function keybindings.map_keys(buf)
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>vs", ':lua require("previewer.windower").split_v_ref()<CR>', {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>hs", ':lua require("previewer.windower").split_h_ref()<CR>', {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>t", ':lua require("previewer.windower").open_in_new_tab()<CR>', {})
	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<leader>o",
		':lua require("previewer.windower").open_in_curr_window()<CR>',
		{}
	)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", [[:lua close_window()<CR>]], {})
end

return keybindings
