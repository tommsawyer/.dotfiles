return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-path",                    -- filesystem paths
    "hrsh7th/cmp-nvim-lsp",                -- LSP support
    "hrsh7th/cmp-nvim-lsp-signature-help", -- function arguments
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim", -- completion icons
  },
  config = function()
    local luasnip = require("luasnip")

    luasnip.config.set_config {
      history = true
    }

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      if luasnip.choice_active() then
        luasnip.change_choice()
      end
    end, { silent = true })
    local lspkind = require('lspkind')

    require("luasnip/loaders/from_vscode").lazy_load()
    local cmp = require("cmp")

    cmp.setup {
      preselect = false,
      completion = {
        completeopt = 'menu,menuone,noinsert'
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          { "i", "c" }
        ),
        ["<tab>"] = cmp.config.disable,
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol',
          maxwidth = 50,
        })
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = 'nvim_lsp_signature_help' },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sorting = {
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.locality,
          cmp.config.compare.score,
        },
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
  end
}
