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

vim.keymap.set('n', '<C-h>', moveWindow("h"))
vim.keymap.set('n', '<C-j>', moveWindow("j"))
vim.keymap.set('n', '<C-k>', moveWindow("k"))
vim.keymap.set('n', '<C-l>', moveWindow("l"))

vim.keymap.set('n', '{', ':<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>', { silent = true })
vim.keymap.set('n', '}', ':<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>', { silent = true })
