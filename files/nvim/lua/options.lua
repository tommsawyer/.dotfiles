vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen" -- text does not jump when a split opens
vim.opt.swapfile = false
vim.opt.writebackup = false  -- no temporary copy while writing a file (it confuses file watchers)
vim.opt.undofile = true      -- undo history survives restarts (~/.local/state/nvim/undo)
vim.opt.confirm = true       -- :q on a modified buffer asks instead of failing
vim.opt.timeoutlen = 500
vim.opt.updatetime = 300     -- CursorHold sooner: checktime in autocommands.lua
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = "yes" -- always there, so signs do not shift the text
vim.opt.wrap = false
vim.opt.linebreak = true   -- where wrap is on (markdown), break at words
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.fillchars:append({ eob = " " }) -- no ~ after the end of the buffer
-- no split lines: the separator column stays but is blank, windows differ by background and winbar
vim.opt.fillchars:append({
  vert = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
})
vim.opt.whichwrap:append("<,>,[,],h,l") -- h / l / arrows move to the previous / next line
vim.opt.laststatus = 0                  -- no status line at all, dropbar shows the file
vim.opt.statusline = " "                -- blank where nvim still needs one (between stacked windows)
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.showcmd = false -- nowhere to show it with cmdheight = 0 anyway
vim.opt.ruler = false
vim.opt.mouse = ""
vim.opt.winborder = "single"
vim.opt.inccommand = "split" -- :s preview of all matches in a split
vim.filetype.add({
  extension = { templ = "templ", gitconfig = "gitconfig" },
  pattern = {
    -- go templates in hugo layouts
    [".*/layouts/.*%.html"] = function(path)
      if vim.fs.root(path, { "hugo.toml", "hugo.yaml", "hugo.json", "config.toml", "config.yaml" }) then
        return "gotmpl"
      end
    end,
  },
})

vim.cmd("abbr rt return")

-- russian layout (Russian - PC): normal/visual commands work without switching layout
vim.opt.langmap = table.concat({
  [[ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ;QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>~]],
  [[йцукенгшщзхъфывапролджэячсмитьбюё;qwertyuiop[]asdfghjkl\;'zxcvbnm\,.`]],
}, ",")

-- :ц -> :w, :й -> :q etc. (only for whole ex commands, not for / search)
for ru, en in pairs({ ["ц"] = "w", ["й"] = "q", ["цй"] = "wq", ["йф"] = "qa", ["цйф"] = "wqa", ["ч"] = "x" }) do
  vim.keymap.set("ca", ru, function()
    return (vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == ru) and en or ru
  end, { expr = true })
end
