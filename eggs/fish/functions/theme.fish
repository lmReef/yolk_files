function theme --description 'update theme based on wallpaper'

    if test -e $1
        set wallpaper $1
    else
        set wallpaper (fd -d1 $1 ~/Pictures/wallpapers | shuf -n1)
    end

    # copy wallpaper to persistent location for other process/configs to use w caching/reboots
    set ext (path extension $wallpaper)
    set current_wallpaper ~/.cache/current_wallpaper.$ext
    rm -f "~/.cache/current_wallpaper.*"
    # ln -f $wallpaper $current_wallpaper

    # wal -i $wallpaper

    # # # hyprpaper
    # # # if ! pgrep hyprpaper &>/dev/null; then
    # # #     hyprctl --instance 0 dispatch exec hyprpaper
    # # # fi
    # # # echo -e "preload = $current_wallpaper\nwallpaper = , $current_wallpaper" | tr -d '"' | cat >"$HOME/.config/hypr/hyprpaper.conf"
    # # # hyprctl --instance 0 hyprpaper reload ",$(echo "$current_wallpaper" | tr -d '"')"

    # hyprland colors
    # set wal_dir ~/.cache/wal
    # set wal_colors $wal_dir/colors
    # set hypr_colors $wal_dir/colors-hyprland.conf
    # touch $hypr_colors
    # for color in cat $wal_colors
    #     echo ""
    # end
end
