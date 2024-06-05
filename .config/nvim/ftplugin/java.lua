vim.opt.cc = "80,100"

local mason_registry = require "mason-registry"
local javadbg = mason_registry.get_package "java-debug-adapter"
javadbg:get_install_path()

require("jdtls").start_or_attach {
  cmd = {
    "jdtls",
  },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
  ),
  init_options = {
    bundles = {
      vim.fn.glob(
        javadbg:get_install_path()
          .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        1
      ),
    },
  },
  on_attach = function(client, bufnr)
    require("jdtls.dap").setup_dap_main_class_configs()
  end,
  settings = require("utils").config("jdtls", {}),
}
