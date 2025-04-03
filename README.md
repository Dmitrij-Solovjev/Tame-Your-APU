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
Create file ```80.power.rules``` in ```/etc/udev/rules.d/```:
```sudo nano /etc/udev/rules.d/80.power.rules```:
```
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="power_mode.service"
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_STATUS}=="Discharging", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="power_mode.service"
```

Create file ```50-power-profiles.rules``` in ```/etc/polkit-1/rules.d/```:
```sudo nano/etc/polkit-1/rules.d/50-power-profiles.rules```:
```
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.UPower.PowerProfiles.switch-profile" &&
        subject.isInGroup("power")) {
        return polkit.Result.YES;
    }
});
```
Create new group and add user to it:
```
sudo groupadd power
sudo usermod -aG power $USER
```


Make file ```CPU_config.sh``` in ```PRESET_DIR```:
```
#!/bin/bash
#CPU_config.sh

if [[ `cat /sys/class/power_supply/ACAD/online` == 1 ]]; then
   notify-send "Изменение подключения" "Включён производительный режим"
   #powerprofilesctl set performance
   powerprofilesctl set balanced
   #ryzenadj --tctl-temp=80 --fast-limit=65000 --slow-limit=55000 --gfx-clk=200
else
   notify-send "Изменение подключения" "Включён энергоэффективный режим"
   powerprofilesctl set power-saver
   #ryzenadj --tctl-temp=60 --slow-limit=8000 --fast-limit=12000 --gfx-clk=200
fi

/usr/bin/python3 ./change_screen_refresh_rate.py

```
## If you want auto-apply on startup with systemd:
```sudo nano /etc/systemd/system/power_mode.service```
```
[Unit]
Description=Скрипт настройки производительности при изменении состояния питания

[Service]
Type=oneshot
ExecStart=/home/dima/.config/autostart/CPU_config.sh
Environment=DISPLAY=:0
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
WorkingDirectory=/home/dima/.config/autostart
User=YOUR_USER
Group=YOUR_USER
TimeoutSec=30

[Install]
WantedBy=multi-user.target

```


## If you want auto-apply on startup with openrc:
 Use ```CPU_config.timer```. Put file in dir ```/etc/init.d/``` and run ```rc-update add CPU_config```. power-profile-daemon must be installed in your system.

# Warning
## Be careful and read the RyzenAdj documentation first. I am not responsible for your damage, do so at your own risk.

# Links
  * https://unix.stackexchange.com/questions/227918/system-event-on-ac-adapter-insert-or-battery-unplugged
  * https://github.com/OpenRC/openrc/blob/master/service-script-guide.md
