local luasnip = require("luasnip")

luasnip.config.set_config {
  history = true
}

vim.keymap.set({"i", "s"}, "<C-j>", function ()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-k>", function ()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-l>", function ()
  if luasnip.choice_active() then
    luasnip.change_choice()
  end
end, { silent = true })
