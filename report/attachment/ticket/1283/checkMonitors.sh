#!/bin/bash
XRANDR=`xrandr`

if [[ $XRANDR == *"HDMI1 conn"* ]]; then
p
	xrandr --output LVDS1 --off --output HDMI1 --auto &
elif [[ $XRANDR == *"VGA1 conn"* ]]; then
	xrandr --output LVDS1 --off --output VGA1 --auto &
else
	echo nothing to do
	xrandr --output LVDS1 --auto --nograb &
fi
exit 
