-- Function to get the visual selection
local function get_visual_selection()
  -- Get the current buffer number (0 means current buffer)
  local bufnr = 0

  -- Get the total number of lines in the buffer
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Get all lines from the buffer (0-based index, end is exclusive)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)

  -- Get the file name
  local file_name = vim.fn.expand("%:p")

  -- Create the file info description
  local file_info = string.format("File: %s (%d lines)", file_name, line_count)

  -- Convert the lines into a single string
  local file_contents = table.concat(lines, "\n")

  -- Return both the file contents and the file info
  return file_contents, file_info
end

-- Function to parse JSON response and get gist URL
local function handle_response(response)
  -- Parse the JSON response
  local ok, decoded = pcall(vim.fn.json_decode, response)
  if not ok then
    vim.api.nvim_echo({ {
      "Failed to parse response: " .. decoded,
      "ErrorMsg",
    } }, true, {})
    return nil
  end

  -- Check if we have the expected data structure
  if not (decoded and decoded.data and decoded.data.id) then
    vim.api.nvim_echo({ {
      "Invalid response format",
      "ErrorMsg",
    } }, true, {})
    return nil
  end

  -- Construct the URL
  return string.format("https://zoeys.computer/gists/%s", decoded.data.id)
end

-- Function to create gist
local function create_gist()
  -- Get the selected code and line range
  local selected_code, line_range = get_visual_selection()

  -- Check if we got any code
  if selected_code == "" then
    vim.api.nvim_echo({ {
      "No text selected",
      "ErrorMsg",
    } }, true, {})
    return
  end

  -- Get the current file name with extension
  local file_name = vim.fn.expand("%:t")
  if file_name == "" then
    file_name = "untitled." .. vim.bo.filetype
  end

  -- Create the payload table first
  local payload = {
    title = file_name,
    desc = line_range,
    code = selected_code,
    lang = vim.bo.filetype,
  }

  -- Convert to JSON string
  local json_data = vim.fn.json_encode(payload)

  -- Create a temporary file for the JSON payload
  local temp_file = os.tmpname()
  local f = io.open(temp_file, "w")
  f:write(json_data)
  f:close()

  -- Construct and execute the curl command
  local cmd = string.format(
    [[
        curl -s -X POST \
        https://zoeys.computer/api/gists/create \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer Z4MYrYtJUb3Y8VvJynkWAw9eBVU3kvvW9gQ50--hROw" \
        -d @%s
    ]],
    temp_file
  )

  -- Execute the command and get the response
  local response = vim.fn.system(cmd)

  -- Clean up the temporary file
  os.remove(temp_file)

  -- Parse response and get URL
  local url = handle_response(response)
  if url then
    -- Copy URL to system clipboard
    vim.fn.setreg("+", url)

    -- Show success message
    vim.api.nvim_echo({ {
      "Gist created! URL copied to clipboard: " .. url,
      "Normal",
    } }, true, {})
  end
end

-- Set up the keybinding (you can modify this to your preferred key combination)
vim.keymap.set("n", "<leader>zc", create_gist, { noremap = true, silent = true, expr = true })
vim.keymap.set("n", "<leader>T", "<cmd>TimerlyToggle<CR>", { noremap = true })
