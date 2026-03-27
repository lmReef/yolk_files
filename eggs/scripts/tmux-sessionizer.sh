#!/bin/bash

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}

has_session() {
    tmux ls | grep -q "^$1:"
}

hydrate() {
    tmux send-keys -t "$1" "source $HOME/.local/bin/scripts/tmux-hydrate.sh $1 $2" c-M
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd -HL -td -d1 . "$HOME/" "$HOME/projects" "$HOME/.config" "$HOME/.local/bin" $ADDITIONAL_PROJECTS | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    # hydrate "$selected_name" "$selected"
    exit 0
fi

if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    # hydrate "$selected_name" "$selected"
fi

switch_to "$selected_name"
