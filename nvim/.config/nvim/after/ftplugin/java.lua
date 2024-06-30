local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local lombok_jar = vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar"
local dap_jar = vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"
local jdtls = require("jdtls")
local jdtls_dap = require("jdtls.dap")

local lsp_attach = function(client, bufnr)
	-- mappings here
	jdtls.setup_dap({ hotcodereplace = "auto" })
	jdtls_dap.setup_dap_main_class_configs()

	require("lsp_signature").on_attach({
		bind = true,
		padding = "",
		handler_opts = {
			border = "rounded",
		},
		hint_prefix = "󱄑 ",
	}, bufnr)

	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format()
		end,
	})
end

local config = {
	cmd = { jdtls_bin, "--jvm-arg=" .. string.format("-javaagent:%s", lombok_jar) },
	on_attach = lsp_attach,
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
	init_options = {
		bundles = {
			vim.fn.glob(dap_jar, 1),
		},
	},
	flags = {
		allow_incremental_sync = true,
	},
	settings = {
		java = {
			format = {
				enabled = true,
				settings = {
					url = vim.fn.stdpath("config") .. "/intellij-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
			signatureHelp = { enabled = true },
		},
	},
}

local status_callback = function(_, result)
	if result.message == "ServiceReady" then
		vim.notify("LSP Ready", nil, { title = "JDTLS" })
	elseif result.message:find("^Init") then
		vim.notify("LSP Starting", nil, { title = "JDTLS" })
	elseif
		result.message ~= "Ready"
		and result.message ~= "OK"
		and not result.message:find("% Starting Java Language Server$")
	then
		vim.notify(result.message, nil, { title = "JDTLS" })
	end
end

config.handlers = {}
config.handlers["language/status"] = status_callback

require("jdtls").start_or_attach(config)
