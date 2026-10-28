-- only tables, checkboxes and --- are rendered, the rest of markdown stays as is (all of it was too busy)
local off = { enabled = false }

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    pipe_table = { enabled = true },
    -- 2, not the default 3: wrapping text inside table cells needs at least 2;
    -- it also hides ** ` and link urls off the cursor line, the cursor line stays raw
    win_options = { conceallevel = { rendered = 2 } },
    bullet = off,
    -- a done task is struck through whole, not just its [x]
    checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
    code = off,
    document = off,
    heading = off,
    html = off,
    indent = off,
    inline_highlight = off,
    latex = off,
    link = off,
    paragraph = off,
    quote = off,
    sign = off,
    yaml = off,
  },
}
