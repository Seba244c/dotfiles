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

require("jdtls").start_or_attach(config)
