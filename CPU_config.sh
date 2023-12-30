#!/bin/bash

if [[ `cat /sys/class/power_supply/ACAD/online` == 1 ]]; then
   notify-send "Включён производительный режим"
   #powerprofilesctl set performance
   powerprofilesctl set balanced
   ryzenadj --tctl-temp=80 --fast-limit=65000 --slow-limit=55000 --gfx-clk=200
else
   notify-send "Включён энергоэффективный режим"
   powerprofilesctl set power-saver
   ryzenadj --tctl-temp=60 --slow-limit=8000 --fast-limit=12000 --gfx-clk=200
fi
