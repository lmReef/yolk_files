-- See https://wiki.hyprland.org/Configuring/Monitors/

local vars = require("vars")

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = vars.pm0,
	mode = "highres@highrr",
	position = "auto",
})

hl.monitor({
	output = vars.pm1,
	mode = "1920x1080",
	position = "auto-left",
})

hl.monitor({
	output = vars.wm_laptop,
	mode = "highres@highrr",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = vars.wm0,
	mode = "highres@highrr",
	position = "auto-right",
	scale = "1",
})

hl.monitor({
	output = vars.wm1,
	mode = "highres@highrr",
	position = "auto-right",
	scale = "1",
})
