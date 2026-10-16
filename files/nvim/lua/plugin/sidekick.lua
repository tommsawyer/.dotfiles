-- AI CLI tools (claude, opencode, codex, gemini...) in a tmux split next to nvim:
-- send the selection / position / file with a prompt, the agent edits, nvim reloads the files.
-- <leader>i... because <leader>a is "reveal in tree" here
local function cli() return require("sidekick.cli") end

local ns = vim.api.nvim_create_namespace("sidekick_thinking")
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

-- spinner at the end of the line the agent works on, while its pane shows "esc to interrupt".
-- sidekick knows nothing about the agent being busy, so peek at the agent's screen twice a second;
-- gives up if the agent never got busy in 20s (it didn't start, or the prompt got lost)
local function thinking(buf, row)
  local timer, id, frame, busy, idle, start = assert(vim.uv.new_timer()), nil, 0, false, 0, vim.uv.now()

  local function poll()
    local state = require("sidekick.cli.state").get({ attached = true })[1]
    local pane = state and state.session and state.session.tmux_pane_id
    if not pane then return end -- the agent is still starting
    vim.system({ "tmux", "capture-pane", "-p", "-t", pane }, { text = true }, function(out)
      local screen = (out.stdout or ""):lower()
      if screen:find("esc to interrupt", 1, true) or screen:find("esc interrupt", 1, true) then
        busy, idle = true, 0
      else
        idle = idle + 1
      end
    end)
  end

  timer:start(0, 100, vim.schedule_wrap(function()
    if timer:is_closing() then return end
    local valid = vim.api.nvim_buf_is_valid(buf)
    if not valid or (busy and idle >= 2) or (not busy and vim.uv.now() - start > 20000) then
      timer:close()
      if valid and id then vim.api.nvim_buf_del_extmark(buf, ns, id) end
      return
    end
    -- the mark follows the edits; if a reload of the file dropped it, put it back on the same line
    local pos = id and vim.api.nvim_buf_get_extmark_by_id(buf, ns, id, {}) or {}
    row = pos[1] or math.min(row, vim.api.nvim_buf_line_count(buf) - 1)
    frame = frame + 1
    id = vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
      id = id,
      virt_text = { { spinner[frame % #spinner + 1] .. " AI думает", "DiagnosticHint" } },
      virt_text_pos = "eol",
    })
    if frame % 5 == 1 then poll() end
  end))
end

return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  opts = {
    nes = { enabled = false }, -- next edit suggestions need a Copilot subscription
    cli = {
      mux = {
        enabled = true,
        backend = "tmux",
        -- a real tmux pane to the right: survives nvim restarts, shows up in prefix s,
        -- Shift+Enter and the rest of tmux keys work as in any pane
        create = "split",
        split = { vertical = true, size = 0.4 },
      },
      tools = {
        nessy = {
          cmd = { "nessy" },
          is_proc = "\\<nessy\\>",
        },
      },
      -- the built-in prompts in russian: agents answer in the language of the question
      prompts = {
        changes         = "Посмотри мои изменения, есть ли проблемы?",
        diagnostics     = "Помоги исправить диагностики в {file}:\n{diagnostics}",
        diagnostics_all = "Помоги исправить эти диагностики:\n{diagnostics_all}",
        document        = "Добавь документацию к {function|line}",
        explain         = "Объясни {this}",
        fix             = "Исправь {this}",
        optimize        = "Как можно оптимизировать {this}?",
        review          = "Посмотри {file}: есть ли проблемы или что можно улучшить?",
        tests           = "Напиши тесты для {this}",
      },
    },
  },
  keys = {
    { "<leader>ii", function() cli().toggle() end,                                desc = "AI: toggle CLI" },
    { "<leader>ic", function() cli().select({ filter = { installed = true } }) end, desc = "AI: choose CLI" },
    { "<leader>id", function() cli().close() end,                                 desc = "AI: detach CLI session" },
    -- main cases: explain the selection / position, or send it and type what to do with it
    { "<leader>ie", function() cli().send({ prompt = "explain", submit = true, focus = true }) end, mode = { "n", "x" }, desc = "AI: explain this" },
    { "<leader>is", function() cli().send({ msg = "{this}", focus = true }) end,   mode = { "n", "x" }, desc = "AI: send this" },
    { "<leader>if", function() cli().send({ msg = "{file}", focus = true }) end,   desc = "AI: send file" },
    { "<leader>ip", function() cli().prompt() end,                                 mode = { "n", "x" }, desc = "AI: pick a prompt" },
    -- mini vibe coding: select a spot, say what to write (empty = figure it out), the agent edits right there
    { "<leader>iw", function()
      local where = cli().render({ msg = "{this}" }) -- grab the selection before the input steals focus
      local buf, row = vim.api.nvim_get_current_buf(), math.min(vim.fn.line("v"), vim.fn.line(".")) - 1
      if vim.fn.mode():match("^[vV\22]") then vim.cmd("normal! \27") end
      vim.ui.input({ prompt = "AI: что дописать? (пусто - сам) " }, function(task)
        if not task then return end -- <esc>
        if vim.trim(task) == "" then
          task = "сам разберись по контексту (комментарии, TODO, недописанный код, окружение), чего здесь не хватает, и допиши"
        end
        cli().send({
          msg = table.concat({
            "Допиши код в " .. where .. ": " .. task,
            "Правь файл сам и только в этом месте, остальное не трогай.",
            "Следуй стилю и соглашениям окружающего кода. Без объяснений, просто сделай.",
          }, "\n"),
          submit = true,
        })
        thinking(buf, row)
      end)
    end, mode = { "n", "x" }, desc = "AI: write code here" },
    -- jump between nvim and the agent (C-. reaches apps thanks to tmux extended keys)
    { "<c-.>",      function() cli().focus() end,                                 mode = { "n", "t", "i", "x" }, desc = "AI: focus CLI" },
  },
}
