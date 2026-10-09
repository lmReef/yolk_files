-- See https://wiki.hyprland.org/Configuring/Keywords/
-- https://wiki.hyprland.org/Configuring/Binds/

local vars = require("vars")
local mainMod = "SUPER"

-- functional
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd(vars.lock))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(vars.terminal))
hl.bind("CONTROL + Space", hl.dsp.exec_cmd("Handy --toggle-transcription"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(vars.menu))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- applications
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(vars.fileManager .. " ~/Downloads"))
-- bind = $mainMod, U, exec, ~/.local/bin/scripts/hyprland_focus_open.sh steam
-- bind = $mainMod, I, exec, ~/.local/bin/scripts/hyprland_focus_open.sh discord
-- bind = $mainMod, O, exec, ~/.local/bin/scripts/hyprland_focus_open.sh freetube
-- bind = $mainMod, N, exec, ~/.local/bin/scripts/hyprland_focus_open.sh $notes
-- bind = $mainMod, M, exec, ~/.local/bin/scripts/hyprland_focus_open.sh $music

-- workspaces
hl.bind(mainMod .. " + Q", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + W", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + E", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 6 }))

hl.bind(mainMod .. " + k", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ workspace = "e+1" }))

-- Example special workspace (scratchpad)
-- bind = $mainMod, escape, togglespecialworkspace, overlay

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- bind = $mainMod SHIFT, escape, movetoworkspace, special:overlay

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("playerctl next"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("playerctl play-pause"))
