#!/usr/bin/env bash

if [ -e /var/run/gpclient.lock ]; then
    echo '{"text": "Connected", "alt": "connected", "tooltip":"Connected", "class":"connected", "percentage":""}'
else
    echo '{"text": "Disconnected", "alt": "disconnected", "tooltip":"Disconnected", "class":"disconnected", "percentage":""}'
fi
