local api = vim.api

local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ higroup = "Visual" }) end,
  group = yankGrp,
})

-- reload files changed on disk (e.g. by an agent in another pane)
local reloadGrp = api.nvim_create_augroup("AutoReload", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    -- checktime errors out in the cmdline window (q:) and in cmdline mode
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
  group = reloadGrp,
})
api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(ev)
    vim.notify("перезагружен с диска: " .. vim.fn.fnamemodify(ev.file, ":~:."), vim.log.levels.INFO)
  end,
  group = reloadGrp,
})
