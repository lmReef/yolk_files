-- Shared program variables. require() gives every file its own Lua scope, so
-- values used by more than one file live here.

return {
	terminal = "wezterm",
	fileManager = "thunar",
	browser = "floorp",
	music = "spot",
	notes = "triliumnext",
	lock = "hyprlock",
	menu = "rofi -show drun",
	taskbar = "ashell",

	-- monitor selectors
	pm0 = "desc:LG Electronics LG ULTRAGEAR 406NTHM29041",
	pm1 = "desc:AOC 24G42E ZX6R8HA001186",
	wm_laptop = "desc:AU Optronics 0x6DA8",
	wm0 = "desc:Dell Inc. DELL U2724DE D7BP634",
	wm1 = "desc:Dell Inc. DELL U2724DE JY9P634",
}
