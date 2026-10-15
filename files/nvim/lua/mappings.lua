vim.g.mapleader = ","

local function moveWindow(direction)
  return function()
    local currentWindow = vim.fn.winnr()

    vim.api.nvim_command("wincmd " .. direction)
    if vim.fn.winnr() == currentWindow then
      if direction == "j" or direction == "k" then
        vim.api.nvim_command("wincmd s")
      else
        vim.api.nvim_command("wincmd v")
      end

      vim.api.nvim_command("wincmd " .. direction)
    end
  end
end

vim.keymap.set('n', '<C-h>', moveWindow("h"), { desc = "Window left (split if none)" })
vim.keymap.set('n', '<C-j>', moveWindow("j"), { desc = "Window down (split if none)" })
vim.keymap.set('n', '<C-k>', moveWindow("k"), { desc = "Window up (split if none)" })
vim.keymap.set('n', '<C-l>', moveWindow("l"), { desc = "Window right (split if none)" })

vim.keymap.set('n', '{', ':<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>', { silent = true, desc = "Previous paragraph" })
vim.keymap.set('n', '}', ':<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>', { silent = true, desc = "Next paragraph" })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = "Clear search highlight" })
