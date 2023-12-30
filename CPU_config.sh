#!/bin/bash

if [[ `cat /sys/class/power_supply/ACAD/online` == 1 ]]; then
  /home/dima/.config/autostart/CPU_perfomance.sh
else
  /home/dima/.config/autostart/CPU_powersave.sh
fi
