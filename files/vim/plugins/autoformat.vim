Glaive codefmt gofmt_executable="goimports"

augroup AutoFormat
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
augroup END
