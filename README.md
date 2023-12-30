# Tame-Your-APU
Control the consumption of CPU and iGPU with standard udev methods in various usage scenarios.
The main intent of this guide is to provide maximum performance when the charger is plugged in and maximum battery life otherwise.
# Requirements
  * APU AMD
  * Installed [RyzenAdj](https://github.com/FlyGoat/RyzenAdj)
# Installation
```
sudo udevadm info --path=/sys/class/power_supply/ACAD
sudo udevadm info --path=/sys/class/power_supply/BAT0
```
Get information about the AC and BATTERY systems. Like this:
```
P: /devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ACAD
M: ACAD
U: power_supply
E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ACAD
E: SUBSYSTEM=power_supply
E: POWER_SUPPLY_NAME=ACAD
E: POWER_SUPPLY_TYPE=Mains
E: POWER_SUPPLY_ONLINE=0
```
Make file ```80.power.rules``` in ```/etc/udev/rules.d/``` or copy with ```sudo cp YOUR_FILE_DIR/80.power.rules /etc/udev/rules.d/80.power.rules```:
```
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="/bin/sh PRESET_DIR/CPU_config.sh"
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="/bin/sh PRESET_DIR/CPU_config.sh"
```
Make file ```CPU_config.sh``` in ```PRESET_DIR```:
```
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
```
## If you want auto-apply on startup with systemd:
 Use ```CPU_config.service```

## If you want auto-apply on startup with openrc:
 Use ```CPU_config.timer```. Put file in dir ```/etc/init.d/``` and run ```rc-update add CPU_config```. power-profile-daemon must be installed in your system.

# Warning
## Be careful and read the RyzenAdj documentation first. I am not responsible for your damage, do so at your own risk.

# Links
  * https://unix.stackexchange.com/questions/227918/system-event-on-ac-adapter-insert-or-battery-unplugged
  * https://github.com/OpenRC/openrc/blob/master/service-script-guide.md
