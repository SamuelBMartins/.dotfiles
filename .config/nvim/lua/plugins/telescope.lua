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
    vim.keymap.set("n", "<leader>sf", function()
      builtin.find_files { hidden = true }
    end, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sg", function()
      builtin.live_grep { additional_args = { "--hidden" } }
    end, { desc = "[S]earch by [G]rep" })
  end,
}
