DON'T TRY TO CHANGE THE 'config' FILE SINCE IT WILL BE OVERWRITTEN ON EVERY REBUILD!

Changes to the following files affect the LOCAL settings:
	local.d/lock.png 	       Shown during lockscreen. PNG only!
	local.d/wallpaper.jpg 	       The wallpaper. JPG only!
	local.d/i3blocks.cfg	       Which blocklets are shown and their order. Default 
                                       blocklets or those from the blocklets/ folder can be used.
	local.d/autostart.cfg	       Which programs and tray applications start together 
                                       with i3wm
	local.d/environment.cfg        Monitor and other hardware settings

Changes to the following files affect the DOTFILES on GITHUB! 
	blocklets/*		       All blocklets can be used in the i3blocks.cfg
	scripts/*		       Scripts will be called with keybindings from the base.cfg
	base.cfg		       Workspaces and key bindings
	theme.cfg		       Colors and Font
	README.TXT		       This file with warnings and hints

After changing the i3blocks.cfg, restarting i3wm will load the updates.
AFTER CHANGING ANY OTHER *.cfg FILE, YOU NEED TO RUN THE build.sh SCRIPT 
(Shortcut [Win]+[Shift]+[C]) TO CREATE THE NEW config FILE!

