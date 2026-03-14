#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

RAM=$(free | awk '/Mem:/ {printf "%d", $3/$2 * 100}')

TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
if [ -n "$TEMP" ]; then
    TEMP=$(( TEMP / 1000 ))
    TEMP_STR="${TEMP}°C"
else
    TEMP_STR="--"
fi

echo "󰍛 ${CPU}%  󰘚 ${RAM}%  󰔏 ${TEMP_STR}"
