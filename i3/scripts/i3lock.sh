#!/bin/bash

tmpbg='/tmp/blr.png'
icon="$HOME/.i3/local.d/lock.png"

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

# use -u flag to hide unlock indicator
i3lock -e -i "$tmpbg"
