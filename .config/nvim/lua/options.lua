-- Generic settings

-- Change leader before plugin load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
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
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.gdefault = true
vim.opt.spell = true
vim.o.exrc = true
vim.opt.splitright = true

-- Keymaps
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

-- Diagnostic
vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic [E]rror messages" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

vim.opt.incsearch = true
vim.opt.hlsearch = true
-- Clear highlighting search when pressing Esc in n mode
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

local function skip_closing_parenthesis()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col + 1, col + 1)
  local char2 = line:sub(col + 2, col + 2)

  if char == ")" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Right>", true, false, true),
      "n",
      false
    )
  elseif char == '"' and char2 == ")" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Right><Right>", true, false, true),
      "n",
      false
    )
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
      "n",
      false
    )
  end
end
-- vim.keymap.set("i", "<Tab>", function()
--   skip_closing_parenthesis()
-- end, { expr = true, noremap = true })

-- autosave
local function is_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree"
  return vim.v.shell_error == 0
end
vim.api.nvim_create_autocmd({ "BufHidden", "VimLeavePre" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  callback = function(event)
    if
      vim.api.nvim_get_option_value("modified", { buf = event.buf })
      and vim.api.nvim_get_option_value("buftype", { buf = event.buf }) == ""
      and is_git_repo()
    then
      vim.schedule(function()
        vim.api.nvim_buf_call(event.buf, function()
          vim.cmd "silent! write"
        end)
      end)
    end
  end,
})
