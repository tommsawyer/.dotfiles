return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local hooks = require("ibl.hooks")
    -- no guide for the first indent level, it sits right next to the line numbers
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

    require("ibl").setup({
      indent = { char = "▏", tab_char = "▏" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = { "help", "NvimTree", "lazy" },
      },
    })
  end,
}
