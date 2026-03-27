#!/bin/bash

~/.local/bin/scripts/tmux-sessionizer.sh $(tmux ls | grep -o -P "^.*(?=: )" | fzf)
