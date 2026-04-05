#!/bin/bash

CITY="Brasilia"

DATA=$(curl -sf -m 15 "http://wttr.in/${CITY}?format=j1" 2>/dev/null)

if [ -z "$DATA" ]; then
    echo "󰼯 --"
    exit 0
fi

CONDITION=$(echo "$DATA" | jq -r '.current_condition[0].weatherDesc[0].value' | tr '[:upper:]' '[:lower:]')
TEMP=$(echo "$DATA" | jq -r '.current_condition[0].temp_C')

case "$CONDITION" in
    *sunny*|*clear*)                ICON="󰖙" ;;
    *partly*cloud*|*partly*sunny*)  ICON="󰖕" ;;
    *cloud*|*overcast*)             ICON="󰖐" ;;
    *rain*|*drizzle*|*shower*)      ICON="󰖗" ;;
    *thunder*|*storm*)              ICON="󰖓" ;;
    *snow*|*sleet*|*blizzard*)      ICON="󰖘" ;;
    *fog*|*mist*|*haze*)            ICON="󰖑" ;;
    *wind*)                         ICON="󰖝" ;;
    *)                              ICON="󰖔" ;;
esac

echo "$ICON ${TEMP}°C"
