#!/bin/sh
pidof wofi && kill $(pidof wofi) && exit 0;

IFS=$'\n' read -d '' -r -a ids < <(rbw list --fields id)
IFS=$'\n' read -d '' -r -a names < <(rbw list --fields name,user)
pos=$(printf "%s\n" "${names[@]}" | wofi -i --show dmenu -M fuzzy)

rbw code "${ids[$pos]}" | wl-copy
