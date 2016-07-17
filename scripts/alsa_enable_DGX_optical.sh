#!/bin/bash
# This script enables the S/PDIF (optical) output for a Xonar DGX card

cat /proc/asound/cards | sed --quiet 's/\([0-9][0-9]*\).*DGX.*/ amixer -c \1 set IEC958,0 unmute /ge'
