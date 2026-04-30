local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "/usr/bin/env", "fish", "-l" }
config.enable_wayland = true
config.max_fps = 180

-- visuals
config.color_scheme = "Kanagawa (Gogh)"
config.font_size = 12
config.window_background_opacity = 0.9
config.kde_window_background_blur = true
-- tabs
config.hide_tab_bar_if_only_one_tab = true
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

return config
