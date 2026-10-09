-- https://wiki.hyprland.org/Configuring/Variables/#input

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:escape",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        scroll_factor = 1.25,
        repeat_rate = 45,
        repeat_delay = 350,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({
    name = "keyd-virtual-pointer",
    sensitivity = 1.0,
    scroll_factor = 2,
})
