-- Autocompletion
return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    -- use a release tag to download pre-built binaries
    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = "default",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C- >"] = { "show" },
        ["<C-Return>"] = { "select_and_accept" },
        ["<K>"] = { "show_documentation" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        -- use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {
  --       -- Snippet engine
  --       "L3MON4D3/LuaSnip",
  --
  --       -- Build Step is needed for regex support in snippets.
  --       build = "make install_jsregexp",
  --       dependencies = {
  --         {
  --           -- VS Code snippets
  --           "rafamadriz/friendly-snippets",
  --           config = function()
  --             require("luasnip.loaders.from_vscode").lazy_load()
  --           end,
  --         },
  --       },
  --     },
  --     -- Use luasnip in cmp
  --     "saadparwaiz1/cmp_luasnip",
  --     -- LSP autocompletions
  --     "hrsh7th/cmp-nvim-lsp",
  --     -- Path autocompletions
  --     "hrsh7th/cmp-path",
  --   },
  --   config = function()
  --     local cmp = require "cmp"
  --     local luasnip = require "luasnip"
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         -- cmp_luasnip config
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       -- Autoselect first element
  --       completion = {
  --         completeopt = "menu,menuone,noinsert",
  --         -- disable autocomplete for heavy projects
  --         -- autocomplete = false,
  --       },
  --
  --       -- Show preview
  --       -- experimental = { ghost_text = true },
  --
  --       mapping = cmp.mapping.preset.insert {
  --         ["<c-n>"] = cmp.mapping.select_next_item(),
  --         ["<c-p>"] = cmp.mapping.select_prev_item(),
  --         -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --         ["<CR>"] = cmp.mapping.confirm {
  --           select = true,
  --         },
  --         ["<C-Space>"] = cmp.mapping.complete {},
  --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         -- for example move between args of a function
  --         ["<C-l>"] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { "i", "s" }),
  --         ["<C-h>"] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { "i", "s" }),
  --       },
  --       sources = {
  --         { name = "nvim_lsp" },
  --         { name = "luasnip" },
  --         { name = "path" },
  --       },
  --     }
  --   end,
  -- },
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cd",
        function()
          require("neogen").generate {}
        end,
        desc = "Generate annotations",
      },
    },
    config = {
      snippet_engine = "luasnip",
    },
  },
}
