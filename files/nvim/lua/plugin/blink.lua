return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  event = { 'InsertEnter', 'CmdlineEnter' }, -- files load it earlier through lspconfig
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    sources = {
      default = { 'lsp', 'snippets' },
    },

    completion = {
      menu = { border = 'none' }, -- just the background, not the global winborder
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = 'single',
        },
      },
    },

    signature = { enabled = true, window = { border = 'single' } },
  },
}
