#!/bin/bash
# Configure processor
# https://github.com/FlyGoat/RyzenAdj


ryzenadj --tctl-temp=60 --slow-limit=8000 --fast-limit=12000 --gfx-clk=200
#notify-send "Включён энергоэффективный режим"
