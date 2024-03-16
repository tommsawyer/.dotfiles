return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = {
        enable_autocmd = false,
        languages = {
          templ = {
            __default = '// %s',
            component_declaration = '<!-- %s -->',
          },
        },
      }
    },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
}
