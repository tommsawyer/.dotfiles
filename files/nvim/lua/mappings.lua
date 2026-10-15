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

-- [= ]=: nearest line above / below whose indent differs from the current one;
-- [- ]-: nearest line above / below with a smaller indent (parent block header / exit from the block).
-- Blank lines are skipped, [count] repeats the jump.
local function indentJump(dir, smaller)
  return function()
    local line, last = vim.fn.line("."), vim.fn.line("$")
    for _ = 1, vim.v.count1 do
      local current = vim.fn.indent(line)
      local function stop(l)
        if vim.fn.getline(l):match("^%s*$") then return false end
        if smaller then return vim.fn.indent(l) < current end
        return vim.fn.indent(l) ~= current
      end
      local l = line + dir
      while l >= 1 and l <= last and not stop(l) do
        l = l + dir
      end
      if l < 1 or l > last then break end
      line = l
    end
    if line ~= vim.fn.line(".") then
      if vim.fn.mode() == "n" then vim.cmd("normal! m'") end -- so <C-o> comes back
      vim.api.nvim_win_set_cursor(0, { line, #vim.fn.getline(line):match("^%s*") }) -- first non-blank
    end
  end
end

for lhs, jump in pairs({
  ["[="] = { -1, false, "Previous line with another indent" },
  ["]="] = { 1, false, "Next line with another indent" },
  ["[-"] = { -1, true, "Parent block (line above with a smaller indent)" },
  ["]-"] = { 1, true, "Out of the block (line below with a smaller indent)" },
}) do
  local plug = "<Plug>(indent-jump" .. lhs .. ")"
  vim.keymap.set({ 'n', 'x', 'o' }, plug, indentJump(jump[1], jump[2]))
  vim.keymap.set({ 'n', 'x' }, lhs, plug, { desc = jump[3] })
  vim.keymap.set('o', lhs, 'V' .. plug, { desc = jump[3] }) -- linewise as a motion: d]= deletes whole lines
end
