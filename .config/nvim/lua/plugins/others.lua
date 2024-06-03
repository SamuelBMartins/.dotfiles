return {

  -- gc: comment line
  -- gb: comment block
  { "numToStr/Comment.nvim", opts = {} },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Set tabs automatically
  { "tpope/vim-sleuth" },

  --- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --- sd'   - [S]urround [D]elete [']quotes
  --- sr)'  - [S]urround [R]eplace [)] [']
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.surround").setup()
    end,
  },

  -- Highlight comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
