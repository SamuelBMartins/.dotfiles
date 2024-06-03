-- Other themes
-- 'catppuccin/nvim',
-- 'olimorris/onedarkpro.nvim',
-- 'folke/tokyonight.nvim',
return {
  "navarasu/onedark.nvim",
  priority = 1000,
  init = function()
    require("onedark").setup {
      style = "warmer",
    }
    require("onedark").load()
  end,
}
