local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- behaviours
-- resolve fish portably: macOS (arm/intel homebrew) then Linux
local function first_executable(candidates, fallback)
	for _, p in ipairs(candidates) do
		-- existence probe, no side effect
		if os.rename(p, p) then
			return p
		end
	end
	return fallback
end

local fish_candidates
if wezterm.target_triple:find("darwin") then
	fish_candidates = { "/opt/homebrew/bin/fish", "/usr/local/bin/fish", "/usr/bin/fish" }
else
	fish_candidates = { "/home/linuxbrew/.linuxbrew/bin/fish", "/usr/bin/fish", "/bin/fish" }
end

config.default_prog = { first_executable(fish_candidates, "fish"), "-l" }
config.max_fps = 180
config.window_close_confirmation = "NeverPrompt"
config.switch_to_last_active_tab_when_closing_tab = true
config.warn_about_missing_glyphs = false

-- visuals
local theme = "Kanagawa (Gogh)"
local scheme = wezterm.get_builtin_color_schemes()[theme]
config.color_scheme = theme
config.command_palette_bg_color = scheme.background
config.command_palette_fg_color = scheme.foreground
config.font_size = 15
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_opacity = 0.9
config.command_palette_rows = 14

-- tabs
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
-- config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.colors = {
	tab_bar = {
		background = scheme.background,
		active_tab = {
			bg_color = scheme.foreground,
			fg_color = scheme.background,
		},
		inactive_tab = {
			bg_color = scheme.background,
			fg_color = scheme.foreground,
		},
		inactive_tab_hover = {
			bg_color = scheme.background,
			fg_color = scheme.foreground,
			italic = true,
		},
	},
}

-- hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

-- keys
config.leader = {
	key = "a",
	mods = "CTRL",
}
config.keys = {
	{
		key = "Space",
		mods = "LEADER",
		action = act.ActivateCommandPalette,
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Right", size = { Percent = 38 } }),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Down", size = { Percent = 35 } }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
}

return config
