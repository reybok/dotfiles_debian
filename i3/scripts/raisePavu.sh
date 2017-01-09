#!/bin/bash

# TODO: delta als variable mit default wert 5%, sodass auch kleine Schritte mgl. sind

pactl list short sinks | sed --quiet 's/\([0-9][0-9]*\).*/pactl set-sink-volume \1 +5%/ge' 
pkill -RTMIN+1 i3blocks
