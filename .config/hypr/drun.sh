#!/bin/sh
pidof wofi && kill $(pidof wofi) || wofi --show drun --allow-images -i
