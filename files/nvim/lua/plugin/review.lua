-- a local pull request: comments on the lines of a diff go to the agent as one message.
-- ,rr the working tree, ,rc commits, ,rb a branch; in the diff i comments, r marks a file reviewed,
-- S sends the comments to the agent through sidekick, q ends the round (exports and archives them)
return {
  "georgeguimaraes/review.nvim",
  version = "*",
  dependencies = {
    "esmuellert/codediff.nvim", -- downloads its diff library on first use
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy", -- not cmd: notes on files show up without :Review
  opts = {
    export = {
      -- replaces the default header together with its legend of types and of ~
      header = table.concat({
        "Я посмотрел изменения, вот комментарии. По каждому пункту либо исправь, либо объясни, почему нет.",
        "Вопросы и NOTE не повод что-то менять, если правка явно не просится. Ответь списком с теми же номерами.",
        "",
        "Типы: ISSUE (проблема), SUGGESTION (улучшение), NOTE (замечание или вопрос), PRAISE (так и оставь).",
        "`~` перед номером строки означает старую (левую) сторону диффа.",
      }, "\n"),
    },
  },
  keys = {
    { "<leader>rr", "<cmd>Review<cr>",         desc = "Review working tree" },
    { "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
    { "<leader>rb", "<cmd>Review branch<cr>",  desc = "Review branch" },
    { "<leader>rn", ":Review note<cr>",        mode = { "n", "x" },            desc = "Review: note here" },
    { "<leader>re", "<cmd>Review edit<cr>",    desc = "Review: edit comment" },
    { "<leader>rd", "<cmd>Review delete<cr>",  desc = "Review: delete comment" },
    { "<leader>rl", "<cmd>Review list<cr>",    desc = "Review: list comments" },
  },
}
