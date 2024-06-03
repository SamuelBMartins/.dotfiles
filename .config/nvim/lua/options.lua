-- Generic settings
vim.g.have_nerd_font = true

-- Change leader before plugin load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.cc = "80"

vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
-- vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.gdefault = true
vim.opt.spell = true

vim.keymap.set(
  "n",
  "<C-h>",
  "<C-w><C-h>",
  { desc = "Move focus to the left window" }
)
vim.keymap.set(
  "n",
  "<C-l>",
  "<C-w><C-l>",
  { desc = "Move focus to the right window" }
)
vim.keymap.set(
  "n",
  "<C-j>",
  "<C-w><C-j>",
  { desc = "Move focus to the lower window" }
)
vim.keymap.set(
  "n",
  "<C-k>",
  "<C-w><C-k>",
  { desc = "Move focus to the upper window" }
)

-- Show highlighted search results only while typing
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = { "/", "?" },
  group = vim.api.nvim_create_augroup(
    "vimrc-incsearch-highlight",
    { clear = true }
  ),
  command = "set hlsearch",
})
vim.keymap.set(
  "n",
  "<esc>",
  '<cmd>let @/ = ""<cr>',
  { desc = "Hide search results" }
)

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
