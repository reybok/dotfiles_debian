#!/bin/bash

pactl list short sinks | sed --quiet 's/\([0-9][0-9]*\).*/pactl set-sink-mute \1 toggle/ge' 
pkill -RTMIN+1 i3blocks
