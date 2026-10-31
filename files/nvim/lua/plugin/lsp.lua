-- what the servers have in common: diagnostics, keys, starting them. The settings of each server
-- are in after/lsp/<name>.lua (after: nvim-lspconfig's own lsp/<name>.lua must not override them)

local function set_keys(buf)
  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or 'n', lhs, rhs, { buf = buf, desc = desc })
  end
  -- the lists go to Trouble, on the built-in gr* / gO keys too (those open quickfix)
  local function trouble(keys, list, desc)
    for _, lhs in ipairs(keys) do
      map(lhs, '<cmd>Trouble ' .. list .. '<cr>', desc .. ' (Trouble)')
    end
  end

  map('K', vim.lsp.buf.hover, 'Hover')
  map('gd', vim.lsp.buf.definition, 'Go to definition')
  map('ga', vim.lsp.buf.code_action, 'Code action', { 'n', 'v' })
  trouble({ 'grr' }, 'lsp_references focus=true', 'References')
  trouble({ 'gi', 'gri' }, 'lsp_implementations focus=true', 'Implementations')
  trouble({ 'gy', 'grt' }, 'lsp_type_definitions focus=true', 'Type definitions')
  trouble({ '<leader>s', 'gO' }, 'symbols', 'Symbols')
end

-- go: add missing / remove unused imports on save (gopls organizeImports),
-- conform then formats with gofumpt
local function organize_go_imports(args)
  local client = vim.lsp.get_clients({ bufnr = args.buf, name = 'gopls' })[1]
  if not client then
    return
  end

  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
  local result = client:request_sync('textDocument/codeAction', params, 1000, args.buf)
  for _, action in ipairs(result and result.result or {}) do
    if not action.edit then
      local resolved = client:request_sync('codeAction/resolve', action, 1000, args.buf)
      action = resolved and resolved.result or action
    end
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp', -- loaded first: it adds its completion capabilities to vim.lsp.config('*')
    'b0o/schemastore.nvim',
  },

  config = function()
    vim.diagnostic.config({
      -- message only on the cursor line, the rest just has signs and underlines
      virtual_text = { current_line = true },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '\u{f057} ',
          [vim.diagnostic.severity.WARN] = '\u{f071} ',
          [vim.diagnostic.severity.HINT] = '\u{f0eb} ',
          [vim.diagnostic.severity.INFO] = '\u{f05a} ',
        },
      },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
      callback = function(args) set_keys(args.buf) end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('UserGoImports', { clear = true }),
      pattern = '*.go',
      callback = organize_go_imports,
    })

    -- the default filetypes plus go templates; here, not in after/lsp: that file cannot read
    -- the config it is a part of
    vim.lsp.config('emmet_language_server', {
      filetypes = vim.list_extend(vim.deepcopy(vim.lsp.config.emmet_language_server.filetypes), { 'templ', 'gotmpl' }),
    })

    vim.lsp.enable({
      'templ',
      'gopls',
      'tsc', -- native TypeScript 7 language server
      'jsonls',
      'yamlls',
      'lua_ls',
      'emmet_language_server',
      'marksman',
      'sourcekit', -- swift, comes with Xcode (kotlin is started by kotlin.nvim)
      'ruby_lsp',
      'basedpyright',
      'ruff',
      'bashls',
    })
  end
}
