-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- 更新を自動検知してreload
config.automatically_reload_config = false

-- config reloadをwindowに通知
wezterm.on('window-config-reloaded', function(window, pane)
  wezterm.log_info 'the config was reloaded for this window!'
end)



-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 14
-- color scheme
config.color_scheme = "iceberg-dark"

-- font
config.font = wezterm.font("Ricty Diminished")

-- パネルの視認性を向上
-- 非アクティブなパネルを暗くする (hsb: 色相, 彩度, 明度)
config.inactive_pane_hsb = {
  saturation = 0.6,  -- 彩度を60%に (かなり色あせた感じ)
  brightness = 0.4,  -- 明度を40%に (かなり暗くする)
}

config.keys = {
  -- パネル分割
  { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- 縦分割 (CMD+Shift+|)
  { key = 'd', mods = 'CMD',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },   -- 横分割 (CMD+-)

  -- パネル移動
  { key = 'h', mods = 'CMD',       action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CMD',       action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CMD',       action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CMD',       action = wezterm.action.ActivatePaneDirection 'Right' },

  -- パネルを閉じる
  { key = 'w', mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = true } },
}




-- Finally, return the configuration to wezterm:
return config
