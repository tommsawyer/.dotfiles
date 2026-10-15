return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "wave",
    background = { dark = "wave" },
    colors = {
      theme = {
        -- sign/number column without its own darker background
        all = { ui = { bg_gutter = "none" } },
      },
    },
    -- file tree on the darkest background of the theme, like a sidebar
    overrides = function(colors)
      local ui = colors.theme.ui
      return {
        NvimTreeNormal = { bg = ui.bg_m3 },
        NvimTreeNormalNC = { bg = ui.bg_m3 },
        NvimTreeEndOfBuffer = { fg = ui.bg_m3, bg = ui.bg_m3 },
        NvimTreeWinSeparator = { fg = ui.bg_m3, bg = ui.bg_m3 },
        -- dropbar: a light band in the current window (like the active tab in tmux),
        -- plain background in the others, so splits show where the cursor is
        WinBar = { fg = ui.fg_dim, bg = ui.bg_p1 },
        WinBarNC = { fg = ui.fg_dim, bg = ui.bg },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa-wave")
  end
}
