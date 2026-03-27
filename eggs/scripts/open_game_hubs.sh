#!/bin/bash

if pgrep steamwebhelper &>/dev/null; then
    steam
fi

if pgrep heroic &>/dev/null; then
    heroic
fi
