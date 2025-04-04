local dap = require("dap")
local json = vim.json

-- If the debug adapter is not setup, return
if not dap.adapters.codelldb then
	return
end

-- Function to find compile_commands.json in parent directories
local function find_compile_commands()
	local current_dir = vim.fn.expand("%:p:h")
	local root_dir = vim.fn.getcwd()

	-- Navigate up until we find compile_commands.json or reach root directory
	while current_dir ~= "" and current_dir ~= "/" do
		local compile_commands_path = current_dir .. "/compile_commands.json"
		if vim.fn.filereadable(compile_commands_path) == 1 then
			return compile_commands_path
		end

		local build_dir_compile_commands = current_dir .. "/build/compile_commands.json"
		if vim.fn.filereadable(build_dir_compile_commands) == 1 then
			return build_dir_compile_commands
		end

		-- Stop if we've reached the project root
		if current_dir == root_dir then
			break
		end

		-- Go up one directory
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end

	return nil
end

-- Function to automatically register executables from CMake build directory
local function setup_cmake_debug_adapters()
	require("notify")("Searching for C++ executables")
	local cmake_build_dir = vim.fn.getcwd() .. "/out" -- Adjust to your build directory
	local compile_commands_path = find_compile_commands()
	local executables = {}

	-- First try to parse compile_commands.json if it exists
	if compile_commands_path and vim.fn.filereadable(compile_commands_path) == 1 then
		local content = vim.fn.readfile(compile_commands_path)
		local compile_commands = json.decode(table.concat(content, "\n"))

		-- Track executables by finding linking commands
		local potential_targets = {}
		for _, entry in ipairs(compile_commands) do
			local command = entry.command or ""
			-- Look for linking operations which likely produce executables
			if command:match("[-]o%s+[^%s]+") then
				-- Extract output file from the -o flag
				local output_file = command:match("[-]o%s+([^%s]+)")
				if
					output_file
					and not output_file:match("%.o$")
					and not output_file:match("%.obj$")
					and not output_file:match("%.pch$")
					and not output_file:match("%.py$")
				then
					potential_targets[output_file] = true
				end
			end
		end

		-- Check each potential target
		for target, _ in pairs(potential_targets) do
			local full_path = cmake_build_dir .. "/" .. target
			if vim.fn.executable(full_path) == 1 then
				table.insert(executables, full_path)
			end
		end
	end

	-- Fallback: find executable files in the build directory
	if #executables == 0 then
		require("notify")("compile_commands.json gave 0 resulsts, searching manually..")
		local find_result = vim.fn.glob(cmake_build_dir .. "/**", true, true)
		for _, file in ipairs(find_result) do
			if vim.fn.executable(file) == 1 and vim.fn.isdirectory(file) == 0 then
				if not file:match("%.bin$") and not file:match("%.out$") and not file:match("%.h$") then
					table.insert(executables, file)
				end
			end
		end
	end

	-- Clear existing configurations to avoid duplicates
	dap.configurations.cpp = {}

	-- Register each executable with nvim-dap
	for _, executable in ipairs(executables) do
		local exec_name = vim.fn.fnamemodify(executable, ":t")

		table.insert(dap.configurations.cpp, {
			name = "Launch " .. exec_name,
			type = "codelldb",
			request = "launch",
			program = executable,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			runInTerminal = false,
			setupCommands = {
				{
					text = "-enable-pretty-printing",
					description = "enable pretty printing",
					ignoreFailures = false,
				},
			},
		})

		print("DAP: Registered executable " .. executable)
	end

	if #executables == 0 then
		print("No executables found in " .. cmake_build_dir)
	end
end

-- Find compile_commands file
local compile_commands = find_compile_commands()
if compile_commands or vim.fn.filereadable("CMakeLists.txt") == 1 then
	if not dap.configurations.cpp or #dap.configurations.cpp == 0 then
		setup_cmake_debug_adapters()
	end
end

vim.api.nvim_create_user_command("RefreshTargetsCPP", setup_cmake_debug_adapters, {})
