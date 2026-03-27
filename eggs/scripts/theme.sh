#!/bin/zsh

if [[ -f "$1" ]]; then
    wallpaper="$1"
else
    wallpaper="$(fd -d1 "$1" "$HOME/Pictures/wallpapers/" | shuf -n 1)"
fi

# copy wallpaper to persistent location for other process/configs to use w caching/reboots
ext="${$(basename "$wallpaper")##*.}"
current_wallpaper="$HOME/.cache/current_wallpaper.$ext"
rm ~/.cache/current_wallpaper.*
ln -f "$wallpaper" "$current_wallpaper"

wal -i "$wallpaper"

# hyprpaper
# if ! pgrep hyprpaper &>/dev/null; then
#     hyprctl --instance 0 dispatch exec hyprpaper
# fi
# echo -e "preload = $current_wallpaper\nwallpaper = , $current_wallpaper" | tr -d '"' | cat >"$HOME/.config/hypr/hyprpaper.conf"
# hyprctl --instance 0 hyprpaper reload ",$(echo "$current_wallpaper" | tr -d '"')"

# swaybg
# swaybg -m fill -i "$wallpaper" &
# create-lock-image.sh "$wallpaper"
awww img "$wallpaper"

# create waybar style.css from template
# waybar_stylesheet="$HOME/.config/waybar/style.css"
# template="$HOME/.config/waybar/template-style.css"
# wal_vars="$HOME/.cache/wal/colors"
# cat "$template" >"$waybar_stylesheet"
# index=0
# for color in $(cat "$wal_vars"); do
#     sed "s/var(--color$index)/$color/" <<<"$(cat "$waybar_stylesheet")" >"$waybar_stylesheet"
#     ((index += 1))
# done <"$wal_vars"
