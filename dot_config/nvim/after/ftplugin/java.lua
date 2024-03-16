local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local lombok_jar = vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar"
local dap_jar = vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"

local lsp_attach = function(client, bufnr)
    -- mappings here
require('jdtls.dap').setup_dap_main_class_configs()
end

local config = {
    cmd = { jdtls_bin, "--jvm-arg=" .. string.format("-javaagent:%s", lombok_jar) },
    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
    on_attach = lsp_attach,
    init_options = {
		bundles = {
            vim.fn.glob(dap_jar, 1) },
	},
}

require("jdtls").start_or_attach(config)
