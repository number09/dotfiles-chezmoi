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

-- Finally, return the configuration to wezterm:
return config
