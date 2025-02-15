return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'snippets' },
    },

    completion = {
      documentation = { 
        auto_show = true, 
        auto_show_delay_ms = 500,
        window = {
          border = 'single',
        },
      },
    },

    signature = { enabled = true, window = { border = 'single'} },
  },
  opts_extend = { "sources.default" }
}
