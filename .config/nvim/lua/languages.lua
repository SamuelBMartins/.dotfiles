vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt.cc = "80,100"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt.cc = "50,72"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  callback = function()
    vim.opt.cc = "72"
    vim.opt.textwidth = 72
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.cc = "72"
    vim.opt.textwidth = 72
  end,
})
