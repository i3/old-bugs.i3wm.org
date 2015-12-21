#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
#xinit /usr/bin/gnome-session

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

DISPLAY=:0.1 i3 -V -d all -c /home/christian/.i3/config2 >>~/.i3/i3log2 2>&1 &
exec i3 -V -d all >>~/.i3/i3log 2>&1

#exec gnome-session
