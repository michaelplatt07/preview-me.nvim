local util = {}

function load_contents(bufnr)
	-- Get the file path associated with the buffer
	local file_path = vim.api.nvim_buf_get_name(bufnr)

	if not file_path or file_path == "" then
		print("Error: Buffer is not associated with a file")
		return nil
	end

	-- Open the file for reading
	local file = io.open(file_path, "r")
	if not file then
		print("Error: Failed to open file for reading")
		return nil
	end

	-- Read all lines from the file
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end

	-- Close the file
	file:close()
	return lines
end

function util.generate_preview(uri, start_line)
	local bufnr = vim.uri_to_bufnr(uri)
	if bufnr == nil then
		print(string.format("Error generating preview for file: %s", uri))
	end
	-- local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)
	local lines = load_contents(bufnr)

	if lines == nil then
		print("Error")
	end
	return lines[start_line + 1]
end

return util
