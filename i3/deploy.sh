#!/bin/bash

# 1. copy the following assets:

resources/lock.png -> i3/local.d/
resources/wallpaper.jpg -> i3/local.d/

  #make those desktop/notebook specific
templates/i3blocks.tpl -> i3/local.d/
templates/autostart.tpl -> i3/local.d/autostart.cfg
templates/environment.tpl -> i3/local.d/environment.cfg
	- $outputPrimary
	- $outputSecondary
	- $outputProjector
	- xrandr command
	- Treiber/Hardware settings (z.B. Soundkarte, Netzwerkkarte)


# 2. symlink the following files:

blocklets/ -> i3/blocklets/
scripts/ -> i3/scripts/
README.TXT -> i3/
base.cfg -> i3/
theme.cfg -> i3/
(build.sh is contained in scripts/ )
