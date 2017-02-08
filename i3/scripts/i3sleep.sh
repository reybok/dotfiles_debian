#!/usr/bin/env bash

# default value is 30 minutes
default=30
timer=${1:-$default}

# allow only positive integers as argument
if ! [[ $timer =~ ^[0-9]+$ ]]; then
  timer=$default
fi

# send system to sleep after x minutes
echo 'DISPLAY=:0 i3-msg -q exec ~/.i3/scripts/i3lock.sh && sleep 0.2 && DISPLAY=:0 i3-msg -q exec systemctl suspend' | at now + $timer minutes > /dev/null 2>&1
