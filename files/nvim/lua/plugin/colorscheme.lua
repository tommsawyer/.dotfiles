return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_foreground = "material"
    -- the file tree already sits on the darkest background (bg_dim), like a sidebar
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox-material",
      callback = function()
        local config = vim.fn["gruvbox_material#get_configuration"]()
        local p = vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
        local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end
        -- dropbar: a light band in the current window (like the active tab in tmux),
        -- plain background in the others, so splits show where the cursor is
        hl("WinBar", { fg = p.grey2[1], bg = p.bg1[1] })
        hl("WinBarNC", { fg = p.grey2[1], bg = p.bg0[1] })
        -- one-line notifications (LSP progress) sit on that band in the top right corner
        hl("SnacksNotifierMinimal", { fg = p.grey2[1], bg = p.bg1[1] })
      end,
    })
    vim.cmd("colorscheme gruvbox-material")
  end
}
