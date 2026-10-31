-- lint + format + imports; hover comes from basedpyright
---@type vim.lsp.Config
return {
  on_attach = function(client) client.server_capabilities.hoverProvider = false end,
}
