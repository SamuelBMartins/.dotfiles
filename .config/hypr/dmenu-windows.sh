#!/bin/sh
pidof wofi && kill $(pidof wofi) && exit 0;

addresses=($(hyprctl clients -j | jq -r '.[] | (.address | tostring)'))
pos=$(hyprctl clients -j | jq -r '.[] | (.class + " - " + .title)' | wofi -i --show dmenu)

[ $? = 0 ] && hyprctl dispatch focuswindow address:${addresses[$pos]}
