return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      textobjects = {
        -- Select functions, classes, scopes
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = {
              query = "@class.inner",
              desc = "Select inner part of a class region",
            },
            ["as"] = {
              query = "@scope",
              query_group = "locals",
              desc = "Select language scope",
            },
          },
        },
        -- Move between functions
        move = {
          enable = true,
          -- whether to set jumps in the jumplist
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]s"] = {
              query = "@scope",
              query_group = "locals",
              desc = "Next scope",
            },
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
