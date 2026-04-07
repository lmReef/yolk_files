export let data = #{ };

export let eggs = #{
    // ~/
    git: #{ targets: #{".gitconfig": "~/.gitconfig"}, enabled: true, templates: [] },
    tmux: #{ targets: #{".tmux.conf": "~/.tmux.conf"}, enabled: true, templates: [] },

    // ~/.config
    fish: #{ targets: "~/.config/fish", enabled: true, templates: [] },
    nvim: #{ targets: "~/.config/nvim", enabled: true, templates: [] },
    alacritty: #{ targets: "~/.config/alacritty", enabled: io::command_available("alacritty"), templates: [] },
    hypr: #{ targets: "~/.config/hypr", enabled: "hyprland" in SYSTEM.desktop_env, templates: ["hyprland.conf", "keybinds.conf"] },
    paru: #{ targets: "~/.config/paru", enabled: "Arch" in SYSTEM.distro, templates: [] },

    lsd: #{ targets: "~/.config/lsd", enabled: true, templates: [] },
    rofi: #{ targets: "~/.config/rofi", enabled: io::command_available("rofi"), templates: [] },
    swaync: #{ targets: "~/.config/swaync", enabled: io::command_available("swaync"), templates: [] },
    waybar: #{ targets: "~/.config/waybar", enabled: io::command_available("waybar"), templates: [] },
    eww: #{ targets: "~/.config/eww", enabled: io::command_available("eww"), templates: [] },

    // ~/.local
    scripts: #{ targets: "~/.local/bin/scripts", enabled: true, templates: [] },
};
