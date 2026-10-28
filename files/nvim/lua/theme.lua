-- onedark warmer or light, as `theme light|dark` (~/.config/theme) left it in ~/.local/state/theme;
-- read once at startup, so a switch takes a restart. bg_d of that style for the dim outside the
-- colorscheme (vimade, the picker backdrop): the spec files load before onedark's palette is on rtp
local f = io.open((vim.env.XDG_STATE_HOME or vim.env.HOME .. "/.local/state") .. "/theme")
local light = f ~= nil and f:read("l") == "light"
if f then
  f:close()
end

return {
  light = light,
  style = light and "light" or "warmer",
  bg_d = light and "#c9c9c9" or "#1b1c1e",
}
