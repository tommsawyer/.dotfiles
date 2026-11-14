-- listen on a socket named after the tmux server and pane: lgedit (files/lazygit/lgedit)
-- opens files from lazygit in this running instance through it; outside tmux there is no
-- pane to name it by
if vim.env.TMUX then
  local server = vim.fs.basename(vim.env.TMUX:match("^[^,]+"))
  local sock = "/tmp/nvim-" .. server .. "-" .. vim.env.TMUX_PANE .. ".sock"
  if vim.fn.serverstart(sock) == "" then
    -- a crashed nvim leaves the socket file behind
    vim.uv.fs_unlink(sock)
    vim.fn.serverstart(sock)
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("mappings")
require("plugins")
require("options")
require("autocommands")

-- translate mappings created before langmapper was loaded
require("langmapper").automapping({ global = true, buffer = true })
