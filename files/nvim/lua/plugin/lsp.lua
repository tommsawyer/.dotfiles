return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp', -- loaded first: it adds its completion capabilities to vim.lsp.config('*')
    'b0o/schemastore.nvim',
  },

  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '\u{f057} ',
          [vim.diagnostic.severity.WARN] = '\u{f071} ',
          [vim.diagnostic.severity.HINT] = '\u{f0eb} ',
          [vim.diagnostic.severity.INFO] = '\u{f05a} ',
        },
      },
    })

    -- progress of LSP servers as one small notification per server (laststatus = 0, so there is
    -- no statusline for vim.lsp.status()); plus "starting..." for servers that take more than
    -- a second to answer initialize (ruby-lsp installing its gems, for example)
    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    local function lsp_notify(name, text, done)
      vim.notify(name .. ': ' .. text, vim.log.levels.INFO, {
        id = 'lsp_progress_' .. name,
        style = 'minimal',
        icon = done and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1],
      })
    end

    vim.api.nvim_create_autocmd('LspProgress', {
      group = vim.api.nvim_create_augroup('UserLspProgress', { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value
        if not client or type(value) ~= 'table' then return end
        if value.kind == 'end' then return lsp_notify(client.name, 'готов', true) end
        local parts = vim.tbl_filter(function(s) return s ~= '' end, {
          value.title or '', value.message or '', value.percentage and (value.percentage .. '%') or '',
        })
        lsp_notify(client.name, table.concat(parts, ' '))
      end,
    })

    local starting = {} ---@type table<string, boolean> servers that did not attach yet
    local spinners = {} ---@type table<string, any> uv timers of their "starting..." notifications
    vim.lsp.config('*', {
      before_init = function(_, config)
        local name = config.name
        starting[name] = true
        vim.defer_fn(function()
          if not starting[name] or spinners[name] then return end
          spinners[name] = assert(vim.uv.new_timer())
          spinners[name]:start(0, 100, vim.schedule_wrap(function() lsp_notify(name, 'запускается…') end))
        end, 1000)
      end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
      callback = function(args)
        local attached = vim.lsp.get_client_by_id(args.data.client_id)
        if attached and starting[attached.name] then
          starting[attached.name] = nil
          local timer = spinners[attached.name]
          if timer then
            spinners[attached.name] = nil
            timer:stop()
            timer:close()
            lsp_notify(attached.name, 'готов', true)
          end
        end

        local buf = args.buf
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buf = buf, desc = 'Hover' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buf = buf, desc = 'Go to definition' })
        vim.keymap.set('n', 'gy', '<cmd>Trouble lsp_type_definitions focus=true<cr>',
          { buf = buf, desc = 'Type definitions (Trouble)' })
        vim.keymap.set('n', 'gi', '<cmd>Trouble lsp_implementations focus=true<cr>',
          { buf = buf, desc = 'Implementations (Trouble)' })
        vim.keymap.set('n', '<leader>s', '<cmd>Trouble symbols<cr>', { buf = buf, desc = 'Symbols (Trouble)' })
        -- built-in gr*/gO defaults open quickfix; send the lists to Trouble too
        vim.keymap.set('n', 'grr', '<cmd>Trouble lsp_references focus=true<cr>',
          { buf = buf, desc = 'References (Trouble)' })
        vim.keymap.set('n', 'gri', '<cmd>Trouble lsp_implementations focus=true<cr>',
          { buf = buf, desc = 'Implementations (Trouble)' })
        vim.keymap.set('n', 'grt', '<cmd>Trouble lsp_type_definitions focus=true<cr>',
          { buf = buf, desc = 'Type definitions (Trouble)' })
        vim.keymap.set('n', 'gO', '<cmd>Trouble symbols<cr>', { buf = buf, desc = 'Symbols (Trouble)' })
        vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, { buf = buf, desc = 'Code action' })
      end,
    })

    -- go: add missing / remove unused imports on save (gopls organizeImports),
    -- conform then formats with gofumpt
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('UserGoImports', { clear = true }),
      pattern = '*.go',
      callback = function(args)
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
      end,
    })

    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          templateExtensions = { 'html', 'tmpl', 'gotmpl' },
        },
      },
    })

    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          keyOrdering = false,
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require('schemastore').yaml.schemas({
            extra = {
              -- same url as the catalog entry, so it replaces it: keep the catalog globs and add included files
              {
                name = 'gitlab-ci',
                description = 'GitLab CI: main file and files included from .gitlab/ci/',
                url =
                'https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json',
                fileMatch = {
                  '**/.gitlab-ci.yml', '**/.gitlab-ci.yaml', '**/*.gitlab-ci.yml', '**/*.gitlab-ci.yaml',
                  '**/.gitlab/ci/*.yml', '**/.gitlab/ci/*.yaml',
                },
              },
            },
          }),
          -- gitlab ci `!reference [job, script]`
          customTags = { '!reference sequence' },
        },
      },
    })

    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          disableOrganizeImports = true,                -- ruff does it
          analysis = { typeCheckingMode = 'standard' }, -- default "recommended" is very noisy
        },
      },
    })

    -- ruff: lint + format + imports; hover comes from basedpyright
    vim.lsp.config('ruff', {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    })

    -- the default filetypes plus go templates
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
