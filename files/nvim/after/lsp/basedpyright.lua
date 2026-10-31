---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,                -- ruff does it
      analysis = { typeCheckingMode = 'standard' }, -- default "recommended" is very noisy
    },
  },
}
