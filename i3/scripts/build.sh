#!/bin/bash

# Script that creates the i3 window manager config.
# It combines local settings (~/.i3/local.d/*) with
# the base config (base.cfg, theme.cfg) from github.

# Changes to this file affect the github repository.

# The shortcut to run this script is [Win]+[Shift]+[C].

config="$HOME/.i3/config"

cat << EOF > "$config"
##########################################################################
# THIS FILE IS GENERATED AUTOMATICALLY. ANY CHANGES WILL BE OVERWRITTEN! #
##########################################################################

# Local settings for this computer (e.g. autostart, monitors, statusline)
# can be found in '~/.i3/local.d/'. 
# '~/.i3/base.cfg' contains the basic i3wm configuration and is synchronized
# with the github repository.



#####################
# HARDWARE SETTINGS #
#####################

EOF

cat "$HOME/.i3/local.d/environment.cfg" >> "$config"

cat << EOF >> "$config"


##############################
# i3 WINDOW MANAGER SETTINGS #
##############################

EOF

cat "$HOME/.i3/theme.cfg" >> "$config"
echo "" >> "$config"
cat "$HOME/.i3/base.cfg" >> "$config"

cat << EOF >> "$config"


###################################
# AUTOSTART and PROGRAM SHORTCUTS #
###################################

EOF

cat "$HOME/.i3/local.d/autostart.cfg" >> "$config"
