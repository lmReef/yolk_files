-- Workspace and window rules.
-- https://wiki.hyprland.org/Configuring/Workspace-Rules
-- https://wiki.hyprland.org/Configuring/Window-Rules

local vars = require("vars")

-- Hyprland 0.57 deprecates the `on_created_empty` workspace rule (see
-- `hyprctl deprecated-config`). Supported replacement: a "workspace.created"
-- handler that checks the workspace's is_empty field.
local empty_workspace_launchers = {
	[1] = vars.browser,
	[2] = "~/.local/bin/scripts/open_game_hubs.sh",
}

hl.on("workspace.created", function(ws)
	local launcher = empty_workspace_launchers[ws.id]
	if launcher and ws.is_empty then
		hl.exec_cmd(launcher)
	end
end)

hl.workspace_rule({
	workspace = "1",
	monitor = vars.pm1,
	default = true,
})

hl.workspace_rule({
	workspace = "2",
	monitor = vars.pm1,
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

-- Proton/Wine hosts tooltips, drop-downs and dialogs as separate X11 toplevels
-- that reuse the game's window class, so the `games` rule above force-fullscreens
-- them the moment they map (BodySlide: hovering a button gave a screen-sized
-- window). Those popups are always nameless; dialogs are modal. Later rules win,
-- so both below override the games rule's fullscreen/workspace/focus behaviour.
hl.window_rule({
	name = "proton popups",
	match = {
		class = "^(steam_app_.*|gamescope)",
		title = "^$",
	},
	float = true,
	fullscreen = false,
	decorate = false,
	no_focus = true,
	no_initial_focus = true,
	no_anim = true,
	no_shadow = true,
})

-- Titled dialogs can't be told apart from the game by any rule matcher: `modal`
-- never matches an X11 window (Wine's dialogs stay non-modal as far as Hyprland
-- is concerned) and `floating` is still false for every window while rules run.
-- By the time `window.open` fires the difference is visible — the game window
-- maps tiled, its dialogs map floating and already fullscreen by the games rule
-- above — so revert the fullscreen there instead of trying to match it.
hl.on("window.open", function(w)
	local class = w.class or ""
	if not (class:match("^steam_app_") or class == "gamescope") then
		return
	end
	if not w.floating or (w.fullscreen or 0) == 0 then
		return
	end
	hl.dispatch(hl.dsp.window.fullscreen({ window = w, mode = 0 }))
end)

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
