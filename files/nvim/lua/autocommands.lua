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

-- plain `nvim` in a project opens the file edited there last (from shada oldfiles)
api.nvim_create_autocmd("VimEnter", {
  nested = true,                         -- so FileType, LSP, treesitter and lazy-loaded plugins fire for that file
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

-- error / warning counts of all buffers in this pane's tmux options, the tmux status line shows
-- them next to the git branch (@nvim_diag in tmux.conf); nvim has no status line of its own to put them in
local pane = vim.env.TMUX_PANE
if pane then
  local shown = "0/0"
  local function tmux_diagnostics(count)
    count = count or vim.diagnostic.count(nil)
    local values = {
      ["@nvim_errors"] = count[vim.diagnostic.severity.ERROR] or 0,
      ["@nvim_warns"] = count[vim.diagnostic.severity.WARN] or 0,
    }
    local key = values["@nvim_errors"] .. "/" .. values["@nvim_warns"]
    if key == shown then return end
    shown = key
    local cmd = { "tmux" }
    for name, n in pairs(values) do
      vim.list_extend(cmd, n > 0 and { "set", "-p", "-t", pane, name, tostring(n), ";" }
        or { "set", "-pu", "-t", pane, name, ";" })
    end
    -- redraw now, not on the next status-interval
    vim.list_extend(cmd, { "refresh-client", "-S" })
    return vim.system(cmd)
  end

  -- DiagnosticChanged fires per buffer and per server, often many times in a row
  local timer = assert(vim.uv.new_timer())
  local diagGrp = api.nvim_create_augroup("TmuxDiagnostics", { clear = true })
  api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function() timer:start(300, 0, vim.schedule_wrap(function() tmux_diagnostics() end)) end,
    group = diagGrp,
  })
  -- the pane outlives nvim: clear the counts, waiting so tmux gets them before nvim exits
  api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      timer:stop()
      local job = tmux_diagnostics({})
      if job then job:wait(500) end
    end,
    group = diagGrp,
  })
end
