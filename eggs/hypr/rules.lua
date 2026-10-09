-- Workspace and window rules.
-- https://wiki.hyprland.org/Configuring/Workspace-Rules
-- https://wiki.hyprland.org/Configuring/Window-Rules

local vars = require("vars")

hl.workspace_rule({
	workspace = "1",
	monitor = vars.pm1,
	on_created_empty = vars.browser,
	default = true,
})

hl.workspace_rule({
	workspace = "2",
	monitor = vars.pm1,
	on_created_empty = "~/.local/bin/scripts/open_game_hubs.sh",
})

hl.workspace_rule({
	workspace = "3",
	monitor = vars.pm0,
	default = true,
})

hl.workspace_rule({
	workspace = "4",
	monitor = vars.pm0,
})

hl.workspace_rule({
	workspace = "5",
	monitor = vars.pm0,
})

hl.workspace_rule({
	workspace = "6",
	monitor = vars.pm1,
})

hl.window_rule({
	name = "games",
	match = {
		class = "^(steam_app_.*|gamescope)",
	},
	workspace = "4",
	fullscreen = true,
})

hl.window_rule({
	name = "hubs",
	match = {
		title = "^(Steam|Sign in to steam|Heroic Games Launcher)",
	},
	workspace = "2",
	fullscreen = false,
	focus_on_activate = false,
})

hl.window_rule({
	name = "pavucontrol popup",
	match = {
		title = "Volume Control",
	},
	float = true,
	pin = true,
	size = "20% 50%",
	move = "100%-w-10 40",
})

hl.window_rule({
	name = "terminal",
	match = {
		initial_title = "wezterm",
	},
	workspace = "3",
})

hl.window_rule({
	name = "discord thihng",
	match = {
		initial_title = "Discord Popout",
	},
	float = true,
	pin = true,
	move = "100%-w-10 100%-w-10",
})

hl.window_rule({
	name = "godot-debug",
	match = {
		initial_title = "Godot",
		fullscreen = true,
	},
	workspace = "6",
})

hl.window_rule({
	name = "floating",
	match = {
		initial_title = "Kdenlive",
	},
	float = true,
})

hl.window_rule({
	name = "picture in picture",
	match = {
		title = "Picture-in-[Pp]icture",
	},
	float = true,
	pin = true,
	size = "320 180",
	move = "100%-w-10 100%-w-10",
	opacity = 0.8,
	focus_on_activate = false,
})

hl.window_rule({
	name = "ignore maximize requests",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix dragging issues",
	match = {
		class = "^$",
		title = "^$",
		float = true,
		pin = true,
		xwayland = true,
	},
	no_focus = true,
	fullscreen = false,
})
