#!/usr/bin/env bash

if [ -e /var/run/gpclient.lock ]; then
    sudo gpclient disconnect
else
    gpauth --browser vivaldi --gateway chvpn.tempus.com | sudo gpclient connect --as-gateway chvpn.tempus.com --no-dtls --cookie-on-stdin | tee "$HOME"/.cache/gpclient.log &
fi
