#!/bin/bash
grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Capture copied to clipboard!"
