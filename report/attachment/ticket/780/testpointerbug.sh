#!/bin/bash

# needs xdotool to move the mouse

# run this and move the mouse into the right screen.
# if will be set back to the left screen
# try moving with different speeds to trigger the bug

x1=1919		# set this to your leftmost screen width - 1
y1=300
delay=0.1


function readpos() {
	pos=`xdotool getmouselocation --shell 2>/dev/null`
	for p in ${pos}; do
		let ${pos}
	done
}

readpos
while [[ 1 ]]; do
	xdotool mousemove ${x1} ${y1}
	xdotool sleep ${delay}
	readpos

	let deltay=${Y}-${y1}

	# the y-coordinate changed, we got warped
	if [[ "${deltay}" -gt "100" ]]; then
		break
	fi
done
