require('delaytrain').setup {
  delay_ms = 500,   -- How long repeated usage of a key should be prevented
  grace_period = 2, -- How many repeated keypresses are allowed
  keys = {
    ['nv'] = { 'h', 'j', 'k', 'l', '{', '}' },
  },
  ignore_filetypes = {}, -- Example: set to {"help", "NvimTr*"} to
}
