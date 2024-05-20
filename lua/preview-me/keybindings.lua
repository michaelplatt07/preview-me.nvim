local keybindings = {}

keybindings.split_v = { "n", "<leader>vs", ':lua require("preview-me.windower").split_v_ref()<CR>', {} }
keybindings.split_h = { "<leader>hs", ':lua require("preview-me.windower").split_h_ref()<CR>', {} }
keybindings.new_tab = { "n", "<leader>t", ':lua require("preview-me.windower").open_in_new_tab()<CR>', {} }
keybindings.curr_window = { "n", "<leader>o", ':lua require("preview-me.windower").open_in_curr_window()<CR>', {} }
keybindings.quit = { "n", "q", ':lua require("preview-me.windower").close_window()<CR>', {} }

function keybindings.update_key_binding(custombind)
	print("In update key binding, value = ", custombind[1])
	print("In update key binding, cmd = ", custombind[2])
	keybindings.curr_window[1] = custombind[1]
	keybindings.curr_window[2] = custombind[2]
	keybindings.curr_window[3] = custombind[3]
end

function keybindings.map_keys(buf)
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>vs", ':lua require("preview-me.windower").split_v_ref()<CR>', {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>hs", ':lua require("preview-me.windower").split_h_ref()<CR>', {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<leader>t", ':lua require("preview-me.windower").open_in_new_tab()<CR>', {})
	vim.api.nvim_buf_set_keymap(buf, keybindings.curr_window[1], keybindings.curr_window[2], keybindings.curr_window[3])
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ':lua require("preview-me.windower").close_window()<CR>', {})
end

return keybindings
