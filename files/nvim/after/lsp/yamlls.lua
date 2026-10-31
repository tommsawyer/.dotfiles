---@type vim.lsp.Config
return {
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
}
