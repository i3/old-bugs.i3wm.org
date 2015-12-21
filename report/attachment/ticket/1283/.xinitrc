#!/bin/sh

while true; do
	urxvt -g 168x52 -name scratchpad \
		-e sh -c 'tmux attach -t dropin || tmux new -s dropin' 
done &
exec pulseaudio --start &
exec feh --bg-scale ~/.background.jpg &
#exec .i3/scripts/angel.sh &
exec setxkbmap de &
~/.i3/scripts/checkMonitors.sh 
exec i3 --shmlog-size=26214400
