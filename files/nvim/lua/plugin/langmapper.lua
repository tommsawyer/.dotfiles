-- duplicates all mappings (leader, ctrl, plugin keys) for russian layout;
-- plain vim commands are handled by `langmap` in options.lua
return {
  "Wansmer/langmapper.nvim",
  lazy = false,
  priority = 10000, -- load before other plugins so their keymaps get translated too
  config = function()
    require("langmapper").setup({})
  end,
}
