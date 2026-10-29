-- same physical keys as the default labels, in the russian layout
local ru_labels = "фывапролдйцукенгшщзячсмить"
ru_labels = ru_labels .. vim.fn.toupper(ru_labels)

-- a search typed in russian gets russian labels, so jumping needs no layout switch
local function labeler(_, state)
  state.flash_labeler = state.flash_labeler or require("flash.labeler").new(state)
  state.flash_labels = state.flash_labels or state.opts.labels
  if not state.pattern():find("[а-яёА-ЯЁ]") then
    state.opts.labels = state.flash_labels
    return state.flash_labeler:update()
  end
  state.opts.labels = ru_labels
  -- flash compares labels with string.lower, which leaves cyrillic as is: with ignorecase
  -- an uppercase letter after a match then drops every label
  local lower = string.lower
  string.lower = vim.fn.tolower
  local ok, err = pcall(state.flash_labeler.update, state.flash_labeler)
  string.lower = lower
  if not ok then
    error(err)
  end
end

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labeler = labeler,
    modes = {
      -- / and ? stay plain search, jumps go through Enter
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    -- plain jump on Enter, except special buffers (quickfix, terminal...) where Enter does its own thing
    {
      "<CR>",
      function() return vim.bo.buftype == "" and "<cmd>lua require('flash').jump()<cr>" or "<CR>" end,
      mode = "n",
      expr = true,
      desc = "Flash",
    },
    { "r", mode = "o",          function() require("flash").remote() end,     desc = "Remote Flash" },
    { "S", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
