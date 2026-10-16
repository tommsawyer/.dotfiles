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

-- instead of reloading, apply the diff with the disk to the buffer and flash it, like yy does:
-- the cursor, folds and marks stay put, and one `u` undoes the whole outside change
-- (unsaved edits it overwrote too, so no "load from disk?" prompts either).
-- 'autoread' would reload clean buffers silently, bypassing FileChangedShell, so it's off
vim.o.autoread = false
local diffNs = api.nvim_create_namespace("DiskDiff")

local function flash(buf, hunks, old)
  local ids = {}
  for _, h in ipairs(hunks) do
    local start_a, count_a, start_b, count_b = unpack(h)
    if count_b > 0 then
      ids[#ids + 1] = api.nvim_buf_set_extmark(buf, diffNs, start_b - 1, 0, {
        end_row = start_b - 1 + count_b, hl_group = count_a > 0 and "DiffChange" or "DiffAdd", hl_eol = true,
      })
    else -- removed lines: show them for a moment where they were
      local lines = {}
      for i = start_a, math.min(start_a + count_a - 1, start_a + 9) do
        lines[#lines + 1] = { { old[i], "DiffDelete" } }
      end
      ids[#ids + 1] = api.nvim_buf_set_extmark(buf, diffNs, math.max(start_b - 1, 0), 0, {
        virt_lines = lines, virt_lines_above = start_b == 0,
      })
    end
  end
  vim.defer_fn(function()
    if not api.nvim_buf_is_valid(buf) then return end
    for _, id in ipairs(ids) do api.nvim_buf_del_extmark(buf, diffNs, id) end
  end, 1000)
end

local function apply_disk(buf)
  if not api.nvim_buf_is_valid(buf) then return end
  local ok, new = pcall(vim.fn.readfile, api.nvim_buf_get_name(buf))
  if not ok then return end
  local old = api.nvim_buf_get_lines(buf, 0, -1, false)
  local hunks = vim.text.diff(table.concat(old, "\n") .. "\n", table.concat(new, "\n") .. "\n", { result_type = "indices" })
  ---@cast hunks integer[][]
  if #hunks == 0 then return end
  -- a separate undo step: don't join the user's last edit or the previous outside change
  local function undo_break() api.nvim_buf_call(buf, function() vim.cmd("let &l:undolevels = &l:undolevels") end) end
  undo_break()
  -- bottom up, so the line numbers of the hunks above stay valid
  for i = #hunks, 1, -1 do
    local start_a, count_a, start_b, count_b = unpack(hunks[i])
    local from = count_a == 0 and start_a or start_a - 1
    api.nvim_buf_set_lines(buf, from, from + count_a, false, vim.list_slice(new, start_b, start_b + count_b - 1))
  end
  undo_break()
  vim.bo[buf].modified = false
  flash(buf, hunks, old)
end

api.nvim_create_autocmd("FileChangedShell", {
  callback = function(ev)
    local reason, bo = vim.v.fcs_reason, vim.bo[ev.buf]
    vim.v.fcs_choice = "" -- handled here: no prompt, no reload
    if reason == "deleted" then
      vim.notify("удалён с диска: " .. vim.fn.fnamemodify(ev.file, ":~:."), vim.log.levels.WARN)
    elseif reason == "changed" or reason == "conflict" then
      if bo.fileformat ~= "unix" or bo.bomb or not vim.tbl_contains({ "", "utf-8" }, bo.fileencoding) then
        vim.v.fcs_choice = "reload" -- readfile() would see these bytes differently from the buffer
      else
        -- the buffer must not be changed from inside FileChangedShell
        vim.schedule(function() apply_disk(ev.buf) end)
      end
    end
  end,
  group = reloadGrp,
})

-- plain `nvim` in a project opens the file edited there last (from shada oldfiles)
api.nvim_create_autocmd("VimEnter", {
  nested = true, -- so FileType, LSP, treesitter and lazy-loaded plugins fire for that file
  callback = function()
    if vim.fn.argc() > 0 then return end -- `nvim file`, `nvim .`, git commit
    -- +Man!, stdin, -q, -S, -c 'e x' leave something else in the start buffer: keep it
    local buf = api.nvim_get_current_buf()
    if api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].buftype ~= "" or vim.bo[buf].modified
        or api.nvim_buf_line_count(buf) > 1 or api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= "" then
      return
    end
    local cwd = vim.uv.cwd() -- nil when cwd was deleted
    local root = cwd and vim.uv.fs_realpath(cwd)
    if not root then return end
    root = root .. "/"
    for _, f in ipairs(vim.v.oldfiles) do
      -- realpath: oldfiles may go through symlinks; nil means the file is gone
      local real = vim.uv.fs_realpath(f)
      if real and vim.startswith(real, root) and not real:find("/.git/", 1, true) then
        vim.cmd.edit(vim.fn.fnameescape(real))
        return
      end
    end
  end,
  group = api.nvim_create_augroup("OpenLastFile", { clear = true }),
})

-- reopen files at the last cursor position (except git commit messages and the like)
api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    if api.nvim_buf_get_name(args.buf):find("/.git/", 1, true) then return end
    local mark = api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= api.nvim_buf_line_count(args.buf) then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = api.nvim_create_augroup("RestoreCursor", { clear = true }),
})

-- no comment leader on o/O/<CR>; ftplugins set formatoptions per buffer, so after them
api.nvim_create_autocmd("FileType", {
  callback = function() vim.opt_local.formatoptions:remove({ "c", "r", "o" }) end,
  group = api.nvim_create_augroup("FormatOptions", { clear = true }),
})
