local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local lombok_jar = vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar"

local lsp_attach = function(client, bufnr)
    -- mappings here
end

local config = {
    cmd = { jdtls_bin, "--jvm-arg=" .. string.format("-javaagent:%s", lombok_jar) },
    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
    on_attach = lsp_attach,
}

return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        require("jdtls").start_or_attach(config)
    end,
}
