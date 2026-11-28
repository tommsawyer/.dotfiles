local theme = require("theme")

return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    -- the options go before the colorscheme loads
    vim.o.background = theme.light and "light" or "dark"
    vim.g.gruvbox_material_background = "hard" -- the contrast; dark or light is `background`
    -- floats on the editor background, their frame is the delimiter (winborder in options.lua)
    vim.g.gruvbox_material_float_style = "blend"

    -- the theme takes no highlight overrides: the groups below in its palette, again after every
    -- load of it (`:colorscheme` clears what was set before)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox-material",
      group = vim.api.nvim_create_augroup("ColorschemeHighlights", { clear = true }),
      callback = function()
        local config = vim.fn["gruvbox_material#get_configuration"]()
        ---@type table<string, [string, string]> -- [gui, cterm]
        local palette =
            vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
        ---@type table<string, string>
        local p = vim.tbl_map(function(colour) return colour[1] end, palette)
        -- sidebars (file tree, Trouble, the dropbar menu) on the darkest background, bg_dim; the
        -- tree is there by the theme itself
        local sidebar = p.bg_dim

        local highlights = {
          -- the popup of the file tree (its help) on the sidebar colour, not the float one
          NvimTreeNormalFloat = { fg = p.fg0, bg = sidebar },
          -- dropbar: a light band in the current window (like the active tab in tmux),
          -- plain background in the others, so splits show where the cursor is
          WinBar = { fg = p.grey2, bg = p.bg1 },
          WinBarNC = { fg = p.grey2, bg = p.bg0 },
          -- breadcrumb separators: plain grey, not the italic of Comment they link to
          DropBarIconUISeparator = { fg = p.grey1 },
          DropBarIconUISeparatorNC = { fg = p.grey1 },
          -- dropbar menu: the entry under the cursor on a quiet band (like the selected row in fzf),
          -- not the red of IncSearch (its icon: dropbar.lua); the current one in blue bold text,
          -- not a PmenuSel band
          DropBarMenuHoverEntry = { bg = p.bg3 },
          DropBarMenuCurrentContext = { fg = p.blue, bold = true },
          -- names in the menu as in nvim-tree: folders in its folder colour, files plain
          -- (dropbar.lua puts them in place of its DropBarKindDir / DropBarKindFile there, the bar
          -- keeps those)
          DropBarMenuKindDir = { fg = p.green },
          DropBarMenuKindFile = { fg = p.fg0 },
          -- and on its background (sidebar), not the completion menu one (Pmenu)
          DropBarMenuNormalFloat = { fg = p.fg0, bg = sidebar },
          -- Trouble lists (references, symbols, diagnostics) on the file tree background, like a sidebar
          TroubleNormal = { fg = p.fg0, bg = sidebar },
          TroubleNormalNC = { fg = p.fg0, bg = sidebar },
          -- the status line nvim still draws under a window with another one below it (laststatus = 0):
          -- blank (statusline in options.lua) and on the editor background, just a gap
          StatusLine = { bg = p.bg0 },
          StatusLineNC = { bg = p.bg0 },
          -- indent guides quiet, on bg1 (the theme draws them on bg5); the current scope: a guide
          -- a bit brighter than the rest, not the theme's grey1
          IblIndent = { fg = p.bg1, nocombine = true },
          IblScope = { fg = theme.light and p.grey0 or p.bg5, nocombine = true },
          -- picker title as a label on the frame, like flash labels (the theme's Substitute)
          SnacksPickerTitle = { fg = p.bg0, bg = p.bg_yellow, bold = true },
          -- groups the theme leaves to nvim / plugin defaults: the window picker labels of the file
          -- tree look like flash labels; messages in green, not its light text
          NvimTreeWindowPicker = { fg = p.bg0, bg = p.bg_yellow, bold = true },
          ModeMsg = { fg = p.green },
          OkMsg = { fg = p.green },
          -- which-key floats as the others, on the editor background: its windows ask for these
          -- groups, the theme does not define them
          WhichKeyNormal = { link = "NormalFloat" },
          WhichKeyBorder = { link = "FloatBorder" },
          -- gitsigns popups (,gb blame, ,gp hunk preview) paint their text pieces
          -- with NormalFloat; this window-local replacement (gitsigns.lua) keeps
          -- the text colour but puts it on the editor background, like which-key
          GitSignsPopupFloat = { fg = p.fg0, bg = p.bg0 },
          GitSignsAdd = { fg = p.blue },
          GitSignsChange = { fg = p.yellow },
          -- ,gp hunk preview in the delta colours of lazygit
          -- (files/git/delta.gitconfig): added lines on the blue tint, deleted on
          -- the red one, changed words on the emph tints — not the theme's green
          -- and red line backgrounds, and not the inverted TermCursor word blocks
          GitSignsAddPreview = { bg = theme.light and "#DEE1C9" or "#2B3534" },
          GitSignsDeletePreview = { bg = theme.light and "#F1DBC2" or "#3C2B2B" },
          GitSignsAddInline = { bg = theme.light and "#C3CDBB" or "#3A4B48" },
          GitSignsDeleteInline = { bg = theme.light and "#E8C2AD" or "#5A3634" },
          GitSignsChangeInline = { fg = p.yellow, bg = p.bg_visual_yellow },
          -- review.nvim comment lines in the same tint language as the diff:
          -- suggestion is an addition (blue), issue a deletion (red), note a
          -- neutral band, praise a whisper of green; the plugin's navy hexes are
          -- tuned for a bluer background
          ReviewNoteLine = { bg = p.bg3 },
          ReviewSuggestionLine = { bg = theme.light and "#DEE1C9" or "#2B3534" },
          ReviewIssueLine = { bg = theme.light and "#F1DBC2" or "#3C2B2B" },
          ReviewPraiseLine = { bg = p.bg_diff_green },
        }
        for group, hl in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, hl)
        end
      end,
    })
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
