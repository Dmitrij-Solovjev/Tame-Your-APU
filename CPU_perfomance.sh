#!/bin/bash
# Configure processor
# https://github.com/FlyGoat/RyzenAdj

#notify-send -i /usr/share/icons/hicolor/48x48/apps/org.gnome.BrowserConnector.png "ONDEMAND CPU MODE ON"

ryzenadj --tctl-temp=80 --fast-limit=65000 --slow-limit=55000 --gfx-clk=800
#notify-send "Включён производительный режим"
powerprofilesctl set performance
