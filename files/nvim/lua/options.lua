vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.smartcase = true                        -- smart case
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.timeoutlen = 500                        -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- no temporary copy while writing a file (it confuses file watchers)
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.laststatus = 0                          -- no status line at all, dropbar shows the file
vim.opt.showcmd = false                         -- nowhere to show it with cmdheight = 0 anyway
vim.opt.ruler = false                           -- hide the line and column number of the cursor position
vim.opt.signcolumn =
"yes"                                           -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.fillchars:append({ eob = " " })         -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.whichwrap:append("<,>,[,],h,l")         -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.linebreak = true
vim.opt.cmdheight = 0
vim.opt.mouse = ''
vim.opt.winborder = "single"
vim.opt.undofile = true                         -- undo history survives restarts (~/.local/state/nvim/undo)
vim.opt.confirm = true                          -- :q on a modified buffer asks instead of failing
vim.opt.inccommand = "split"                    -- :s preview of all matches in a split
vim.opt.splitkeep = "screen"                    -- text does not jump when a split opens
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
