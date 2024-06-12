--- Ctrl+/: Toggle terminal
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      open_mapping = [[<C-_>]],
      on_open = function()
        vim.cmd "setlocal nospell"
        vim.cmd "startinsert"
      end,
    }

    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new {
      cmd = "lazygit",
      direction = "float",
      hidden = true,
    }

    function _lazygit_toggle()
      lazygit:toggle()
    end

    vim.api.nvim_set_keymap(
      "n",
      "<leader>g",
      "<cmd>lua _lazygit_toggle()<CR>",
      {
        noremap = true,
        silent = true,
      }
    )
  end,
}
