vim.opt.cc = "80,100"
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.sleuth_java_heuristics = 0

vim.keymap.set(
  "n",
  "<leader>tc",
  '<cmd>JavaTestDebugCurrentClass<cr>',
  { desc = "Test Current Class" }
)

vim.keymap.set(
  "n",
  "<leader>tm",
  '<cmd>JavaTestDebugCurrentMethod<cr>',
  { desc = "Test Current Method" }
)
