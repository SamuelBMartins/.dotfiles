return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    -- To allow other plugins to add linters
    lint.linters_by_ft = lint.linters_by_ft or {}

    lint.linters_by_ft["markdown"] = { "markdownlint" }
    lint.linters_by_ft["python"] = { "pylint" }
    lint.linters_by_ft["javascript"] = { "eslint_d" }
    lint.linters_by_ft["json"] = { "jsonlint" }
    -- lint.linters_by_ft["java"] = { "checkstyle" }

    lint.linters.pylint.cmd = "python"
    -- Add "-m pylint" as first arg
    table.insert(lint.linters.pylint.args, 1, "pylint")
    table.insert(lint.linters.pylint.args, 1, "-m")

    -- Some linters need the file to be saved
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
