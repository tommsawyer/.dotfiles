-- gruvbox-material, hard: dark or light, as `theme light|dark` (~/.config/theme) left it in
-- ~/.local/state/theme; read once at startup, so a switch takes a restart. Colours of that style for
-- the dim outside the colorscheme: the spec files load before its palette is on rtp
local f = io.open((vim.env.XDG_STATE_HOME or vim.env.HOME .. "/.local/state") .. "/theme")
local light = f ~= nil and f:read("l") == "light"
if f then
  f:close()
end

return {
  light = light,
  -- bg_dim: the picker backdrop
  bg_d = light and "#f3eac7" or "#141617",
}
