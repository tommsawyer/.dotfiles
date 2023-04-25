local api = vim.api

local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank({ higroup = \"Visual\" })",
  group = yankGrp,
})
