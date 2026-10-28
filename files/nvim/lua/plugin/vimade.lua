-- the theme's bg_d (lua/theme.lua), the same the picker backdrop dims with
local bg_d = require("theme").bg_d
local dim = {
  rgb = { tonumber(bg_d:sub(2, 3), 16), tonumber(bg_d:sub(4, 5), 16), tonumber(bg_d:sub(6, 7), 16) },
  intensity = 0.4,
}

-- the file window left last: it stays lit while the cursor is in the file tree, Trouble...
-- (on leave, not enter: the window nvim starts in is never entered)
local last_file_win
vim.api.nvim_create_autocmd("WinLeave", {
  group = vim.api.nvim_create_augroup("VimadeLastFileWin", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" and vim.api.nvim_win_get_config(0).relative == "" then
      last_file_win = vim.api.nvim_get_current_win()
    end
  end,
})

return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = {
    ncmode = "windows", -- the same file in another split is dimmed too
    -- no fade towards the window's own background: text and background both blend into bg_d,
    -- like under the picker backdrop
    fadelevel = 1,
    tint = { fg = dim, bg = dim, sp = dim },
    blocklist = {
      -- only file buffers dim: never the file tree, Trouble, quickfix, help...
      special_buffers = function(win)
        return win.buf_opts.buftype ~= ""
      end,
      -- from a special window the file you came from stays as is
      came_from = function(win, active)
        return active ~= nil and active.buf_opts.buftype ~= "" and win.winid == last_file_win
      end,
    },
  },
}
