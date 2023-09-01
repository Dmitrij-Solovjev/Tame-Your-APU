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
P: /devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ACAD
M: ACAD
U: power_supply
E: DEVPATH=/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ACAD
E: SUBSYSTEM=power_supply
E: POWER_SUPPLY_NAME=ACAD
E: POWER_SUPPLY_TYPE=Mains
E: POWER_SUPPLY_ONLINE=0
```

# Links
  * https://unix.stackexchange.com/questions/227918/system-event-on-ac-adapter-insert-or-battery-unplugged
