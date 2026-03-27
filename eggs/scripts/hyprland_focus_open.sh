#!/bin/zsh

selector="$(hyprctl --instance 0 clients | grep -E "\s+\w+: $1" -m1 | sed -E "s/\s+(\w+): .+/\1/")"

if [ "$selector" != "" ]; then
    hyprctl --instance 0 dispatch focuswindow "$selector:$1"
else
    "$1" &
fi
