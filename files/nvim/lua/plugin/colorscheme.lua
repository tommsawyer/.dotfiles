return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "warmer",
    -- the file tree already sits on the darkest background (bg_d), like a sidebar
    highlights = {
      -- dropbar: a light band in the current window (like the active tab in tmux),
      -- plain background in the others, so splits show where the cursor is
      WinBar = { fg = "$light_grey", bg = "$bg1" },
      WinBarNC = { fg = "$light_grey", bg = "$bg0" },
      -- one-line notifications (LSP progress) sit on that band in the top right corner
      SnacksNotifierMinimal = { fg = "$light_grey", bg = "$bg1" },
      -- Trouble lists (references, symbols, diagnostics) on the file tree background, like a sidebar
      TroubleNormal = { bg = "$bg_d" },
      TroubleNormalNC = { bg = "$bg_d" },
      -- the status line nvim still draws under a window with another one below it (laststatus = 0):
      -- blank (statusline in options.lua) and on the editor background, just a gap
      StatusLine = { bg = "$bg0" },
      StatusLineNC = { bg = "$bg0" },
      -- picker title as a label on the frame, like flash labels
      SnacksPickerTitle = { fg = "$bg0", bg = "$green", fmt = "bold" },
      -- groups the theme leaves to plugin / nvim defaults (blue-gray folder icons, a light green
      -- message); the window picker labels look like flash labels
      NvimTreeFolderIcon = { fg = "$blue" },
      NvimTreeWindowPicker = { fg = "$bg0", bg = "$green", fmt = "bold" },
      ModeMsg = { fg = "$green" },
      OkMsg = { fg = "$green" },
    },
  },
  config = function(_, opts)
    require("onedark").setup(opts)
    require("onedark").load()
  end
}
