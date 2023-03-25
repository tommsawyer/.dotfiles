vim.g.mapleader = ","

function moveWindow(direction)
  local currentWindow = vim.fn.winnr()
  print(currentWindow)

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

vim.keymap.set('n', '<C-h>', function() moveWindow("h") end)
vim.keymap.set('n', '<C-j>', function() moveWindow("j") end)
vim.keymap.set('n', '<C-k>', function() moveWindow("k") end)
vim.keymap.set('n', '<C-l>', function() moveWindow("l") end)
