-- duplicates all mappings (leader, ctrl, plugin keys) for russian layout;
-- plain vim commands are handled by `langmap` in options.lua
return {
  "Wansmer/langmapper.nvim",
  lazy = false,
  priority = 10000, -- load before other plugins so their keymaps get translated too
  config = function()
    require("langmapper").setup({})
    -- langmapper maps bare keys that differ across layouts; on mac that is `,`
    -- (the `/` key in the russian layout). `,` is the leader here, and a mapping
    -- on it stops which-key from building triggers for `,r`, `,g` and friends,
    -- so no hint popup ever shows.
    pcall(vim.keymap.del, "n", ",")
  end,
}
