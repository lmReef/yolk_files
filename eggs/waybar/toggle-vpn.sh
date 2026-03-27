#!/usr/bin/env bash

if [ -e /var/run/gpclient.lock ]; then
    sudo gpclient disconnect
else
    gpauth --browser vivaldi chvpn.tempus.com | sudo gpclient connect chvpn.tempus.com --no-dtls --cookie-on-stdin | tee "$HOME"/.cache/gpclient.log &
fi
