-- AI CLI tools (claude, opencode, codex, gemini...) in a tmux split next to nvim:
-- send the selection / position / file with a prompt, the agent edits, nvim reloads the files.
-- <leader>i... because <leader>a is "reveal in tree" here
local function cli() return require("sidekick.cli") end

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
      end)
    end, mode = { "n", "x" }, desc = "AI: write code here" },
    -- jump between nvim and the agent (C-. reaches apps thanks to tmux extended keys)
    { "<c-.>",      function() cli().focus() end,                                 mode = { "n", "t", "i", "x" }, desc = "AI: focus CLI" },
  },
}
