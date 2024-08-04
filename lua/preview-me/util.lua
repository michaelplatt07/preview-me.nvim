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
	local retLines = {}
	if bufnr == nil then
		print(string.format("Error generating preview for file: %s", uri))
	end
	local lines = load_contents(bufnr)

	if lines == nil then
		print("Error")
	end

	for lineNum = start_line - 2, start_line + 4 do
		table.insert(retLines, lines[lineNum])
	end
	return retLines
end

function util.get_file_type(path)
	local dot_idx = string.find(string.reverse(path), "%.")
	if dot_idx ~= nil then
		return string.sub(path, #path - dot_idx + 2, #path)
	end
end

return util
