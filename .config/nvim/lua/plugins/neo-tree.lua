-- a: add
-- A: add fodler
-- d: delete
-- m: move
-- cr: open
-- v: open vsplit
-- Ctrl-n: toggle
-- .: set root
-- P: preview
return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<C-n>", ":Neotree reveal<CR>", { desc = "NeoTree reveal" } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ["<C-n>"] = "close_window",
          ["v"] = "open_vsplit",
        },
      },
      filtered_items = {
        hide_dotfiles = false,
      },
    },
  },
}
