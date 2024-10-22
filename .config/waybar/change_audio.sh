#!/bin/sh

stereo=$(pw-cli i alsa_output.pci-0000_00_1f.3.analog-stereo | grep -oP 'id: \K\w+')
headphones=$(pw-cli i alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.iec958-stereo | grep -oP 'id: \K\w+')


if wpctl status | grep "*" | grep $stereo > /dev/null;
then
  wpctl set-default $headphones 
else
  wpctl set-default $stereo 
fi
