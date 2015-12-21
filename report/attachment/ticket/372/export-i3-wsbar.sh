#!/bin/bash

bar_values=`cat ~/.i3/config | grep "bar\." | sed "s/#//g"`
bar_focused=`echo "${bar_values}" | grep "[^un]focused" | awk '{ print $3 " " $4 }'`
bar_unfocused=`echo "${bar_values}" | grep "unfocused" | awk '{ print $3 " " $4 }'`
bar_urgent=`echo "${bar_values}" | grep "urgent" | awk '{ print $3 " " $4 }'`

export I3_WSBAR_FOCUSED_BG=`echo ${bar_focused} | awk '{ print $1 }'`
export I3_WSBAR_FOCUSED_FG=`echo ${bar_focused} | awk '{ print $2 }'`
export I3_WSBAR_UNFOCUSED_BG=`echo ${bar_unfocused} | awk '{ print $1 }'`
export I3_WSBAR_UNFOCUSED_FG=`echo ${bar_unfocused} | awk '{ print $2 }'`
export I3_WSBAR_URGENT_BG=`echo ${bar_urgent} | awk '{ print $1 }'`
export I3_WSBAR_URGENT_FG=`echo ${bar_urgent} | awk '{ print $2 }'`

