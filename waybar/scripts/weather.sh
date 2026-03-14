#!/bin/bash

CITY="São Paulo"
DATA=$(curl -sf "wttr.in/${CITY// /+}?format=%C+%t" 2>/dev/null)

if [ -z "$DATA" ]; then
    echo "󰼯 --"
    exit
fi

CONDITION=$(echo "$DATA" | sed 's/ [+-]*[0-9]*°C//' | tr '[:upper:]' '[:lower:]')
TEMP=$(echo "$DATA" | grep -oP '[-]?\d+°C')

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

echo "$ICON $TEMP"
