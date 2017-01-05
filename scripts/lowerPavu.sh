#!/bin/bash

pactl list short sinks | sed --quiet 's/\([0-9][0-9]*\).*/pactl set-sink-volume \1 -5%/ge' 
pkill -RTMIN+1 i3blocks
