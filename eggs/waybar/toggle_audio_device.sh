#!/bin/bash

speakers="$(wpctl status -k | grep -E "ALC[0-9]+ Analog" -m1 | grep -oE "[0-9]+" | head -n1)"
headset="$(wpctl status -k | grep -E "USB Audio #1" -m2 | tail -n1 | grep -oE "[0-9]+" | head -n1)"

if wpctl status | grep "\*" | grep -q "$speakers."; then
    wpctl set-default $headset
else
    wpctl set-default $speakers
fi
