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
      -- breadcrumb separators: plain grey, not the italic of Comment they link to
      DropBarIconUISeparator = { fg = "$grey" },
      DropBarIconUISeparatorNC = { fg = "$grey" },
      -- dropbar menu: the entry under the cursor on a quiet band (like the selected row in fzf),
      -- not the orange of IncSearch (its icon: dropbar.lua); the current one in blue bold text,
      -- not a PmenuSel band
      DropBarMenuHoverEntry = { bg = "$bg3" },
      DropBarMenuCurrentContext = { fg = "$blue", fmt = "bold" },
      -- names in the menu as in nvim-tree: folders blue, files plain (dropbar.lua puts them in
      -- place of its DropBarKindDir / DropBarKindFile there, the bar keeps those)
      DropBarMenuKindDir = { fg = "$blue" },
      DropBarMenuKindFile = { fg = "$fg" },
      -- Trouble lists (references, symbols, diagnostics) on the file tree background, like a sidebar
      TroubleNormal = { bg = "$bg_d" },
      TroubleNormalNC = { bg = "$bg_d" },
      -- the status line nvim still draws under a window with another one below it (laststatus = 0):
      -- blank (statusline in options.lua) and on the editor background, just a gap
      StatusLine = { bg = "$bg0" },
      StatusLineNC = { bg = "$bg0" },
      -- the current indent scope: a guide a bit brighter than the rest (bg1), not purple;
      -- between bg3 and grey, the palette has no step there
      IblScope = { fg = "#46474c", fmt = "nocombine" },
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
