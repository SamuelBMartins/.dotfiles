--- <leader>f files
--- <leader>s text
--- Ctrl+v open in vsplit
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require "telescope.actions"
    require("telescope").setup {
      defaults = {
        mappings = {
          n = {
            ["v"] = actions.file_vsplit,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    }
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require "telescope.builtin"
    vim.keymap.set(
      "n",
      "<leader>sf",
      builtin.find_files,
      { desc = "[S]earch Files" }
    )
    vim.keymap.set(
      "n",
      "<leader>sg",
      builtin.live_grep,
      { desc = "Search by [G]rep" }
    )
  end,
}
